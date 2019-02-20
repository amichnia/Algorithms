//
//  solution.cpp
//  Rubidium2018
//
//  Created by Andrzej Michnia on 20/02/2019.
//  Copyright © 2019 GirAppe Studio. All rights reserved.
//

#include "solution.hpp"
#include <algorithm>
#include <iostream>

using namespace std;

// Tree methods
bool add_point(Point *p, QuadTreeNode* node);
void split(QuadTreeNode* node);
bool is_within(Point *p, Bounds *bounds);

// Distances
int minimal_distance(Point *point, QuadTreeNode *node, int current_best);
int distance(Point *p1, Point*p2);
int distance(Point *p, Bounds *b);

// Helpers
void print_whitespaces(int count);
void print_bounds(Bounds *bounds);
void print_point(Point *p);

// Main solution
int solution(vector<int> &X, vector<int> &Y) {
    vector<Point> points;

    for(vector<int>::size_type i = 0; i < X.size(); i++) {
        Point p = {
            .x = X[i],
            .y = Y[i],
        };
        points.push_back(p);
    }

    QuadTreeNode *root = build_tree(points);

    int topBottom = abs(root->bounds->top - root->bounds->bottom);
    int leftRight = abs(root->bounds->left - root->bounds->right);
    int current_best = max(topBottom, leftRight);

    for (vector<Point>::iterator it = points.begin(); it != points.end(); ++it) {
        int aspiring = minimal_distance(&(*it), root, current_best);
        current_best = min(current_best, aspiring);
    }

    return current_best;
}

// Tree
QuadTreeNode* build_tree(vector<Point> &points) {
    QuadTreeNode *root = new QuadTreeNode;

    if (!points.size())
        return root;

    // Resolve initial bounds
    Point first = points.at(0);
    int top = first.y;
    int left = first.x;
    int right = first.x;
    int bottom = first.y;

    for(vector<Point>::const_iterator it = points.begin(); it != points.end(); ++it) {
        top = max(top, it->y);
        left = min(left, it->x);
        right = max(right, it->x);
        bottom = min(bottom, it->y);
    }

    root->bounds = new Bounds {
        .top = top,
        .bottom = bottom,
        .left = left,
        .right = right,
    };

    // Add all points
    for(vector<Point>::iterator it = points.begin(); it != points.end(); ++it) {
        add_point(&(*it), root);
    }

    return root;
}

// Node
bool add_point(Point *p, QuadTreeNode* node) {
    if (!is_within(p, node->bounds))
        return false;

    if (!node->isLeaf) {
        return
        add_point(p, node->topLeft) ||
        add_point(p, node->topRight) ||
        add_point(p, node->bottomLeft) ||
        add_point(p, node->bottomRight);
    }

    // It's a leaf:

    if (!node->hasPoint) {
        // Node is empty, we can set point and that's all
        node->point = p;
        node->hasPoint = true;
        return true;
    } else {
        // Node is not empty, we need to split
        split(node);
        return add_point(p, node);
    }
}

void split(QuadTreeNode* node) {
    node->isLeaf = false;
    node->hasPoint = false;

    int splitX = node->bounds->left + ((node->bounds->right - node->bounds->left) / 2);
    int splitY = node->bounds->bottom + ((node->bounds->top - node->bounds->bottom) / 2);

    QuadTreeNode *topLeft = new QuadTreeNode;
    QuadTreeNode *topRight = new QuadTreeNode;
    QuadTreeNode *bottomLeft = new QuadTreeNode;
    QuadTreeNode *bottomRight = new QuadTreeNode;

    topLeft->bounds = new Bounds {
        .top = node->bounds->top,
        .bottom = splitY + 1,
        .left = node->bounds->left,
        .right = splitX,
    };

    topRight->bounds = new Bounds {
        .top = node->bounds->top,
        .bottom = splitY + 1,
        .left = splitX + 1,
        .right = node->bounds->right,
    };

    bottomLeft->bounds = new Bounds {
        .top = splitY,
        .bottom = node->bounds->bottom,
        .left = node->bounds->left,
        .right = splitX,
    };

    bottomRight->bounds = new Bounds {
        .top = splitY,
        .bottom = node->bounds->bottom,
        .left = splitX + 1,
        .right = node->bounds->right,
    };

    node->topLeft = topLeft;
    node->topRight = topRight;
    node->bottomLeft = bottomLeft;
    node->bottomRight = bottomRight;

    add_point(node->point, topLeft) ||
    add_point(node->point, topRight) ||
    add_point(node->point, bottomLeft) ||
    add_point(node->point, bottomRight);
}

// Distances
int minimal_distance(Point *point, QuadTreeNode *node, int current_best) {
    if (distance(point, node->bounds) >= current_best)
        return current_best;

    if (node->isLeaf) {
        if (!node->hasPoint)
            return current_best;

        if (node->point->x == point->x && node->point->y == point->y)
            return current_best;

        return min(current_best, distance(point, node->point));
    }

    // Sort from most to least promising
    vector<pair<int, QuadTreeNode*> > vect;
    vect.push_back(make_pair(distance(point, node->topLeft->bounds), node->topLeft));
    vect.push_back(make_pair(distance(point, node->topRight->bounds), node->topRight));
    vect.push_back(make_pair(distance(point, node->bottomLeft->bounds), node->bottomLeft));
    vect.push_back(make_pair(distance(point, node->bottomRight->bounds), node->bottomRight));
    sort(vect.begin(), vect.end());

    for (int i = 0; i < 4 && vect[i].first < current_best; i++) {
        int aspiring = minimal_distance(point, vect[i].second, current_best);
        current_best = min(current_best, aspiring);
    }

    return current_best;
}

// O(1)
bool is_within(Point *p, Bounds *bounds) {
    return  (p->x >= bounds->left) &&
    (p->x <= bounds->right) &&
    (p->y >= bounds->bottom) &&
    (p->y <= bounds->top);
}

// O(1)
int distance(Point *p1, Point*p2) {
    int distanceX = abs(p1->x - p2->x) / 2;
    int distanceY = abs(p1->y - p2->y) / 2;
    return max(distanceX, distanceY);
}

// O(1)
int distance(Point *p, Bounds *b) {
    if (is_within(p, b))
        return 0;

    int x = p->x;
    int y = p->y;

    if (y >= b->top)
        y = b->top;
    if (y <= b->bottom)
        y = b->bottom;
    if (x >= b->right)
        x = b->right;
    if (x <= b->left)
        x = b->left;

    Point *p2 = new Point {
        .x = x,
        .y = y,
    };

    return distance(p, p2);
}

// Helpers
void print_tree(QuadTreeNode *tree, int level) {
    print_whitespaces(level);
    print_bounds(tree->bounds);

    if (tree->hasPoint)
        print_point(tree->point);

    cout << endl;

    if (tree->isLeaf)
        return;

    print_tree(tree->topLeft, level + 1);
    print_tree(tree->topRight, level + 1);
    print_tree(tree->bottomLeft, level + 1);
    print_tree(tree->bottomRight, level + 1);
}

void print_bounds(Bounds *bounds) {
    cout << "["
    << bounds->top << " "
    << bounds->left << " "
    << bounds->right << " "
    << bounds->bottom << "] "
    << flush;
}

void print_point(Point *p) {
    cout << "(" << p->x << "," << p->y << ")" << flush;
}

void print_whitespaces(int count) {
    while (count--)
        cout << "  " << flush;
}
