//
//  main.cpp
//  MissingTwo
//
//  Created by Andrzej Michnia on 26/01/2019.
//  Copyright © 2019 Andrzej Michnia. All rights reserved.
//

#include <iostream>
#include <cstdio>
#include <vector>

using namespace std;

int missing(vector<int> &table);
void jump(int start, vector<int> &table);

int main() {
    printf("Hello world. Give N: ");

    // Input
    size_t n;
    scanf("%zd", &n);
    vector<int> table(n);

    for (int i = 0; i < (n - 1); i++) {
        scanf("%d", &table[i]);
    }

    int solution = missing(table);
    printf("Missing integer is: %d\n", solution);

    return 0;
}

int missing(vector<int> &table) {
    for (int i = 0; i < table.size(); i++) {
        jump(table[i], table);
    }

    for (int i = 0; i < table.size(); i++) {
        if (table[i] > 0) return i;
    }

    return int(table.size());
}

void jump(int start, vector<int> &table) {
    // Already visited or out of bounds
    if (start >= table.size() || table[start] <= 0) return;

    int next = table[start];
    table[start] = 0;

    jump(next, table);
}
