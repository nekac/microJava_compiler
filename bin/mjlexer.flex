package rs.ac.bg.etf.pp1;

import java_cup.runtime.Symbol;

%%

%{
	StringBuffer string = new StringBuffer();

	// ukljucivanje informacije o poziciji tokena
	private Symbol new_symbol(int type) {
		return new Symbol(type, yyline+1, yycolumn);
	}
	
	// ukljucivanje informacije o poziciji tokena
	private Symbol new_symbol(int type, Object value) {
		return new Symbol(type, yyline+1, yycolumn, value);
	}

%}

// *** DIREKTVE

%cup
%line
%column

%xstate COMMENT
%state STRING

%eofval{
	return new_symbol(sym.EOF); // kada se zavrsi stanje vrati se EOF vrednost
%eofval}

// *** LEKSIKA
// Regularni izrazi

%%

// beli, blanko znakovi
" " 	{ }
"\b" 	{ }
"\t" 	{ }
"\r\n" 	{ }
"\f" 	{ }

// lekseme, tokeni
"program"   { return new_symbol(sym.PROG, yytext()); } // kada se prepozna odradi se kreiranje tokena (sam regularni izraz + akcija)
"break"	    { return new_symbol(sym.BREAK, yytext()); }
"class"     { return new_symbol(sym.CLASS, yytext()); }
"else"      { return new_symbol(sym.ELSE, yytext()); }
"const"     { return new_symbol(sym.CONST, yytext()); }
"if"        { return new_symbol(sym.IF, yytext()); }
"new"       { return new_symbol(sym.NEW, yytext()); }
"print" 	{ return new_symbol(sym.PRINT, yytext()); }
"read"      { return new_symbol(sym.READ, yytext());  }
"return" 	{ return new_symbol(sym.RETURN, yytext()); }
"void" 		{ return new_symbol(sym.VOID, yytext()); }
"for"    	{ return new_symbol(sym.FOR, yytext()); }
"extends"   { return new_symbol(sym.EXTENDS, yytext()); }
"continue"  { return new_symbol(sym.CONTINUE, yytext()); }
"static"   	{ return new_symbol(sym.STATIC, yytext()); }
"+" 		{ return new_symbol(sym.PLUS, yytext()); }
"-"         { return new_symbol(sym.MINUS, yytext()); }
"*"         { return new_symbol(sym.MUL, yytext()); }
"/"         { return new_symbol(sym.DIV, yytext()); }
"%"         { return new_symbol(sym.MODUO, yytext()); }
"=="        { return new_symbol(sym.IS_EQUAL, yytext()); }
"!="        { return new_symbol(sym.NOT_EQUAL, yytext()); }
">"         { return new_symbol(sym.GREATER, yytext()); }
">="        { return new_symbol(sym.GREATER_EQUAL, yytext()); }
"<"         { return new_symbol(sym.LESS, yytext()); }
"<="        { return new_symbol(sym.LESS_EQUAL, yytext()); }
"&&"        { return new_symbol(sym.AND, yytext()); }
"||"        { return new_symbol(sym.OR, yytext()); }
"=" 		{ return new_symbol(sym.EQUAL, yytext()); }
"+="		{ return new_symbol(sym.PLUS_EQUAL, yytext()); }
"-="		{ return new_symbol(sym.MINUS_EQUAL, yytext()); }
"*="		{ return new_symbol(sym.MUL_EQUAL, yytext()); }
"/="		{ return new_symbol(sym.DIV_EQUAL, yytext()); }
"%="		{ return new_symbol(sym.MODUO_EQUAL, yytext()); }
"++"        { return new_symbol(sym.PLUS_PLUS, yytext()); }
"--"        { return new_symbol(sym.MINUS_MINUS, yytext()); }
";" 		{ return new_symbol(sym.SEMI, yytext()); }
"," 		{ return new_symbol(sym.COMMA, yytext()); }
"."         { return new_symbol(sym.DOT, yytext()); }
"(" 		{ return new_symbol(sym.LPAREN, yytext()); }
")" 		{ return new_symbol(sym.RPAREN, yytext()); }
"["         { return new_symbol(sym.LBRACKET, yytext()); }
"]"         { return new_symbol(sym.RBRACKET, yytext()); }
"{" 		{ return new_symbol(sym.LBRACE, yytext()); }
"}"			{ return new_symbol(sym.RBRACE, yytext()); }

// drugacije akcije, nema vracanja tokena vec se poziva dodatno stanje
"//" 		     { yybegin(COMMENT); }
<COMMENT> .      { yybegin(COMMENT); } // bilo koji znak koji se pronadje iz ulaznog fajla
<COMMENT> "\r\n" { yybegin(YYINITIAL); } // kada se u stanju komentara dodje do kraja reda prelazimo u novo stanje

// celobrojne konstante i identifikatori
[0-9]+  							{ return new_symbol(sym.NUM_CONST, new Integer(yytext())); }
"'"[\040-\176]"'"          			{ return new_symbol(sym.CHAR_CONST, yycharat(1)); }
"true"  							{ return new_symbol(sym.BOOL_CONST, new Boolean(true)); }
"false" 							{ return new_symbol(sym.BOOL_CONST, new Boolean(false)); }
([a-z]|[A-Z])[a-z|A-Z|0-9|_]* 		{ return new_symbol(sym.IDENT, yytext()); }

// znak koji nije specificiran leksikom jezika, ispis leksicke greske
[0-9]+[a-z|A-Z|0-9|_]+ { System.err.println("Leksicka greska ("+yytext()+") na liniji ("+(yyline+1)+") i koloni ("+(yycolumn+1)+")"); } 
. { System.err.println("Leksicka greska ("+yytext()+") na liniji ("+(yyline+1)+") i koloni ("+(yycolumn+1)+")" ); } 

