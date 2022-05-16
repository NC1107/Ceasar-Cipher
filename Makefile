main: main.asm cFunctions.c ceasar.asm
	nasm  -felf64 -g main.asm
	nasm  -felf64 -g ceasar.asm
	nasm  -felf64 -g extraCreditGame.asm
	gcc -c -g cFunctions.c
	gcc -no-pie -m64 -g -o main main.o cFunctions.o ceasar.o


run: main
	./main

clean:
	rm *.o main


valgrind:
	valgrind --leak-check=full --show-reachable=yes ./main