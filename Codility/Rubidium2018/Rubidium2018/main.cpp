//
//  main.cpp
//  Rubidium2018
//
//  Created by Andrzej Michnia on 20/02/2019.
//  Copyright © 2019 GirAppe Studio. All rights reserved.
//

#include <iostream>
#include <cstdio>
#include <vector>
#include "solution.hpp"

using namespace std;

int main(int argc, const char * argv[]) {
    cout << "Number of points: " << endl;
    int P;
    scanf("%d", &P);
    vector<int> X;
    vector<int> Y;

    cout << "Points (as x y): " << endl;
    while (P--) {
        int x, y;
        scanf("%d %d", &x, &y);

        X.push_back(x);
        Y.push_back(y);
    }

    cout << "== ANSWER: =========" << endl;
    cout << solution(X, Y) << endl;
//    cout << "== TREE: ===========" << endl;
//    print_tree(root);
//    cout << "====================" << endl;

    return 0;
}
