#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <ctype.h>

// printout all string values from array of strings
void displayUserMessages(char *userMessages[])
{
    for (int i = 0; i < 10; i++)
    {
        printf("%s\n", userMessages[i]);
    }
}

// get user input and store it in one of the arrays of strings
void readUserMessage(char *userMessages[], int insertionLocation)
{
    char Ending_Symbols[3] = {'.', '!', '?'};
    char *userString[10000];
    printf("Enter a new message: ");
    scanf("%s", *userString);

    // get the length of the string
    int userMessageLength = strlen(*userString);

    // check if the messages first letter is uppercase
    if (!isupper(*userString[0]))
    {
        printf("First letter is not uppercase, Try again.\n");
        return;
    }
    // check if the ending character is valid
    else if (!strchr(Ending_Symbols, *userString[userMessageLength - 1]))
    {
        printf("Invalid ending character, Try again.\n");
        return;
    }
    // the message is valid, place it in the given index
    // free the previously stored message
    free(userMessages[insertionLocation]);
    // allocate memory for the new message in the sizeof chars
    userMessages[insertionLocation] = malloc(sizeof(char) * (userMessageLength + 1));
    userMessages[insertionLocation] = *userString;
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