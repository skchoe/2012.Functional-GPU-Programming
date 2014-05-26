SRCDIR	:= src


LIBDIR	:= $(HOME)/project-gpu/lib

SRDOBJ	:= libstm.so
LIBFLG	:= -L$(LIBDIR)
INCFLG	:= -I. -I../inc

CC	:= gcc
CFLAGS 	+= -g $(INCFLG)
CFLAGS	+= -fPIC -shared

#.o.c	:
#	$(CC) -c $<


#--Suffix Rules -----------------------------------------------
.SUFFIXES: .c

.c.o	:
	$(CC) $(CFLAGS) -c $<

.c	:
	$(CC) $(CFLAGS) $< -o $@ -lm 


#--File Dependencies -----------------------------------------------
INCS	= stm_common.h
SRCS	= stm_driver.c stm_kernel.c stm_common.c
OBJS	= $(addsuffix .o, $(basename $(SRCS)))

$(SRDOBJ)	: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) -lm 
	mv $@ $(LIBDIR)


#--Extra -----------------------------------------------
depend	:
	makedepend $(CFLAGS) -Y $(SRCS)

clean	:
	rm $(OBJS) $(LIBDIR)/$(SRDOBJ)
