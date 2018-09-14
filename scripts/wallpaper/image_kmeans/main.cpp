#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include <float.h> // limits
#include <time.h> // random

#include "kmeans.h"
#include "dataTypes.h"
#include "CImg.h"

void plotPoints(struct point2D *list_of_points, size_t size, size_t k);

/*
 * Deprecated
 */
struct point2D *readPointsFromFile(char *filename, int numPoints) {

    // llegim un fitxer de punts 2D, ara per ara
    struct point2D *list_of_points = (struct point2D *) malloc(sizeof(struct point2D) * numPoints);

    FILE *f = fopen(filename, "r");
    if (!f) { printf("Can't open %s file\n", filename); exit(1); }

    char *buffer = (char *) malloc(sizeof(char) * 40); // size of 1 line
    uint8_t  flag = 0;
    uint32_t counter = 0;

    while (fgets(buffer, 40, f)) {
        // file pattern: x1\ny1\nx2\ny2\n...
        if (flag == 0) { // we are in x mode
            list_of_points[counter].x = atof(buffer);
            flag = 1;
        } else {
            list_of_points[counter].y = atof(buffer);
            list_of_points[counter].distance = FLT_MAX;
            list_of_points[counter].group = -1;
            flag = 0;
            counter++;
        }
    }
    fclose(f);
    if (flag) {
        printf("Missing points. The file is corrupted\n");
        exit(1);
    }
    return list_of_points;
}

int main(int argc, char **argv)
{
    size_t i, j, l;

    if (argc != 3) {
        printf("Usage: %s image num_colors\n", argv[0]);
        exit(1);
    }

    cimg_library::CImg<uint8_t> *image = new cimg_library::CImg<uint8_t>(argv[1]);
    size_t numPixels = image->height() * image->width();
    
    struct point3D *list_of_points = (struct point3D *) malloc(sizeof(struct point3D) * numPixels);
    if (!list_of_points) {
        printf("Could not allocate memory. Exiting\n");
        exit(EXIT_FAILURE);
    }

    // put each pixel in the struct point3D
    for (j = 0; j < image->height(); j++) {
        for (i = 0; i < image->width(); i++) {
            list_of_points[j * image->width() + i].x = (float) (*image)(i, j, 0, 0);
            list_of_points[j * image->width() + i].y = (float) (*image)(i, j, 0, 1);
            list_of_points[j * image->width() + i].z = (float) (*image)(i, j, 0, 2);
            list_of_points[j * image->width() + i].distance = FLT_MAX;
            list_of_points[j * image->width() + i].group = -1;
        }
    }
    

    size_t k = atoi(argv[2]);
    struct point3D *centroids = kmeans3D(list_of_points, numPixels, k);
    float *luminosity = (float *) malloc(sizeof(float) * k);

    printf("Kmeans DONE\n");

    for (i = 0; i < k; i++) {
        //printf("Centroid %lu with color [%.2f %.2f %.2f]", i, centroids[i].x, centroids[i].y, centroids[i].z);
        luminosity[i] = 0.299 * centroids[i].x + 0.587 * centroids[i].y + 0.114 * centroids[i].z;
        //printf(": %.2f\n", luminosity[i]);
    }

    float  min;
    size_t idx = 0;
    //cimg_library::CImg<uint8_t> *out = new cimg_library::CImg<uint8_t>(100*k, 100, 1, 3);
    FILE *out_points = fopen("points.txt", "w");
    if (!out_points) {
        printf("Could not open points.txt. Exiting\n");
    }
    // order by luminostiy, and generate a nice output image
    for (i = 0; i < k; i++) {
        // find first min:
        min = FLT_MAX;
        for (j = 0; j < k; j++) {
            if (luminosity[j] < min) {
                min = luminosity[j];
                idx = j;
            }
        }
        luminosity[idx] = FLT_MAX;
        //printf("lum: %10.2f, i: %lu\n", min, idx);
        // plot color
        for (j = i*100; j < i*100 + 100; j++) { // columnes
            for (l = 0; l < 100; l++) {
                //(*out)(j, l, 0, 0) = (uint8_t) centroids[idx].x;
                //(*out)(j, l, 0, 1) = (uint8_t) centroids[idx].y;
                //(*out)(j, l, 0, 2) = (uint8_t) centroids[idx].z;
            }
        }
        fprintf(out_points, "#%02x%02x%02x\n", (uint8_t) centroids[idx].x,
                                               (uint8_t) centroids[idx].y,
                                               (uint8_t) centroids[idx].z);

    }
    fclose(out_points);

    //out->save_png("out.png");

    //plotPoints(list_of_points, numPixels, k);

    // print the points
    //for (i = 0; i < counter; i++) {
    //    printf("%f\t%f\t%f\t%d\n",list_of_points[i].x, list_of_points[i].y,
    //                              list_of_points[i].distance, list_of_points[i].group);
    //}

    return 0;
}

void plotPoints(struct point2D *list_of_points, size_t size, size_t k)
{
    size_t i, j;

    FILE *gnuplot = popen("gnuplot", "w");
    if (!gnuplot) { printf("Gnuplot could not be opened. It is installed?\n"); exit(1); }

    // plot the graph to an image
    fprintf(gnuplot, "set terminal pngcairo\n");
    fprintf(gnuplot, "set output \"plot.png\"\n");

    // dump list_of_points to a file for gnuplot
    uint8_t first = 1;
    for (i = 0; i < k; i++) {

        // creating a file in which we will put all points corresponding to cluster i
        char *filename = (char *) malloc(sizeof(char) * 10);
        sprintf(filename, ".tmp%lu", i);
        FILE *tmp = fopen(filename, "w");
        if (!tmp) { printf("I don't have write permissions... fix me!\n"); exit(1); }

        // writing the points
        for (j = 0; j < size; j++) {
            if (list_of_points[j].group == i) {
                fprintf(tmp, "%f %f\n", list_of_points[j].x, list_of_points[j].y);
            }
        }
        fclose(tmp);

        // plotting the points
        if (first) {
            first = 0;
            fprintf(gnuplot, "plot \"%s\" using 1:2 lc rgb \"%s\"", filename, colors[i]);
        } else {
            fprintf(gnuplot, ", \"%s\" using 1:2 lc rgb \"%s\"", filename, colors[i]);
        }
    }
    fprintf(gnuplot, "\n");
    fprintf(gnuplot, "quit\n");
    pclose(gnuplot);
}
