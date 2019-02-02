//
//  pattern_match.cpp
//  PatternMatching
//
//  Created by Andrzej Michnia on 02/02/2019.
//  Copyright © 2019 Andrzej Michnia. All rights reserved.
//

#include "pattern_match.hpp"

using namespace std;

/**
 Returns length of word B for given A length, text length, and A and B counts in pattern

 @param alen A lenth
 @param acnt A count in pattern
 @param bcnt B count in pattern
 @param length Text length
 @return B length or -1 if not possible
 */
int blen(int alen, int acnt, int bcnt, int length)
{
    if (bcnt == 0)
        return (alen * acnt == length) ? 0 : -1;

    int totalA = acnt * alen;
    int totalB = length - totalA;

    return (totalB % bcnt == 0) ? totalB / bcnt : -1;
}

bool verify(int alen, int blen, string &pattern, string &text)
{
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
        char matchAgainst = text[apositions.front() + offset];
        cout << "Matching against " << matchAgainst << endl;

        // Verify all charactersx at offset
        for(vector<int>::const_iterator it = apositions.begin(); it != apositions.end(); ++it)
            if (text[*it + offset] != matchAgainst)
                return false;

        offset++;
    }

    // Verify B's
    offset = 0;

    while (!bpositions.empty() && offset < blen)
    {
        char matchAgainst = text[bpositions.front() + offset];
        cout << "Matching against " << matchAgainst << endl;

        // Verify all charactersx at offset
        for(vector<int>::const_iterator it = bpositions.begin(); it != bpositions.end(); ++it)
            if (text[*it + offset] != matchAgainst)
                return false;

        offset++;
    }

    return true;
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

    const int acnt = int(count(pattern.begin(), pattern.end(), 'a'));
    const int bcnt = int(count(pattern.begin(), pattern.end(), 'b'));

    bool canContinue = true;
    int a = 1;

    while (canContinue)
    {
        int b = blen(a, acnt, bcnt, int(text.length()));
        cout << "Trying: A=" << a << " B=" << b << endl;

        if (b >= 0 && verify(a, b, pattern, text))
            return true;

        a++;
        canContinue = (acnt * a) + (bcnt * 1) <= text.length();
    }

    return false;
}
