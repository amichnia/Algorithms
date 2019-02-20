//
//  solution.hpp
//  Rubidium2018
//
//  Created by Andrzej Michnia on 20/02/2019.
//  Copyright © 2019 GirAppe Studio. All rights reserved.
//

#ifndef solution_hpp
#define solution_hpp

#include <stdio.h>
#include <vector>

// Point
struct Point {
    const int x;
    const int y;
};

// Cartesian plane bounds
struct Bounds {
    const int top;    // top >= bottom
    const int bottom; // bottom <= top
    const int left;   // left <= right
    const int right;  // right >= left
};

// Quad tree
struct QuadTreeNode {
    // Helpers
    bool isLeaf = true;
    bool hasPoint = false;

    // Data
    Point *point;
    Bounds *bounds;

    // Children
    QuadTreeNode *topLeft;
    QuadTreeNode *topRight;
    QuadTreeNode *bottomLeft;
    QuadTreeNode *bottomRight;
};

int solution(std::vector<int> &X, std::vector<int> &Y);

QuadTreeNode* build_tree(std::vector<Point> &points);
void print_tree(QuadTreeNode *tree, int level = 0);

#endif /* solution_hpp */
