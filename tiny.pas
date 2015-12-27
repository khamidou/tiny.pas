{
Compiler for tinypas. Everything is rolled in a single file.
}

program tinypascal;

uses
    SysUtils, LexLib;

const
    _PROGRAM = 1;
    _USES = 2;
    _WHITE_SPACE = 3;
    _NUMBER = 4;
    _IDENTIFIER = 5;
    _LBRACE = 6;
    _RBRACE = 7;
    _IF = 8;
    _SEMICOLON = 9;

var
    yyinput: Text;
    yytext: String;

var
    tok: integer;

function strlen(s: String): integer;
begin
    strlen := length(s)
end;

function yylex: integer;
var
    c: char;
    i: integer;
    s: String;
begin
    s := '';
    i := 0;

    { Ignore white space }
    repeat
        Read(yyinput, c);
    until (c = ' ' or c = '\t' or c = '\n');

    if c = '{' then
        repeat
            Read(yyinput, c);
        until (c = '}' or c = '\t' or c = '\n');
    end

    repeat
        Read(yyinput, c)


    repeat
        Read(yyinput, c);
        i := i + 1
        s[i] = c;
    until (c = ' ' or c = '\t' or c = '\n');

    Write(c);
    yylex := _PROGRAM;
end;

procedure error(s: String; s2: String);
begin
    Write('Error at line ');
    Write(yylineno);
    Write(':');
    Write(yycolno);
    Write(' ');
    Write(s);

    if s2 <> '' then
    begin
        Write(s2)
    end;

    Writeln('');
end;

function strip_whitespace: integer;
var
    token: integer;
begin
    repeat
        token := yylex();
    until(token <> 3);

    strip_whitespace := token
end;

procedure pascal_program;
var
    token: integer;
begin
    token := strip_whitespace();
    if token <> _PROGRAM then
    begin
        error('Expecting PROGRAM statement, got: ', yytext)
    end;
end;

begin
    assign(yyinput, 'test.pas');
    assign(yyoutput, '');
    reset(yyinput); rewrite(yyoutput);
    yylineno := 0;
    yyclear;

    pascal_program();
end.
