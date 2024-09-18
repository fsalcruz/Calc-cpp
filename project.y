%{
#include <iostream>
#include <map>

using namespace std;

extern int yylex();
extern int yyparse();
extern int yylval;

int numsys = 0;

void yyerror(const char *s) {
    cerr << "Error: " << s << endl;
}

string ArabicToKanji(const int n) {
    map<int, string> kanjiMap = {
    {1, "一"}, {2, "二"}, {3, "三"}, {4, "四"}, {5, "五"},
    {6, "六"}, {7, "七"}, {8, "八"}, {9, "九"}, {10, "十"}
};

    int number = n;

    if (number == 0) {
        return "零";
    }

    if (number > 999999999) {
        return (to_string(number) + " is too large to write in kanji.");
    }

    string kanji;

    // Handle billions
    int billions = number / 1000000000;
    if (billions > 0) {
        kanji += kanjiMap[billions] + "億";
        number %= 1000000000;
    }

    // Handle millions
    int millions = number / 1000000;
    if (millions > 0) {
        kanji += ArabicToKanji(millions) + "百";
        number %= 1000000;
    }

    // Handle thousands
    int thousands = number / 1000;
    if (thousands > 0) {
        kanji += ArabicToKanji(thousands) + "千";
        number %= 1000;
    }

    // Handle hundreds
    int hundreds = number / 100;
    if (hundreds > 0) {
        kanji += ArabicToKanji(hundreds) + "百";
        number %= 100;
    }

    // Handle tens and ones
    if (number > 0) {
        if (!kanji.empty()) {
            kanji += "and";
        }

        if (number <= 10) {
            kanji += kanjiMap[number];
        } else if (number < 20) {
            kanji += "十" + kanjiMap[number % 10];
        } else {
            kanji += kanjiMap[number / 10] + "十" + kanjiMap[number % 10];
        }
    }

    return kanji;
}

%}

%token NUM
%token EOL
%token NUMSYS
%token END

%left '+' '-'
%left '*' '/'

%%

calclist: /* empty */
    | calclist END EOL { return 0; }
    | calclist NUMSYS EOL {numsys = !numsys;}
    | calclist exp EOL { if (numsys) {cout << $2 << endl;} else {cout << ArabicToKanji($2) << endl;} }
    ;

exp: factor
    | exp '+' factor { $$ = $1 + $3; }
    | exp '-' factor { $$ = $1 - $3; }
    ;

factor: term
    | factor '*' term { $$ = $1 * $3; }
    | factor '/' term { if ($3 != 0) $$ = $1 / $3; else yyerror("division by zero"); }
    ;

term: NUM
    | '(' exp ')' { $$ = $2; }
    ;

%%

int main() {
    yyparse();
    return 0;
}