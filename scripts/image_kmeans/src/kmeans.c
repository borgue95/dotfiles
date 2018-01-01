#include <stdlib.h>
#include <math.h>
#include <time.h>

#include "kmeans.h"
#include "dataTypes.h"

void kmeans2D(struct point2D *list_of_points, size_t size, size_t k)
{
    size_t i, j, l;

    // pick k random points from the list
    srand(time(NULL));
    struct point2D *centroids = (struct point2D *) malloc(sizeof(struct point2D) * k);
    for (i = 0; i < k; i++) {
        centroids[i] = list_of_points[rand() % size];
    }

    size_t iterations = 10;
    for (l = 0; l < iterations; l++) {

        // compute the euclidian distance to all centroids for all points
        for (i = 0; i < size; i++) { // for all points
            for (j = 0; j < k; j++) { // for all centroids
                float d = distance2D(list_of_points[i],centroids[j]);
                if (d < list_of_points[i].distance) {
                    list_of_points[i].distance = d;
                    list_of_points[i].group = j;
                }
            }
        }

        // move centroid
        for (j = 0; j < k; j++) { // for each centroid, move it

            // 2D
            float sumx = 0;
            float sumy = 0;
            int count = 0;

            // iterate only with the points in that group (j)
            for (i = 0; i < size; i++) { // for each point
                if (list_of_points[i].group == j) {
                    sumx += list_of_points[i].x;
                    sumy += list_of_points[i].y;
                    count++;
                }
            }

            // update centroid
            centroids[j].x = sumx / count;
            centroids[j].y = sumy / count;
        }
    }
}

float distance2D(struct point2D p, struct point2D q) {
    return sqrt((p.x-q.x)*(p.x-q.x) + (p.y-q.y)*(p.y-q.y));
}

/*
 * 3D
 */
struct point3D *kmeans3D(struct point3D *list_of_points, size_t size, size_t k)
{
    size_t i, j, l;

    // pick k random points from the list
    srand(time(NULL));
    struct point3D *centroids = (struct point3D *) malloc(sizeof(struct point3D) * k);
    for (i = 0; i < k; i++) {
        centroids[i] = list_of_points[rand() % size];
    }

    size_t iterations = 10;
    for (l = 0; l < iterations; l++) {

        // compute the euclidian distance to all centroids for all points
#pragma omp parallel for private(j)
        for (i = 0; i < size; i++) { // for all points
            for (j = 0; j < k; j++) { // for all centroids
                float d = distance3D(list_of_points[i],centroids[j]);
                if (d < list_of_points[i].distance) {
                    list_of_points[i].distance = d;
                    list_of_points[i].group = j;
                }
            }
        }

        // move centroid
        for (j = 0; j < k; j++) { // for each centroid, move it

            // 3D
            float sumx = 0;
            float sumy = 0;
            float sumz = 0;
            int count = 0;

            // iterate only with the points in that group (j)
            for (i = 0; i < size; i++) { // for each point
                if (list_of_points[i].group == j) {
                    sumx += list_of_points[i].x;
                    sumy += list_of_points[i].y;
                    sumz += list_of_points[i].z;
                    count++;
                }
            }

            // update centroid
            centroids[j].x = sumx / count;
            centroids[j].y = sumy / count;
            centroids[j].z = sumz / count;
        }
    }
    return centroids;
}

float distance3D(struct point3D p, struct point3D q) {
    return sqrt((p.x-q.x)*(p.x-q.x) + (p.y-q.y)*(p.y-q.y) + (p.z-q.z)*(p.z-q.z));
}
