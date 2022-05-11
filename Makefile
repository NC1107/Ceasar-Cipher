main: main.asm cFunctions.c
	nasm  -felf64 -g main.asm
	gcc -c -g cFunctions.c
	gcc -no-pie -m64 -g -o main main.o cFunctions.o

run: main
	./main

clean:
	rm *.o