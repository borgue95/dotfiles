#ifndef KMEANS_H
#define KMEANS_H

#include <stdint.h>

#include "dataTypes.h"

void kmeans2D(struct point2D *list_of_points, size_t size, size_t k);
struct point3D *kmeans3D(struct point3D *list_of_points, size_t size, size_t k);
float distance2D(struct point2D p, struct point2D q);
float distance3D(struct point3D p, struct point3D q);

#endif
