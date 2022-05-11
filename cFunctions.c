#include <stdio.h>
#include <stdlib.h>

// printout all string values from array of strings
void displayUserMessages(char userMessages[], int size)
{
    // fuck you
}

// use malloc to resize given char* array
char *resizeArray(char *array, int newSize)
{
    char *newArray = (char *)malloc(sizeof(char) * newSize);
    for (int i = 0; i < newSize; i++)
    {
        newArray[i] = array[i];
    }
    free(array);
    return newArray;
}