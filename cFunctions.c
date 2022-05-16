#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>

typedef unsigned char uint8_t;

#define STDIN 0
#define MAX_STRING_SIZE 1000

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
    for (int i = 0; i < strlen(string); i++)
    {
        if (isalpha(string[i]))
        {
            string[i] = (string[i] + distance - 'a') % 26 + 'a';
        }
    }
    printf("%s\n", string);
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
void readUserMessage(char **userMessages, uint8_t insertionLocation)
{
    unsigned char readSuccess = 0;
    char userString[MAX_STRING_SIZE];
    int stringSize;
    while (!readSuccess)
    {
        printf("Enter a new message:\n");
        // scanf("%s", userString); // <- Awful function, the worst
        stringSize = read(STDIN, userString, MAX_STRING_SIZE);
        // check that read ran properly
        // read must not take up the entire buffer, needs room for null-terminator
        if (stringSize < 2 || stringSize == MAX_STRING_SIZE)
        {
            printf("Read failed. String is either too small or too large\n");
            continue;
        }
        // add null-terminator
        userString[stringSize] = 0;
        // check if the ending character (before the newline) is valid
        char lastChar = userString[stringSize - 2];
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
            if (!userString[i])
                return;
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
    int letterFrequency[26] = {0};
    char frequencyValues[5] = {'e', 't', 'a', 'o', 'i'};
    char BANNED[5] = {0};

    // print messages
    displayUserMessages(userMessages);
    // ask user what string they want to decrpyt
    printf("Enter the index of the string you want to decrypt: ");
    int index = 1;
    // scanf("%d", &index);
    //  check if the index is valid
    if (index < 0 || index > 9)
    {
        printf("Invalid index, Try again.\n");
        return;
    }

    // store the string
    char *userString = userMessages[index];
    // get the length of the string
    int userMessageLength = strlen(userString);

    // get the frequency of each letter in the message
    for (int i = 0; i < userMessageLength; i++)
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
    printf("Decrypted Messages\n");
    stringShifter(userString, distance);
    stringShifter(userString, distance2);
    stringShifter(userString, distance3);
    stringShifter(userString, distance4);
    stringShifter(userString, distance5);
}
