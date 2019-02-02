//
//  main.cpp
//  PatternMatching
//
//  Created by Andrzej Michnia on 02/02/2019.
//  Copyright © 2019 Andrzej Michnia. All rights reserved.
//

#include <iostream>
#include "pattern_match.hpp"

using namespace std;

int main(int argc, const char * argv[])
{
    string pattern;
    string text;
    cout << "Type text and press enter" << endl;
    cin >> text;
    cout << "Type pattern and press enter" << endl;
    cin >> pattern;

    cout << text << endl;
    cout << pattern << endl;

    if (matches(pattern, text))
        cout << "YES" << endl;
    else
        cout << "NO" << endl;

    return 0;
}
