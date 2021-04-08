import java_cup.runtime.*;

%%
/* ----------------- Options and Declarations Section----------------- */

/*
   The name of the class JFlex will create will be Scanner.
   Will write the code to the file Scanner.java.
*/
%class Scanner

/*
  The current line number can be accessed with the variable yyline
  and the current column number with the variable yycolumn.
*/
%line
%column

/*
   Will switch to a CUP compatibility mode to interface with a CUP
   generated parser.
*/
%cup
%unicode

/*
  Declarations
  Code between %{ and %}, both of which must be at the beginning of a
  line, will be copied letter to letter into the lexer class source.
  Here you declare member variables and functions that are used inside
  scanner actions.
*/

%{
    StringBuilder buffer = new StringBuilder();
    /**
        The following two methods create java_cup.runtime.Symbol objects
    **/
    private Symbol symbol(int type) {
       return new Symbol(type, yyline, yycolumn);
    }
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/*
  Macro Declarations
  These declarations are regular expressions that will be used latter
  in the Lexical Rules Section.
*/

/* A line terminator is a \r (carriage return), \n (line feed), or
   \r\n. */
LineTerminator = \r|\n|\r\n

/* White space is a line terminator, space, tab, or line feed. */
WhiteSpace     = {LineTerminator} | [ \t\f]

Identifier = [:jletter:] [:jletterdigit:]*

conflictResolver =  [)]{WhiteSpace}*[{]

/* A literal integer is is a number beginning with a number between
   one and nine followed by zero or more numbers between zero and nine
   or just a zero.  */

%state STRING

%%
/* ------------------------Lexical Rules Section---------------------- */

<YYINITIAL> "if"           { return symbol(sym.IF); }
<YYINITIAL> "else"         { return symbol(sym.ELSE); }
<YYINITIAL> "prefix"       { return symbol(sym.PREFIX); }
<YYINITIAL> "reverse"       { return symbol(sym.REVERSE); }

<YYINITIAL> {
/* operators */
  "+"              { return symbol(sym.PLUS); }                        //concatenation operator
  "("              { return symbol(sym.LPAREN); }                      //open parenthesis
  ")"              { return symbol(sym.RPAREN); }                      //close parenthesis
  "\""             { buffer.setLength(0); yybegin(STRING); }           //string
  "}"              { return symbol(sym.RCURL); }                      //close bracket
  ","              { return symbol(sym.COMMA); }                       //comma
  {Identifier}     { return symbol(sym.IDENTIFIER,yytext());}
  {WhiteSpace}     { /* do nothing */ }
  {conflictResolver} {return symbol(sym.CR);}

}

<STRING> {
  \"                             { yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, buffer.toString()); }
  [^\n\r\"\\]+                   { buffer.append( yytext() ); }
  \\t                            { buffer.append("\\t"); }
  \\n                            { buffer.append("\\n"); }
  \\r                            { buffer.append("\\r"); }
  \\\"                           { buffer.append("\""); }
  \\                             { buffer.append("\\"); }
}

/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]               { throw new Error("Illegal character <"+yytext()+">"); }