SRC=string_test.c
LIBOUT=libout.so
EXECOUT=out

all:
	gcc -o $(EXECOUT) $(SRC) 
	gcc -fPIC -shared -o $(LIBOUT) $(SRC)

clean:
	rm $(LIBOUT) $(EXECOUT)
