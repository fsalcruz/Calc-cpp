%{
#include "y.tab.h"
#include <cstdlib>
#include <cwchar>
#include <map>
#include <iostream>
using namespace std;

int kanjiToArabic(const string kanji) {
    int result = 0, cur_dig = 0, cur_val = 0, negative = 1;

    if (kanji == "零") return 0;
    
     // Iterate over each character in the UTF-8 string
    for (size_t i = 0; i < kanji.length(); ) {


        // Extract the current character
        char currentChar = kanji[i];

        // Determine the number of bytes in the current UTF-8 character
        size_t charSize = 0;
        if ((currentChar & 0b10000000) == 0b00000000) {
            charSize = 1;
        } else if ((currentChar & 0b11100000) == 0b11000000) {
            charSize = 2;
        } else if ((currentChar & 0b11110000) == 0b11100000) {
            charSize = 3;
        } else if ((currentChar & 0b11111000) == 0b11110000) {
            charSize = 4;
        } else {
            // Handle invalid UTF-8 character
            std::cerr << "Invalid UTF-8 character at position " << i << std::endl;
            break;
        }

        // Extract the UTF-8 character
        std::string utf8char = kanji.substr(i, charSize);

        // Do something with the character (e.g., print it)
        if (utf8char == "ー") negative *= -1;
        if (utf8char == "一") cur_dig = 1;
        if (utf8char == "ニ") cur_dig = 2;
        if (utf8char == "三") cur_dig = 3;
        if (utf8char == "四") cur_dig = 4;
        if (utf8char == "五") cur_dig = 5;
        if (utf8char == "六") cur_dig = 6;
        if (utf8char == "七") cur_dig = 7;
        if (utf8char == "八") cur_dig = 8;
        if (utf8char == "九") cur_dig = 9;
        if (utf8char == "十") {
            if (cur_dig == 0) cur_dig = 1;
            cur_val += (10 * cur_dig);
            cur_dig = 0;
        }
        if (utf8char == "百") {
            if (cur_dig == 0) cur_dig = 1;
            cur_val += (100 * cur_dig);
            cur_dig = 0;
        }
        if (utf8char == "千") {
            if (cur_dig == 0) cur_dig = 1;
            cur_val += (1000 * cur_dig);
            cur_dig = 0;
        }
        if (utf8char == "億") {
            if (cur_dig == 0) cur_dig = 1;
            result = cur_dig * 100000000;
            cur_dig = 0;
            cur_val = 0;
        }
        if (utf8char == "万") {
            cur_val += cur_dig;
            if (cur_val == 0) cur_val = 1;
            result += (10000 * cur_val);
            cur_dig = 0;
            cur_val = 0;
        }

        // Move to the next character
        i += charSize;
    }

    result += cur_val + cur_dig;
    
    return (result*negative);
}
%}

%%

[ \t]           /* ignore whitespace */
(-)?[0-9]+          {
    string str = yytext;
    if (str[0] != '-') {
        yylval = stoi(str);
    } else {
        yylval = (-1) * stoi(str.substr(1, str.length() - 1));
    }
        return NUM; 
    }
(ー)?(((一|ニ|三|四|五|六|七|八|九)億)?(((ニ|三|四|五|六|七|八|九)?千)?((ニ|三|四|五|六|七|八|九)?百)?((ニ|三|四|五|六|七|八|九)?十)?(一|ニ|三|四|五|六|七|八|九)万)?((ニ|三|四|五|六|七|八|九)?千)?((ニ|三|四|五|六|七|八|九)?百)?((ニ|三|四|五|六|七|八|九)?百)?((ニ|三|四|五|六|七|八|九)?十)?(一|ニ|三|四|五|六|七|八|九)?) {
    yylval = kanjiToArabic(yytext);
    return NUM;
}
(<->)           { return NUMSYS; }
("end"|"END")   { return END; }
\n              { return EOL; }
.               { return yytext[0]; }

%%

int yywrap() {
    return 1;
}