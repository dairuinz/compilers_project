project: project.y project.l
	bison -d -t project.y
	flex -o project.lex.c project.l
	gcc -Wall -o project project.lex.c project.tab.c -lfl -lm
clean:
	rm -rf project project.lex.c project.tab.c project.tab.h
run: 
	./project test2.txt
