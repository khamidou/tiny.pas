default: tiny.pas
	fpc -Mtp tiny.pas

clean:
	rm *.o
	rm tiny
