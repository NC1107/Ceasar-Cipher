#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <ctype.h>

// get distances between two letters
int getDistance(char letter1, char letter2)
{
    int distance = letter2 - letter1;
    if (distance < 0)
    {
        distance += 26;
    }
    return distance;
}
// shift the letters in the string by the given distance
void stringShifter(char *string, int distance)
{
    printf("stringShifter");
    for (int i = 0; i < strlen(string); i++)
    {
        string[i] = tolower(string[i]);
        if (isalpha(string[i]))
        {
            string[i] = string[i] + distance;
            // check if the letter is out of bounds
            if (string[i] > 'z')
            {
                string[i] = string[i] - 26;
            }
            if (string[i] < 'a')
            {
                string[i] = string[i] + 26;
            }
        }
    }
}

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
    int letterFrequency[26] = {0};
    char frequencyValues[5] = {'e', 't', 'a', 'o', 'i'};
    char BANNED[5];

    // print messages
    displayUserMessages(userMessages);
    // ask user what string they want to decrpyt
    printf("Enter the index of the string you want to decrypt: ");
    int index;
    scanf("%d", &index);
    // store the string
    char *userString = userMessages[index];
    // get the length of the string
    unsigned long userMessageLength = strlen(userString);

    // get the frequency of each letter in the message
    for (unsigned long i = 0; i < userMessageLength; i++)
    {
        if (isalpha(userString[i]))
        {
            letterFrequency[tolower(userString[i]) - 'a']++;
        }
    }

    // iterate until we have the 5 most frequent letters
    for (int i = 0; i < 5; i++)
    {
        int max = 0;
        int maxIndex = 0;
        for (int j = 0; j < 26; j++)
        {
            if (letterFrequency[j] > max)
            {
                max = letterFrequency[j];
                maxIndex = j;
            }
        }
        BANNED[i] = maxIndex + 'a';
        letterFrequency[maxIndex] = 0;
    }
    // get the distance between the most frequent letters
    int distance = getDistance(BANNED[0], frequencyValues[0]);
    int distance2 = getDistance(BANNED[1], frequencyValues[1]);
    int distance3 = getDistance(BANNED[2], frequencyValues[2]);
    int distance4 = getDistance(BANNED[3], frequencyValues[3]);
    int distance5 = getDistance(BANNED[4], frequencyValues[4]);

    // shift the letters in the string by the distance
    stringShifter(userString, distance);
    stringShifter(userString, distance2);
    stringShifter(userString, distance3);
    stringShifter(userString, distance4);
    stringShifter(userString, distance5);
}