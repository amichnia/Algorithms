    //
    //  main.cpp
    //  ShortestSupersequence
    //
    //  Created by Andrzej Michnia on 27/01/2019.
    //  Copyright © 2019 Andrzej Michnia. All rights reserved.
    //

#include <iostream>
#include <cstdio>
#include <queue>
#include <algorithm>
#include <vector>
#include <map>

using namespace std;

    // Define
typedef map<int, queue<int>> MapOfLists;
typedef pair<int, int> Range;

typedef pair<int, queue<int>> HeapNode;

    // API
MapOfLists getSequences(vector<int> small, vector<int> big);
Range findShortestSupersequence(MapOfLists sequences);
Range findShortestSupersequenceUsingHeap(MapOfLists sequences);
void printSequences(MapOfLists sequences);

bool compare(HeapNode, HeapNode);

    // Main
int main() {
    printf("Input: k n, then k different integers, and n integers afterwards\n");
    int k, n;
    scanf("%d %d",&k,&n);

    vector<int> small(k);
    vector<int> big(n);

    for(int i = 0; i < k; i++) {
        scanf("%d", &small[i]);
    }

    for(int i = 0; i < n; i++) {
        scanf("%d", &big[i]);
    }

    MapOfLists sequences = getSequences(small, big);
        //    printSequences(sequences);
    Range result = findShortestSupersequence(sequences);

    if (result.first < 0) {
        printf("There is no subarray satisfying the requirements!\n");
    } else {
        printf("Shortest supersequence: <%d , %d> !\n", result.first, result.second);
    }

    printf("================================== \n");
    result = findShortestSupersequenceUsingHeap(sequences);

    if (result.first < 0) {
        printf("There is no subarray satisfying the requirements!\n");
    } else {
        printf("Shortest supersequence: <%d , %d> !\n", result.first, result.second);
    }


    return 0;
}

    // Impl
MapOfLists getSequences(vector<int> small, vector<int> big) {
    map<int, queue<int> > sequences;

        // Prepare sequences
    for (vector<int>::iterator it = small.begin(); it != small.end(); ++it) {
        pair<int, queue<int> > newPair(*it, queue<int>());
        sequences.insert(newPair);
    }

        // Build representation
    for (int i = 0; i < big.size(); i++) {
        int it = big[i];
        try {
            sequences.at(it).push(i);
        }
        catch(const out_of_range& oor) {
            continue;
        }
    }

    return sequences;
}

void printSequences(MapOfLists sequences) {
    for (MapOfLists::iterator it = sequences.begin(); it != sequences.end(); ++it) {
        printf("%d = { ", (*it).first);
        queue<int> queue = (*it).second;
        while (!queue.empty()) {
            printf("%d, ",queue.front());
            queue.pop();
        }
        printf("}\n");
    }
}

Range findShortestSupersequence(MapOfLists sequences) {
    Range result(-1,-1);

        // Check if empty
    if(sequences.empty()) {
        return result;
    }

    bool canContinue = true;
    int overallBest = -1;

        // Verify there is an answer
    for (MapOfLists::const_iterator it = sequences.begin(); it != sequences.end(); ++it) {
        if ((*it).second.empty()) {
            return result;
        }
    }

        // Main loop
    while (canContinue) {
            // 1. Compute
        int currentMin = -1;
        int currentMax = -1;
        int currentBest = -1;

        for (MapOfLists::const_iterator it = sequences.begin(); it != sequences.end(); ++it) {
            if ((*it).second.front() < currentMin || currentMin == -1) {
                currentMin = (*it).second.front();
            }

            if ((*it).second.front() > currentMax) {
                currentMax = (*it).second.front();
            }
        }

        currentBest = currentMax - currentMin;
        if (currentBest < overallBest || overallBest == -1) {
            result = Range(currentMin, currentMax);
            overallBest = currentBest;
        }

            // 2. Drop minimal
        int minimalIndex = (*(sequences.begin())).first;
        int minimalValue = (*(sequences.begin())).second.front();

        for (MapOfLists::iterator it = sequences.begin(); it != sequences.end(); ++it) {
            if ((*it).second.front() < minimalValue) {
                minimalValue = (*it).second.front();
                minimalIndex = (*it).first;
            }
        }

        printf("Pop: %d from index %d\n", minimalIndex, minimalValue);
        sequences.at(minimalIndex).pop();

            //        printf("=========\n")
            //        printSequences(sequences);

        canContinue = !sequences.at(minimalIndex).empty();
    }

    return result;
}

Range findShortestSupersequenceUsingHeap(MapOfLists sequences) {
    Range result(-1,-1);

        // Check if empty
    if(sequences.empty()) {
        return result;
    }

    int currentMax = -1;
    int overallBest = -1;

    priority_queue<HeapNode, vector<HeapNode>, function<bool(HeapNode,HeapNode)>> heap(compare);

        // Verify there is an answer
    for (MapOfLists::const_iterator it = sequences.begin(); it != sequences.end(); ++it) {
        if ((*it).second.empty()) {
            return result;
        }

        heap.push(*it);
        currentMax = max(currentMax, (*it).second.front());
    }

    HeapNode current = heap.top();
    heap.pop();

    do {
        heap.push(current);
        currentMax = max(currentMax, current.second.front());
        current = heap.top();
        heap.pop();

        int currentMin = current.second.front();
        int currentBest = currentMax - currentMin;

        if (currentBest < overallBest || overallBest == -1) {
            result = Range(currentMin, currentMax);
            overallBest = currentBest;
        }

        printf("Pop: %d from index %d\n", current.first, currentMin);

        current.second.pop();
    } while(!current.second.empty());

    return result;
}

bool compare(HeapNode a, HeapNode b) {
    return a.second.front() > b.second.front();
}
