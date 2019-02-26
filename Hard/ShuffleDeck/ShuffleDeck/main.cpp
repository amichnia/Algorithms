//
//  main.cpp
//  ShuffleDeck
//
//  Created by Andrzej Michnia on 26/02/2019.
//  Copyright © 2019 GirAppe Studio. All rights reserved.
//

#include <iostream>

struct Card {
    int value;
};

void shuffle(Card deck[], int size);

using namespace std;

int main(int argc, const char * argv[]) {
    // insert code here...
    cout << "Type deck size!\n";
    int size;
    cin >> size;
    Card deck[size];

    for (int i = 0; i < size; i++)
        deck[i] = Card { .value = i };

    for (int i = 0; i < size; i++)
        cout << deck[i].value << " ";
    cout << endl;

    shuffle(deck, size);

    for (int i = 0; i < size; i++)
        cout << deck[i].value << " ";
    cout << endl;

    return 0;
}

int random(int min, int max) {
    if (max <= min)
        return min;
    srand ((unsigned)time(NULL));
    return min + rand() % (max - min + 1);
}

void shuffle(Card deck[], int size) {
    for (int i = size; i > 0; --i) {
        // we start with size - 1
        swap(deck[i], deck[random(0,i)]);
    }
}
