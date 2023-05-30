#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "grey.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

void toGray(unsigned char* gray_im,unsigned char *imageData, int width, int height) {
    int i, j;
    unsigned char *pixel;
    for (i = 0; i < height; i++) {
        for (j = 0; j < width; j++) {
            pixel = imageData + (i * width + j) * 3;
            unsigned char red = pixel[0];
            unsigned char green = pixel[1];
            unsigned char blue = pixel[2];
            unsigned char gray = (red + green + blue) / 3;
            gray_im[i*width+j] = gray;
        }
    }
}

void process (char*output_file, void (*gray_func)(unsigned char*, unsigned char*, int, int), 
            int width, int height, unsigned char* image, unsigned char* gray_im) {
    printf("Image size:%dx%d\n", width, height);
    clock_t start_c, end_c;
    double time_c;
    start_c = clock();
    gray_func(gray_im, image, width, height);
    end_c = clock();
    printf("Time:%lf\n", (double)(end_c-start_c)/CLOCKS_PER_SEC);
    stbi_write_bmp(output_file, width, height, 1, gray_im);
}   

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Enter input (1) and output(2) name of files\n");
        return 1;
    }
    //char* input_file = "input.bmp";
    //char* output_file = "output.bmp";
    int width, height, channels;
    unsigned char *image = stbi_load(argv[1], &width, &height, &channels, 0);
    unsigned char *gray_im1 = (unsigned char *)malloc(width * height * sizeof(unsigned char));
    unsigned char *gray_im2 = (unsigned char *)malloc(width * height * sizeof(unsigned char));
    
    if (image == NULL) {
        printf("Error load image\n");
        return 1;
    }
    printf("Using c function:\n");
    process(argv[2], toGray, width, height, image, gray_im1);
    printf("Using asm function:\n");
    process(argv[3], toGray2, width, height, image, gray_im2);

    free(image);
    free(gray_im1);
    free(gray_im2);
    
    return 0;
}
