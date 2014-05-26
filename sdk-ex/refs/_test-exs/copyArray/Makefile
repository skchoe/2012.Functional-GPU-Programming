all:	
	gcc -o ptr_test ptr_test.c
	gcc -fPIC -shared -o libptr_test.so ptr_test.c

clean:
	rm ptr_test libptr_test.so *.*~
