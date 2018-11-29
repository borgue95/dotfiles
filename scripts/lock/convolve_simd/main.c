#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <xmmintrin.h> // sse
#include <immintrin.h> // avx

#include "png_manager/png_manager.h"
#include "time_utils/time_utils.h"

float* get_gaussian_matrix(int size, float sigma)
{
    if (sigma == 0.0) {
        sigma = 1.0;
    }

    float norm = 1.0 / (2 * M_PI * sigma * sigma);
    float deno = 1.0 / (2 * sigma * sigma);

    float *mask = malloc(sizeof(float) * size * size);
    int mask_pos = 0;
    float acum = 0.0;
    for (int n = -size/2; n <= size/2; n++) {
        for (int m = -size/2; m <= size/2; m++) {
            mask[mask_pos] = norm * exp(-(n*n+m*m)*deno);
            acum += mask[mask_pos];
            mask_pos++;
        }
    }

    for (int i = 0; i < size * size; i++) {
        mask[i] /= acum;
    }

    return mask;
}

__m128 *get_simd_mask(float *mask, int size)
{
    __m128 *simd_mask = _mm_malloc(sizeof(__m128) * size * size, sizeof(__m128));
    for (int i = 0; i < size*size; i++) {
        simd_mask[i] = _mm_set_ps1(mask[i]);
    }

    return simd_mask;
}

__m256 *get_simd256_mask(float *mask, int size)
{
    __m256 *simd_mask = _mm_malloc(sizeof(__m256) * size * size, sizeof(__m256));
    for (int i = 0; i < size*size; i++) {
        simd_mask[i] = _mm256_set1_ps(mask[i]);
    }

    return simd_mask;
}

float *matrix_to_vector(uint8_t **matrix, int h, int row_size)
{
    float *rawdata = malloc(sizeof(float) * h * row_size);
    for (int i = 0; i < h; i++) {
        for (int j = 0; j < row_size; j++) {
            rawdata[i * row_size + j] = (float) matrix[i][j];
        }
    }

    return rawdata;
}

void fill_the_borders(struct pngm *pngm, int mask_size, uint8_t *result)
{
    for (int i = 0; i < pngm->h; i++) {
        for (int j = 0; j < pngm->row_size; j++) {
            int real_i = i;
            int real_j = j;
            int do_it = 0;
            if (i < mask_size/2) {
                real_i = mask_size/2;
                do_it = 1;
            }
            if (i >= pngm->h - mask_size/2) {
                real_i = pngm->h - mask_size/2 - 1;
                do_it = 1;
            }
            if (j/pngm->color_type < mask_size/2) {
                real_j = mask_size/2 * pngm->color_type + j % pngm->color_type;
                do_it = 1;
            }
            if (j/pngm->color_type >= pngm->w - mask_size/2) {
                real_j = pngm->row_size - (mask_size/2 + 1) * pngm->color_type + j % pngm->color_type;
                do_it = 1;
            }
            if (do_it) {
                int color_pos = real_i * pngm->row_size + real_j;
                int result_pos = i * pngm->row_size + j;
                result[result_pos] = result[color_pos];
            }
        }
    }

}

