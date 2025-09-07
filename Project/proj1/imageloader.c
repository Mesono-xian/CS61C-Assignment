/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE *fp = fopen(filename,"r");
	Image *im = (Image*)malloc(sizeof(Image));
	char head[3];
	int col,row,max_val;
	fscanf(fp,"%s %d %d %d",head,&im->cols,&im->rows,&max_val);
	col = im->cols;
    row = im->rows;
    int r,g,b;
    //REMEMBER:malloc for the color!
    im->image = (Color**)malloc(row * sizeof(Color*));
    for(int r=0;r<row;r++)
    {
        im->image[r] = (Color*)malloc(col * sizeof(Color));
    }
    for(int i=0;i<row;i++)
    {
        for(int j=0;j<col;j++)
        {
            fscanf(fp,"%d %d %d",&r,&g,&b);
            im->image[i][j].R = r;
            im->image[i][j].G = g;
            im->image[i][j].B = b;
        }
    }
    fclose(fp);
    return im;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n");
	printf("%d %d\n",image->cols,image->rows);
	printf("255\n");
	for(int i=0;i<image->rows;i++)
	{
		for(int j=0;j<image->cols;j++)
		{
			printf("%3d %3d %3d",image->image[i][j].R,image->image[i][j].G,image->image[i][j].B);
			if(j < image->cols-1)
				printf("   ");
		}
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	for(int r=0;r<image->rows;r++)
	{
		free(image->image[r]);
	}
	free(image->image);
	free(image);
}