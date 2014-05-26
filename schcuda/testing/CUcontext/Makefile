NAME=CUcontext
all:
	gcc -c -fPIC $(NAME).c -o $(NAME).o 
	gcc -shared -Wl  -o lib$(NAME).so $(NAME).o
clean:
	rm $(NAME).o
	rm lib$(NAME).so
