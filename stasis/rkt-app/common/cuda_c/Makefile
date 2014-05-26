LIBDIR	:= $(HOME)/project-gpu/lib

EXE	:= stm
SRDOBJ	:= libstm.so
LIBFLG	:= -L$(LIBDIR) -L.
INCFLG	:= -I. -I./inc

CC	:= gcc
CFLAGS 	+= -g $(INCFLG)

#.o.c	:
#	$(CC) -c $<

LD_LIBRARY_PATH	+= ./lib

#--Suffix Rules -----------------------------------------------
.SUFFIXES: .c

.c.o	:
	$(CC) $(CFLAGS) -c $<

.c	:
	$(CC) $(CFLAGS) $< -o $@ -lm 


#--File Dependencies -----------------------------------------------
INCS	= stm_common.h
SRCS	= stm_main.c
OBJS	= $(addsuffix .o, $(basename $(SRCS)))

$(EXE)	: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBFLG) -lm -lstm


#--Extra -----------------------------------------------
depend	:
	makedepend $(CFLAGS) -Y $(SRCS)

clean	:
	rm $(OBJS) $(EXE)
