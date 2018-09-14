#ifndef DATA_TYPES_H
#define DATA_TYPES_H

#include <stdint.h>

struct point2D {
    float x;
    float y;
    float distance;
    uint32_t group;
};

struct point3D {
    float x;
    float y;
    float z;
    float distance;
    uint32_t group;
};

static char *colors[] = {"#ff0000", "#0000ff", "#00ff00",
                         "#ff8000", "#8000ff", "#00ff80",
                         "#ffff00", "#00ffff", "#ff00bf"};

#endif
