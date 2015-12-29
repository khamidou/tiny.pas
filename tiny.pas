{
Compiler for tinypas. Everything is rolled in a single file.
}

program tinypascal;

uses
    SysUtils;

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
    _BEGIN = 10;
    _END = 11;
    _THEN = 12;
    _ELSE = 13;
    _DOT = 14;
    _AND = 15;
    _OR = 16;
    _PLUS = 17;
    _MINUS = 18;
    _MULT = 19;
    _DIV = 20;
    _FUNCTION = 21;
    _PROCEDURE = 22;

var
    yyinput: Text;
    yytext: String;

var
    tok: integer;

function strlen(s: String): integer;
begin
    strlen := length(s)
end;

procedure error(s: String; s2: String);
begin
    Write('Compilation error: ');
    Write(s);

    if s2 <> '' then
    begin
        Write(s2)
    end;

    Writeln('');
end;

{
  As far as lexers go, this one is pretty slow because
  it reads everything byte-by-byte.
}
function yylex: integer;
var
    c: Char;
    fpos: Integer;
begin
    yytext := '';
    Read(yyinput, c);

    while True do
    begin
        { Ignore white space and comments }
        if c = '{' then
            begin
                repeat
                    Read(yyinput, c);
                until (c = '}');

                Read(yyinput, c);
                continue;
            end
        { #9 and #10 are the Pascal notation for tab and \n, respectively. }
        else if (c = ' ') or (c = #10) or (c = #09) then
            begin
                repeat
                    Read(yyinput, c);
                until (c <> ' ') and (c <> #10) and (c <> #09);
                continue;
            end
        else
            break;

        Read(yyinput, c);
    end;

    if c = ';' then
        exit(_SEMICOLON)
    else if c = '.' then
        exit(_DOT);
    if ((c >= 'a') and (c <= 'z')) or ((c >= 'A') and (c <= 'Z'))  then
        begin
            repeat
                yytext := yytext + c;
                Read(yyinput, c);
            until (c = ' ') or (c = '\n') or (c = '\t') or (c = ';') or (c = '.');

            { We've read one char too much --- rewind the file position
              one character back.}
            fpos := Filepos(yyinput);
            Seek(yyinput, fpos - 1);

            { Convert to lowercase for convenience }
            yytext := Lowercase(yytext);

            if CompareText(yytext, 'program') = 0 then
                exit(_PROGRAM)
            else if CompareText(yytext, 'uses') = 0 then
                exit(_USES)
            else if CompareText(yytext, 'if') = 0 then
                exit(_IF)
            else
                exit(_IDENTIFIER);
        end;
end;

procedure pascal_program;
var
    token: integer;
begin
    token := yylex();
    if token <> _PROGRAM then
        error('expecting PROGRAM statement, got: ', yytext);

    token := yylex();
    if token <> _IDENTIFIER then
        error('expecting identifier, got: ', yytext);

    token := yylex();
    if token <> _SEMICOLON then
        error('expecting semicolon, got', yytext);

end;

begin
    assign(yyinput, 'test.pas');
    reset(yyinput);

    pascal_program();
end.
