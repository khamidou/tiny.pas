{ Test program }
program test;

uses
    SysUtils;

var
    c: char;
begin
    c := 'a';
    if (c = 'b') or (c = 'c') then
    begin
        Writeln('Wot?');
    end;
end.
