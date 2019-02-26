//
//  main.cpp
//  ShuffleDeck
//
//  Created by Andrzej Michnia on 26/02/2019.
//  Copyright © 2019 GirAppe Studio. All rights reserved.
//

#include <iostream>
#include <set>

struct Card {
    int value;
};

using namespace std;

void shuffle(Card deck[], int size);
set<Card*> draw(Card deck[], int size, int hand);

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

    int handSize;
    while (scanf("%d", &handSize)) {
        set<Card*> hand = draw(deck, size, handSize);
        for (set<Card*>::iterator it = hand.begin(); it != hand.end(); ++it) {
            cout << (*it)->value << " ";
        }
        cout << endl;
    }

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

Card* draw(Card deck[], int size) {
    int index = random(0, size);
    Card pulled = deck[index];
    deck[index] = deck[size - 1];
    deck[size - 1] = pulled;
    return new Card { .value = pulled.value };
}

set<Card*> draw(Card deck[], int size, int hand) {
    set<Card*> set;

    while (hand--) {
        Card* card = draw(deck, size);
        set.insert(card);
        size--;
    }

    return set;
}
