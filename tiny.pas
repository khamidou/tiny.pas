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
    _EQUAL = 23;
    _ASSIGNMENT = 24;
    _LESS_THAN = 25;
    _MORE_THAN = 26;

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
    Write('[0;31;40m');
    Write('Compilation error: ');
    Write(s);

    if s2 <> '' then
    begin
        Write(s2)
    end;

    Writeln('[0;37;40m');
    Halt(-1);
end;

procedure yysetup;
begin
    yyunreadch := #0;
    yytoken := 0;
end;

{ Get a character from the file. Returns yyunreadch if it's defined. }
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

{
  As far as lexers go, this one is pretty slow because
  it reads everything byte-by-byte.
}
function NextToken: integer;
var
    c: Char;
    fpos: Integer;
    s: String; { Temporary string }
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
        exit(_DOT)
    else if c = '+' then
        exit(_PLUS)
    else if c = '-' then
        exit(_MINUS)
    else if c = '*' then
        exit(_MULT)
    else if c = '/' then
        exit(_DIV)
    else if c = ':' then
        begin
            c := Getch();

            if c <> '=' then
                error('expected :=, got ', yytext);

            exit(_ASSIGNMENT)
        end
    else if (c >= '0') and (c <= '9') then
        begin
            yytext := '';

            repeat
                yytext := yytext + c;
                c := Getch()
            until (c < '0') or (c > '9');

            { We've read one character too many. Put it back. }
            Ungetc(c);
            exit(_NUMBER);

        end
    else if ((c >= 'a') and (c <= 'z')) or ((c >= 'A') and (c <= 'Z'))  then
        begin

            repeat
                yytext := yytext + c;
                c := Getch();
            until (c = ' ') or (c = #10) or (c = #09) or (c = ';') or (c = '.');

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
            else if CompareText(yytext, 'begin') = 0 then
                exit(_BEGIN)
            else if CompareText(yytext, 'end') = 0 then
                exit(_END)
            else
                exit(_IDENTIFIER);
        end;
end;

function yylex: Integer;
var
    token: Integer;
begin
    if yytoken = 0 then
        token := nextToken()
    else
        begin
            token := yytoken;
            yytoken := 0;
        end;

    exit(token)
end;

procedure yyunread(token: Integer);
begin
    yytoken := token
end;

{ I'm using the Pascal grammar from
  http://www2.informatik.uni-halle.de/lehre/pascal/sprache/pas_bnf.html }

procedure pascal_program; Forward;
procedure code_block; Forward;
procedure statement_list; Forward;
procedure additive_expression; Forward;
procedure multiplicative_expression; Forward;
procedure emit(s: String; s2: String); Forward;

procedure pascal_program;
var
    token: integer;
begin
    token := yylex();
    if token <> _PROGRAM then
    begin
        error('expecting PROGRAM statement, got: ', yytext)
    end;

    token := yylex();
    if token <> _IDENTIFIER then
    begin
        error('expecting identifier, got: ', yytext)
    end;

    token := yylex();
    if token <> _SEMICOLON then
    begin
        error('expecting semicolon, got: ', yytext)
    end;

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

    if token = _IDENTIFIER then
        begin
            token := yylex();
            if token = _ASSIGNMENT then
                additive_expression()
            else
                error('expecting '':='', got: ', yytext);
        end
    else if token = _END then
        begin
            yyunread(token);
            exit()
        end
end;

procedure additive_expression;
var
    token: integer;
begin
    multiplicative_expression();

    token := yylex();
    { The user typed a single number. Return. }
    if (token = _SEMICOLON) or (token = _END) then
        begin
            yyunread(token);
            exit()
        end;

    if (token = _PLUS) or (token = _MINUS) then
        begin
            additive_expression();

            Emit('pop rbx', '');
            Emit('pop rax', '');

            if token = _PLUS then
                Emit('add rax, rbx', '')
            else if token = _MINUS then
                Emit('sub rax, rbx', '');

            { Don't forget to push the result back on the stack }
            Emit('push rax', '')
        end
    else
        Error('unexpected token ', yytext)

end;

procedure multiplicative_expression;
var
    token: integer;
begin
    token := yylex();

    if token <> _NUMBER then
        Error('expecting number, got:', yytext);

    Emit('mov rax', yytext);
    Emit('push rax', '');

    token := yylex();

    { The user typed a single number. Return. }
    if token = _MULT then
        begin
            multiplicative_expression();
            Emit('pop rbx', '');
            Emit('pop rax', '');
            Emit('imul rax, rbx', '');
            Emit('push rax', '');
        end
    else
        begin
            yyunread(token);
            exit()
        end
end;

procedure emit_assembly_header;
begin
    Writeln('; On MacOS X use something like /usr/local/bin/nasm -f macho64 file.asm && ld -macosx_version_min 10.7.0 -lSystem -o file file.o && ./file');
    Writeln('; to compile. You may need to get nasm from homebrew.');
    Writeln('global start');
    Writeln('');
    Writeln('section .text');
    Writeln('start:');
    Writeln('; setup the stack');
    Writeln('    push rbp');
    Writeln('    mov rbp, rsp');
end;

procedure emit_assembly_footer;
begin
    Writeln('    ; call MacOS'' exit routine');
    Writeln('    mov rax, 0x2000001');
    Writeln('    mov rdi, 0');
    Writeln('    syscall');
    Writeln('; Over and out')
end;

{ Emit a line of assembly. }
procedure emit(s: String; s2: String);
begin
    Write('    ');
    Write(s);

    if s2 <> '' then
    begin
            Write(', ');
            Write(s2);
    end;

    Writeln('');
end;


begin
    assign(yyinput, ParamStr(1));
    reset(yyinput);
    yysetup();

    emit_assembly_header;

    pascal_program();

    emit_assembly_footer;
end.