void convolve_naive(const char *input, const char *output, int mask_size)
{
    struct pngm *pngm = read_png(input);

    int row_size = pngm->row_size;
    float *rawdata = matrix_to_vector(pngm->row_pointers, pngm->h, pngm->row_size);
    uint8_t *result = malloc(sizeof(uint8_t) * pngm->h * row_size); 

    float *mask = get_gaussian_matrix(mask_size, mask_size/4);

    TimeSpent *right_now = initTime();
    start_counting_time(right_now);

    int row_start = mask_size/2;
    int row_end   = pngm->h - mask_size/2;
    int col_start = mask_size/2 * pngm->color_type;
    int col_end   = row_size - mask_size/2 * pngm->color_type;

    // for each pixel in the image
    for (int i = row_start; i < row_end; i++) {
        for (int j = col_start; j < col_end; j++) {
            // for each pixel in the mask
            float acum = 0;
            int mask_pos = 0;
            for (int n = -mask_size/2; n <= mask_size/2; n++) {
                for (int m = -mask_size/2; m <= mask_size/2; m++) {
                    int img_pos = (i+n) * row_size + (j + pngm->color_type * m);
                    acum += rawdata[img_pos] * mask[mask_pos];
                    mask_pos++;
                }
            }
            result[i * row_size + j] = (uint8_t)acum;
        }
    }

    stop_counting_time(right_now);
    printf("convolving: %.3lf ms\n", get_time_in_msecs(right_now));

    fill_the_borders(pngm, mask_size, result);

    write_png_color(result, pngm->w, pngm->h, pngm->color_type, output);
    free(rawdata);
    free(result);
    free(mask);
    pngm_destroy(pngm);
}

void convolve_simd(const char *input, const char *output, int mask_size)
//void convolve_simd(const char *filename, int mask_size)
{
    struct pngm *pngm = read_png(input);

    int row_size = pngm->row_size;
    float *rawdata = matrix_to_vector(pngm->row_pointers, pngm->h, pngm->row_size);
    uint8_t *result = malloc(sizeof(uint8_t) * pngm->h * row_size); 

    float *mask = get_gaussian_matrix(mask_size, mask_size/4);
    __m128 *simd_mask = get_simd_mask(mask, mask_size);

    int row_start = mask_size/2;
    int row_end   = pngm->h - mask_size/2;
    int col_start = mask_size/2 * pngm->color_type;
    int col_end   = row_size - mask_size/2 * pngm->color_type;

    TimeSpent *right_now = initTime();
    start_counting_time(right_now);

    // for each pixel in the image
    for (int i = row_start; i < row_end; i++) {
        for (int j = col_start; j < col_end; j+=4) {
            // for each pixel in the mask
            __m128 acum = _mm_setzero_ps();
            int mask_pos = 0;
            for (int n = -mask_size/2; n <= mask_size/2; n++) {
                for (int m = -mask_size/2; m <= mask_size/2; m++) {
                    int img_pos = (i+n) * row_size + (j + pngm->color_type * m);
                    __m128 rd = _mm_loadu_ps(rawdata + img_pos);
                    __m128 mul = _mm_mul_ps(rd, simd_mask[mask_pos]);
                    acum = _mm_add_ps(acum, mul);
                    mask_pos++;
                }
            }
            // there is no simd instruction to cast 4 floats to 8 uints at the same time
            result[i * row_size + j] = (uint8_t)acum[0];
            result[i * row_size + j+1] = (uint8_t)acum[1];
            result[i * row_size + j+2] = (uint8_t)acum[2];
            result[i * row_size + j+3] = (uint8_t)acum[3];
        }
        // if the to be processed pixels % 4 != 0, I do the rest here
        for (int j = col_end - (col_end - col_start) % 4; j < col_end; j++) {
            // for each pixel in the mask
            float acum = 0;
            int mask_pos = 0;
            for (int n = -mask_size/2; n <= mask_size/2; n++) {
                for (int m = -mask_size/2; m <= mask_size/2; m++) {
                    int img_pos = (i+n) * row_size + (j + pngm->color_type * m);
                    acum += rawdata[img_pos] * mask[mask_pos];
                    mask_pos++;
                }
            }
            result[i * row_size + j] = (uint8_t)acum;
        }

    }

    stop_counting_time(right_now);
    printf("convolving: %.3lf ms\n", get_time_in_msecs(right_now));

    fill_the_borders(pngm, mask_size, result);

    write_png_color(result, pngm->w, pngm->h, pngm->color_type, output);
    _mm_free(rawdata);
    _mm_free(result);
    free(mask);
    _mm_free(simd_mask);
    pngm_destroy(pngm);
}

