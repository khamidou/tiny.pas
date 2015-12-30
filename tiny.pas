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

{ Lexing-related values. }
var
    yyinput: Text;
    yyoutput: Text;
    yytext: String;
    yyunreadch: Char;
    yytoken: Integer;

var
    tok: integer;

{ Display a "user-friendly" error message. }
procedure error(s: String; s2: String);
begin
    Write('Compilation error: ');
    Write(s);

    if s2 <> '' then
    begin
        Write(s2)
    end;

    Writeln('');
    Halt(-1);
end;

{ Emit a line of assembly. }
procedure emit(s: String; s2: String);
begin
    Write(yyoutput, s);

    if s2 <> '' then
    begin
            Write(yyoutput, ', ');
            Write(yyoutput, s2);
    end;

    Writeln(yyoutput, '');
end;

{ Get a character from the file. Returns
  yyunreadch if it's defined.
}
function Getch: Char;
var
    c: Char;
begin
    if yyunreadch = #0 then
        Read(yyinput, c)
    else
    begin
        c := yyunreadch;
        yyunreadch := #0;
    end;

    exit(c);
end;

procedure Ungetc(c: Char);
begin
    yyunreadch := c;
end;

procedure yysetup;
begin
    yyunreadch := #0;
    yytoken := 0;
end;

{
  As far as lexers go, this one is pretty slow because

  it reads everything byte-by-byte.
}
function NextToken: integer;
var
    c: Char;
    fpos: Integer;
begin
    yytext := '';
    c := Getch();

    while True do
    begin
        { Ignore white space and comments }
        if c = '{' then
            begin
                repeat
                    c := Getch();
                until (c = '}');

                c := Getch();
                continue;
            end
        { #9 and #10 are the Pascal notation for tab and \n, respectively. }
        else if (c = ' ') or (c = #10) or (c = #09) then
            begin
                repeat
                    c := Getch();
                until (c <> ' ') and (c <> #10) and (c <> #09);
                continue;
            end
        else
            break;

        c := Getch();
    end;

    if c = ';' then
        exit(_SEMICOLON)
    else if c = '.' then
        exit(_DOT);
    if ((c >= 'a') and (c <= 'z')) or ((c >= 'A') and (c <= 'Z'))  then
        begin
            repeat
                yytext := yytext + c;
                c := Getch();
            until (c = ' ') or (c = '\n') or (c = '\t') or (c = ';') or (c = '.');

            { If we're here, we've read one character too far. Put it back. }
            Ungetc(c);

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

function yylex: Integer;
var
    token: Integer;
begin
    if yytoken = 0 then
        exit(nextToken());
    else
        begin
            token := yytoken;
            yytoken := 0
            exit(token);
        end;
end;

procedure yyunread(token: Integer);
begin
    yytoken := token
end;

{ I'm using the Pascal grammar from
  http://www2.informatik.uni-halle.de/lehre/pascal/sprache/pas_bnf.html }
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
        error('expecting semicolon, got: ', yytext);

    code_block();

    token := yylex();
    if token <> _DOT then
        error('expecting dot, got: ', yytext);

end;

procedure code_block;
var
    token: integer;
begin
    token := yylex();
    if token <> _BEGIN then
        error('expecting BEGIN statement, got: ', yytext);

    statement_list();

    token := yylex();
    if token <> _END then
        error('expecting END statement, got: ', yytext);
end;

procedure statement_list;
var
    token: integer;
begin
    token := yylex();

    if token := _IDENTIFIER then
        expression();
    else
        yyunread(token);
        exit();
end;

procedure expression;
var
    token; integer;
begin
    token := yylex();
end;

begin
    assign(yyinput, 'test.pas');
    reset(yyinput);
    yysetup();

    pascal_program();
    Writeln('Program compiled.');
end.
