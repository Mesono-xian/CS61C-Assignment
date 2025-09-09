/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				Sizhuo Li
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"
#define wrap(index,dem) (((index) + (dem)) % (dem))
//get a specific bit of a decimal
int GetBit(int dec,int dig)
{
	return (dec >> dig) & 1;
}
//merge the RGB
int MergeRGB(Color color)
{
	return (color.R << 16) | (color.G << 8) | (color.B);
}
//Get the state of each bit
int GetAlive(Image *image,int x,int y,int dig)
{
	int rows = image->rows;
	int cols = image->cols;
	Color color = image->image[wrap(x,rows)][wrap(y,cols)];
	return GetBit(MergeRGB(color),dig);
}
//Count the number of alive neighbor
int TotalAliveNeighbor(Image *image,int row,int col,int dig)
{
	int dx[8] = {-1,-1,-1,0,0,1,1,1};
	int dy[8] = {-1,0,1,-1,1,-1,0,1};
	int alive;
	int tot = 0;
	for(int i=0;i<8;i++)
	{
		alive = GetAlive(image,row+dx[i],col+dy[i],dig);
		tot += alive;
	}
	return tot;
}
//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	Color pre = image->image[row][col];
	Color* new_color = (Color*)malloc(sizeof(Color));
	//Remember to initialize the "new_color", because of the management of bits after
	new_color->R = 0;
	new_color->G = 0;
	new_color->B = 0;
	int PreRGB = MergeRGB(pre);
	int new_bit = 0;
	for(int i=0;i<24;i++)
	{
		int bit = GetBit(PreRGB,i);
		//My method is managing the bits
		/*
		if(bit)//Alive
		{
			new_bit = ((1 << TotalAliveNeighbor(image,row,col,i)) & (rule >> 9)) >> TotalAliveNeighbor(image,row,col,i);
		}
		else
		{
			new_bit = ((1 << (TotalAliveNeighbor(image,row,col,i))) & rule) >> TotalAliveNeighbor(image,row,col,i);
		*/
		//Claude gives me a easier way to solve the problem
		int rules_index = 9 * bit + TotalAliveNeighbor(image,row,col,i);
		new_bit = (rule >> rules_index) & 1;
		if(i < 8)
		{
			new_color->B |= (new_bit << i);
		}
		else if(i>= 8 && i< 16)
		{
			new_color->G |= (new_bit << (i-8));
		}
		else
		{
			new_color->R |= (new_bit << (i-16));
		}
	}
	return new_color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	Image *IteImage = (Image *)malloc(sizeof(Image));
	int rows = image->rows;
	int cols = image->cols;
	IteImage->rows =rows;
	IteImage->cols = cols;
	IteImage->image = (Color**)malloc(rows * sizeof(Color*));
	for(int r=0;r<rows;r++)
	{
		IteImage->image[r] = (Color*)malloc(cols * sizeof(Color));
	}
	for(int i=0;i<rows;i++)
	{
		for(int j=0;j<cols;j++)
		{
			
			Color *new_pixel = evaluateOneCell(image,i,j,rule);
			IteImage->image[i][j] = *new_pixel;
			free(new_pixel);
		}
	}
	return IteImage;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if(argc != 3)
	{
		exit(-1);
	}
	char *filename = argv[1];
	char *rule = argv[2];
	char *endptr;
	int NumRule = strtol(rule,&endptr,16);
	if (*endptr != '\0' || NumRule < 0x00000 || NumRule > 0x3FFFF) 
	{
        exit(-1);
    }

	Image *image = readData(filename);
    Image *new_image = life(image, NumRule);

    writeData(new_image);
    freeImage(image);
    freeImage(new_image);

    return 0; 
}