void convolve_simd256(const char *input, const char *output, int mask_size)
{
    struct pngm *pngm = read_png(input);

    int row_size = pngm->row_size;
    float *rawdata = matrix_to_vector(pngm->row_pointers, pngm->h, pngm->row_size);
    uint8_t *result = malloc(sizeof(uint8_t) * pngm->h * row_size); 

    float *mask = get_gaussian_matrix(mask_size, mask_size/4);
    __m256 *simd_mask = get_simd256_mask(mask, mask_size);

    int row_start = mask_size/2;
    int row_end   = pngm->h - mask_size/2;
    int col_start = mask_size/2 * pngm->color_type;
    int col_end   = row_size - mask_size/2 * pngm->color_type;

    TimeSpent *right_now = initTime();
    start_counting_time(right_now);

    // for each pixel in the image
    for (int i = row_start; i < row_end; i++) {
        for (int j = col_start; j < col_end; j+=8) {
            // for each pixel in the mask
            __m256 acum = _mm256_setzero_ps();
            int mask_pos = 0;
            for (int n = -mask_size/2; n <= mask_size/2; n++) {
                for (int m = -mask_size/2; m <= mask_size/2; m++) {
                    int img_pos = (i+n) * row_size + (j + pngm->color_type * m);
                    __m256 rd = _mm256_loadu_ps(rawdata + img_pos);
                    __m256 mul = _mm256_mul_ps(rd, simd_mask[mask_pos]);
                    acum = _mm256_add_ps(acum, mul);
                    mask_pos++;
                }
            }
            // there is no simd instruction to cast 8 floats to 8 uints at the same time
            result[i * row_size + j] = (uint8_t)acum[0];
            result[i * row_size + j+1] = (uint8_t)acum[1];
            result[i * row_size + j+2] = (uint8_t)acum[2];
            result[i * row_size + j+3] = (uint8_t)acum[3];
            result[i * row_size + j+4] = (uint8_t)acum[4];
            result[i * row_size + j+5] = (uint8_t)acum[5];
            result[i * row_size + j+6] = (uint8_t)acum[6];
            result[i * row_size + j+7] = (uint8_t)acum[7];
        }
        // if the to be processed pixels % 4 != 0, I do the rest here
        for (int j = col_end - (col_end - col_start) % 8; j < col_end; j++) {
            // for each pixel in the mask
            float acum = 0;
            int mask_pos = 0;
            for (int n = -mask_size/2; n <= mask_size/2; n++) {
                for (int m = -mask_size/2; m <= mask_size/2; m++) {
                    int img_pos = (i+n) * row_size + (j + pngm->color_type * m);
                    acum += rawdata[img_pos] * mask[mask_pos];
                    mask_pos++;
                }
            }
            result[i * row_size + j] = (uint8_t)acum;
        }

    }

    stop_counting_time(right_now);
    printf("convolving: %.3lf ms\n", get_time_in_msecs(right_now));

    fill_the_borders(pngm, mask_size, result);

    write_png_color(result, pngm->w, pngm->h, pngm->color_type, output);
    _mm_free(rawdata);
    _mm_free(result);
    free(mask);
    _mm_free(simd_mask);
    pngm_destroy(pngm);
}


int main(int argc, char **argv)
{
    // ./exec input.png output.png mask_size
    if (argc != 4) {
        printf("Wrong arguments!\n");
        printf("Usage: %s input.png output.png mask_size\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    char *input = argv[1];
    char *output = argv[2];
    int mask_size = atoi(argv[3]);

    if (mask_size < 3) {
        printf("Mask size must be 3 or greater\n");
        exit(EXIT_FAILURE);
    }

    if (mask_size % 2 == 0) {
        mask_size++;
    }

    //convolve_naive(input, output, mask_size);
    //convolve_simd(input, output, mask_size);
    convolve_simd256(input, output, mask_size);

    return 0;
}
