%%

[ \t\n]+        return(_WHITE_SPACE);
[0-9]+          return(_NUMBER);
'program'       return(_PROGRAM);
'\{'            return(_LBRACE);
'\}'            return(_RBRACE);
'if'            return(_IF);
;               return(_SEMICOLON);
