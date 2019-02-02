//
//  pattern_match.hpp
//  PatternMatching
//
//  Created by Andrzej Michnia on 02/02/2019.
//  Copyright © 2019 Andrzej Michnia. All rights reserved.
//

#ifndef pattern_match_hpp
#define pattern_match_hpp

#include <stdio.h>
#include <iostream>
#include <string>
#include <vector>

/**
 Returns true, if text matches pattern, where pattern is string containing elements {A,B}.
 A and B represents a word.

 @param pattern Patternt to match, e.x. "AABBA"
 @param text Text to match pattern against
 @return true if there is match, false otherwise
 */
bool matches(std::string pattern, std::string text);

#endif /* pattern_match_hpp */
