%{
{tinypascal --- a tiny, tiny pascal compiler}
program tinypascal;

uses
    SysUtils;

type
    Token = (_PROGRAM, _USES, _EOF);
var
    inputFile: TextFile;

procedure openFile(fileName: String);
begin
    AssignFile(inputFile, fileName);
    reset(inputFile);
end;

function strlen(s: String): integer
    strlen = byte(s[0])
end

function getch(): char;
var
    c: char;
begin
    read(inputFile, c);
    getch:= c;
end;

function lexer(): Token;
var
    c: char;
begin
    if eof(inputFile) then
    begin
        lexer := _EOF;
    end;

    yytext := ''

    (Skip spaces)
    c := getch()
    while c = ' ' or c = '\t' or c = '\n' do
    begin
        c := getch()
    end;

    if c = ';'
        lexer := _SEMICOLON;
    while c <> ' ' and c <> '\t' and c <> '\n' do
    begin

    end;

    lexer := _PROGRAM;
end;

var
    ret: integer;
begin
    openFile('hello.pas');
    writeln(lexer());
end.
%}

%%

[ \t\n]+    return(_WHITE_SPACE);
number [0-9]+   return(_NUMBER);
alpha [a-zA-Z_]+    return(_IDENTIFIER);
"{"     return(_LBRACE);
"}"     return(_RBRACE);
"program"   return(_PROGRAM);
"if"    return(_IF);

.return(ILLEGAL);
