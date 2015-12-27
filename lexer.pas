
(* lexical analyzer template (TP Lex V3.0), V1.0 3-2-91 AG *)

(* global definitions: *)

function yylex : Integer;

procedure yyaction ( yyruleno : Integer );
  (* local definitions: *)

begin
  (* actions: *)
  case yyruleno of
  1:
                return(_WHITE_SPACE);
  2:
                return(_NUMBER);
  3:
                return(_PROGRAM);
  4:
                return(_LBRACE);
  5:
                return(_RBRACE);
  6:
                return(_IF);
  7:
                return(_SEMICOLON);
  end;
end(*yyaction*);

(* DFA table: *)

type YYTRec = record
                cc : set of Char;
                s  : Integer;
              end;

const

yynmarks   = 7;
yynmatches = 7;
yyntrans   = 25;
yynstates  = 21;

yyk : array [1..yynmarks] of Integer = (
  { 0: }
  { 1: }
  { 2: }
  1,
  { 3: }
  2,
  { 4: }
  { 5: }
  7,
  { 6: }
  { 7: }
  { 8: }
  { 9: }
  { 10: }
  { 11: }
  4,
  { 12: }
  5,
  { 13: }
  { 14: }
  { 15: }
  6,
  { 16: }
  { 17: }
  { 18: }
  { 19: }
  { 20: }
  3
);

yym : array [1..yynmatches] of Integer = (
{ 0: }
{ 1: }
{ 2: }
  1,
{ 3: }
  2,
{ 4: }
{ 5: }
  7,
{ 6: }
{ 7: }
{ 8: }
{ 9: }
{ 10: }
{ 11: }
  4,
{ 12: }
  5,
{ 13: }
{ 14: }
{ 15: }
  6,
{ 16: }
{ 17: }
{ 18: }
{ 19: }
{ 20: }
  3
);

