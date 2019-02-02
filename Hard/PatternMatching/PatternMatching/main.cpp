//
//  main.cpp
//  PatternMatching
//
//  Created by Andrzej Michnia on 02/02/2019.
//  Copyright © 2019 Andrzej Michnia. All rights reserved.
//

#include <iostream>
#include <cstdio>
#include <string>
#include <vector>

using namespace std;

/**
 Returns true, if text matches pattern, where pattern is string containing elements {A,B}.
 A and B represents a word.

 @param pattern Patternt to match, e.x. "AABBA"
 @param text Text to match pattern against
 @return true if there is match, false otherwise
 */
bool matches(string pattern, string text);

int main(int argc, const char * argv[]) {
    // insert code here...
    string pattern = "bbaba";
    string text = "catcatgocatgo";

    bool result = matches(pattern, text);

    if (result)
        cout << "YES" << endl;
    else
        cout << "NO" << endl;

    return 0;
}

/**
 Computes length of word B, based on parameters:

 @param alen Estimated A length
 @param acnt Number of occurences of A in pattern
 @param bcnt Number of occurences of B in pattern
 @param length Total length of text
 @return Length of B, or -1 if there is no solution
 */
int blen(int alen, int acnt, int bcnt, int length)
{
    if (bcnt == 0)
        return (alen * acnt == length) ? 0 : -1;

    int totalA = acnt * alen;
    int totalB = length - totalA;

    return (totalB % bcnt == 0) ? totalB / bcnt : -1;
}

bool verify(int alen, int blen, string &pattern, string &text) {
    vector<int> apositions;
    vector<int> bpositions;

    int offset = 0;

    for (string::iterator it = pattern.begin(); it != pattern.end(); ++it)
    {
        if (*it == 'a')
        {
            apositions.push_back(offset);
            offset += alen;
        }
        else
        {
            bpositions.push_back(offset);
            offset += blen;
        }
    }

    // Verify A's
    offset = 0;

    while (!apositions.empty() && offset < alen)
    {
        // Verify all charactersx at offset
        for(vector<int>::const_iterator it = apositions.begin(); it != apositions.end(); ++it)

        offset++;
    }


    // Verify B's
    offset = 0;

    return false;
}

bool matches(string pattern, string text)
{
    // Assure start with a, as "abbab" <=> "baaba"
    if (pattern.front() == 'b')
        for (string::iterator it = pattern.begin(); it != pattern.end(); ++it)
            *it = (*it == 'b') ? 'a' : 'b';

    if (text.length() < pattern.length())
        return false;

    if (pattern == "a" || pattern == "ab")
        return true;

    cout << pattern << endl;

    const int acnt = int(count(pattern.begin(), pattern.end(), 'a'));
    const int bcnt = int(count(pattern.begin(), pattern.end(), 'b'));

    cout << "A: " << acnt << endl;
    cout << "B: " << bcnt << endl;

    bool canContinue = true;
    int a = 1;

    while (canContinue)
    {
        int b = blen(a, acnt, bcnt, int(text.length()));

        if (b >= 0 && false)
            return true;

        a++;
        canContinue = (acnt * a) + (bcnt * 1) <= text.length();
    }

    return false;
}
