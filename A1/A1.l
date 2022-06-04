%{
//
//   GOAL :-  Program to convert Macrojava to minijava translator using Flex and Bison
//   This file is written by T.Bhanu Shashank(CS19B043)
//
#include<stdio.h>
#include <string.h>
#include<stdlib.h>
#include "A1.tab.h"

	void COPYTEXT()
	{
		int len = strlen(yytext);
		yylval.text = (char*)malloc(len+1);
		strcpy(yylval.text,yytext);
	}

%}

%%

[ \t\r\f]+	; // ignore space
[\n] {yylineno++;}
\/\/.*\n ; { yylineno++;}
\/\*.*\*\/ ; //ignore comments

";" {
			COPYTEXT();
			return SEMICOL;
}

"public" {
			COPYTEXT();
			return PUBLIC;
}

"static" {
			COPYTEXT();
			return STATIC;
}

"void" {
			COPYTEXT();
			return VOID;
}

"main" {
			COPYTEXT();
			return MAIN;
}

"new" {
			COPYTEXT();
			return NEW;
}

"class" {
			COPYTEXT();
			return CLASS;
}

"String" {
			COPYTEXT();
			return STRING;
}

"if" {
			COPYTEXT();
			return IFCONDITION;
}

"else" {
			COPYTEXT();
		        return ELSECONDITION;
}

"while" {
			COPYTEXT();
			return WHILE;
}

"(" {
			COPYTEXT();
			return LEFTB;
}

")" {
			COPYTEXT();
			return RIGHTB;
}

"[" {
			COPYTEXT();
			return LEFTSB;
}

"]" {
			COPYTEXT();
			return RIGHTSB;
}

"{" {
			COPYTEXT();
			return LEFTCB;
}

"}" {
			COPYTEXT();
			return RIGHTCB;
}

"&&" {
			COPYTEXT();
			return TAND;
}

"||" {
			COPYTEXT();
			return TOR;
}

"!=" {
			COPYTEXT();
			return NTEQUAL;
}

"<=" {
			COPYTEXT();
			return LESSTHANEQUAL;
}

"=" {
			COPYTEXT();
			return EQUAL;
}

"+" {
			COPYTEXT();
			return ADD;
}

"-" {
			COPYTEXT();
			return SUB;
}

"*" {
			COPYTEXT();
			return MULTI;
}

"/" {
			COPYTEXT();
			return DIV;
}

"&" {
			COPYTEXT();
			return AND;
}

"!" {
			COPYTEXT();
			return NOT;
}

"|" {
			COPYTEXT();
			return OR;
}

".length" {
			COPYTEXT();
			return DLENGTH;
}

"false" {
			COPYTEXT();
			return FALSE;
}

"true" {
			COPYTEXT();
			return TRUE;
}

"this" {
			COPYTEXT();
			return THIS;
}

"int" {
			COPYTEXT();
			return INT;
}

"System.out.println" {
			COPYTEXT();
			return PRINTSTATEMENT;
}

"." {
			COPYTEXT();
			return DOT;
}

"," {
			COPYTEXT();
			return COMMA;
}

"extends" {
			COPYTEXT();
			return EXTENDS;
}

"return" {
			COPYTEXT();
			return RETURN;
}

"boolean" {
			COPYTEXT();
			return BOOL;
}

"#defineStmt0" {
			COPYTEXT();
			return DEFSTMTZERO;
}

"#defineStmt1" {
			COPYTEXT();
			return DEFSTMTONE;
}

"#defineStmt2" {
			COPYTEXT();
			return DEFSTMTTWO;
}

"#defineStmt" {
			COPYTEXT();
			return DEFINESTMT;
}

"#defineExpr0" {
			COPYTEXT();
			return DEFEXPRZERO;
}

"#defineExpr1" {
			COPYTEXT();
			return DEFEXPRONE;
}

"#defineExpr2" {
			COPYTEXT();
			return DEFEXPRTWO;
}

"#defineExpr" {
			COPYTEXT();
			return DEFINEEXPR;
}


[a-zA-Z][a-zA-Z0-9_]* {
			COPYTEXT();
			return IDENTIFIER;
}

[1-9][0-9]*|0 {
			COPYTEXT();
			return NUMBER;
}

. {
			COPYTEXT();
			return OTHER;
}

%%