yyt : array [1..yyntrans] of YYTrec = (
{ 0: }
  ( cc: [ #9,#10,' ' ]; s: 2),
  ( cc: [ '''' ]; s: 4),
  ( cc: [ '0'..'9' ]; s: 3),
  ( cc: [ ';' ]; s: 5),
{ 1: }
  ( cc: [ #9,#10,' ' ]; s: 2),
  ( cc: [ '''' ]; s: 4),
  ( cc: [ '0'..'9' ]; s: 3),
  ( cc: [ ';' ]; s: 5),
{ 2: }
  ( cc: [ #9,#10,' ' ]; s: 2),
{ 3: }
  ( cc: [ '0'..'9' ]; s: 3),
{ 4: }
  ( cc: [ 'i' ]; s: 9),
  ( cc: [ 'p' ]; s: 6),
  ( cc: [ '{' ]; s: 7),
  ( cc: [ '}' ]; s: 8),
{ 5: }
{ 6: }
  ( cc: [ 'r' ]; s: 10),
{ 7: }
  ( cc: [ '''' ]; s: 11),
{ 8: }
  ( cc: [ '''' ]; s: 12),
{ 9: }
  ( cc: [ 'f' ]; s: 13),
{ 10: }
  ( cc: [ 'o' ]; s: 14),
{ 11: }
{ 12: }
{ 13: }
  ( cc: [ '''' ]; s: 15),
{ 14: }
  ( cc: [ 'g' ]; s: 16),
{ 15: }
{ 16: }
  ( cc: [ 'r' ]; s: 17),
{ 17: }
  ( cc: [ 'a' ]; s: 18),
{ 18: }
  ( cc: [ 'm' ]; s: 19),
{ 19: }
  ( cc: [ '''' ]; s: 20)
{ 20: }
);

yykl : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 1,
{ 3: } 2,
{ 4: } 3,
{ 5: } 3,
{ 6: } 4,
{ 7: } 4,
{ 8: } 4,
{ 9: } 4,
{ 10: } 4,
{ 11: } 4,
{ 12: } 5,
{ 13: } 6,
{ 14: } 6,
{ 15: } 6,
{ 16: } 7,
{ 17: } 7,
{ 18: } 7,
{ 19: } 7,
{ 20: } 7
);

yykh : array [0..yynstates-1] of Integer = (
{ 0: } 0,
{ 1: } 0,
{ 2: } 1,
{ 3: } 2,
{ 4: } 2,
{ 5: } 3,
{ 6: } 3,
{ 7: } 3,
{ 8: } 3,
{ 9: } 3,
{ 10: } 3,
{ 11: } 4,
{ 12: } 5,
{ 13: } 5,
{ 14: } 5,
{ 15: } 6,
{ 16: } 6,
{ 17: } 6,
{ 18: } 6,
{ 19: } 6,
{ 20: } 7
);

yyml : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 1,
{ 3: } 2,
{ 4: } 3,
{ 5: } 3,
{ 6: } 4,
{ 7: } 4,
{ 8: } 4,
{ 9: } 4,
{ 10: } 4,
{ 11: } 4,
{ 12: } 5,
{ 13: } 6,
{ 14: } 6,
{ 15: } 6,
{ 16: } 7,
{ 17: } 7,
{ 18: } 7,
{ 19: } 7,
{ 20: } 7
);

yymh : array [0..yynstates-1] of Integer = (
{ 0: } 0,
{ 1: } 0,
{ 2: } 1,
{ 3: } 2,
{ 4: } 2,
{ 5: } 3,
{ 6: } 3,
{ 7: } 3,
{ 8: } 3,
{ 9: } 3,
{ 10: } 3,
{ 11: } 4,
{ 12: } 5,
{ 13: } 5,
{ 14: } 5,
{ 15: } 6,
{ 16: } 6,
{ 17: } 6,
{ 18: } 6,
{ 19: } 6,
{ 20: } 7
);

yytl : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 5,
{ 2: } 9,
{ 3: } 10,
{ 4: } 11,
{ 5: } 15,
{ 6: } 15,
{ 7: } 16,
{ 8: } 17,
{ 9: } 18,
{ 10: } 19,
{ 11: } 20,
{ 12: } 20,
{ 13: } 20,
{ 14: } 21,
{ 15: } 22,
{ 16: } 22,
{ 17: } 23,
{ 18: } 24,
{ 19: } 25,
{ 20: } 26
);

yyth : array [0..yynstates-1] of Integer = (
{ 0: } 4,
{ 1: } 8,
{ 2: } 9,
{ 3: } 10,
{ 4: } 14,
{ 5: } 14,
{ 6: } 15,
{ 7: } 16,
{ 8: } 17,
{ 9: } 18,
{ 10: } 19,
{ 11: } 19,
{ 12: } 19,
{ 13: } 20,
{ 14: } 21,
{ 15: } 21,
{ 16: } 22,
{ 17: } 23,
{ 18: } 24,
{ 19: } 25,
{ 20: } 25
);


var yyn : Integer;

label start, scan, action;

begin

start:

  (* initialize: *)

  yynew;

scan:

  (* mark positions and matches: *)

  for yyn := yykl[yystate] to     yykh[yystate] do yymark(yyk[yyn]);
  for yyn := yymh[yystate] downto yyml[yystate] do yymatch(yym[yyn]);

  if yytl[yystate]>yyth[yystate] then goto action; (* dead state *)

  (* get next character: *)

  yyscan;

  (* determine action: *)

  yyn := yytl[yystate];
  while (yyn<=yyth[yystate]) and not (yyactchar in yyt[yyn].cc) do inc(yyn);
  if yyn>yyth[yystate] then goto action;
    (* no transition on yyactchar in this state *)

  (* switch to new state: *)

  yystate := yyt[yyn].s;

  goto scan;

action:

  (* execute action: *)

  if yyfind(yyrule) then
    begin
      yyaction(yyrule);
      if yyreject then goto action;
    end
  else if not yydefault and yywrap() then
    begin
      yyclear;
      return(0);
    end;

  if not yydone then goto start;

  yylex := yyretval;

end(*yylex*);

