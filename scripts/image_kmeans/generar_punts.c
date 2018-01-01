#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char **argv)
{
    if (argc != 2) {
        printf("Usage: %s number_of_points\n", argv[0]);
        exit(1);
    }
    FILE *f = fopen("points.txt", "w");
    if (!f) {
        printf("I have not write permissions!\n");
        exit(1);
    }

    int i;
    srand(time(NULL));
    for (i = 0; i < atoi(argv[1]) * 2; i++) {
        fprintf(f, "%f\n", (float)(rand() % 10000) / 100.0f);
    }
    fclose(f);

    return 0;
}
