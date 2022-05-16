#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>

typedef unsigned char uint8_t;

#define STDIN 0
#define MAX_STRING_SIZE 1000

// printout all string values from array of strings
void displayUserMessages(char *userMessages[])
{
    for (int i = 0; i < 10; i++)
    {
        printf("%s\n", userMessages[i]);
    }
}

// get user input and store it in one of the arrays of strings
void readUserMessage(char **userMessages, uint8_t insertionLocation)
{
    unsigned char readSuccess = 0;
    char userString[MAX_STRING_SIZE];
    int stringSize;
    while (!readSuccess)
    {
        printf("Enter a new message:\n");
        //scanf("%s", userString); // <- Awful function, the worst
        stringSize = read(STDIN, userString, MAX_STRING_SIZE);
        // check that read ran properly
        // read must not take up the entire buffer, needs room for null-terminator
        if (stringSize < 2  || stringSize == MAX_STRING_SIZE)
        {
            printf("Read failed. String is either too small or too large\n");
            continue;
        }
        // add null-terminator
        userString[stringSize] = 0;
        // check if the ending character (before the newline) is valid
        char lastChar = userString[stringSize-2];
        if (lastChar != '!' && lastChar != '?' && lastChar != '.')
        {
            printf("Invalid ending character, Try again.\n");
            continue;
        }
        // check if the messages first letter is uppercase
        if (!isupper(userString[0]))
        {
            printf("First letter is not uppercase, Try again.\n");
            continue;
        }

        // the message is valid!
        readSuccess = 1;
        // kindof like a deep copy, move each char from buffer into 2D array
        int i = 0;
        while (1)
        {
            userMessages[insertionLocation][i] = userString[i];
            // stop after the null terminator
            if (!userString[i]) return;
            i = i + 1;
        }
    }
}

// use malloc to resize given char* array
char *resizeArray(char *array[], int newSize)
{
    char *newArray = (char *)malloc(sizeof(char) * newSize);
    for (int i = 0; i < newSize; i++)
    {
        newArray[i] = *array[i];
    }
    free(array);
    return newArray;
}

// does not store changes, just prints out the changes
void decryptString(char *userMessages[])
{
}