all: tiny.pas lexer.pas lexlib.o
	fpc -Mtp lexlib.pas tiny.pas

lexlib.o: lexlib.pas
	fpc -Mtp lexlib.pas

lexer.pas: lexer.l
	plex lexer.l

clean:
	rm *.o
	rm lexer.pas
	rm tiny
