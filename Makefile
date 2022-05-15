main: main.asm cFunctions.c 
	nasm  -felf64 -g main.asm
	nasm  -felf64 -g extraCreditGame.asm
	gcc -c -g cFunctions.c
	gcc -no-pie -m64 -g -o main main.o cFunctions.o


run: main
	./main

clean:
	rm *.o main