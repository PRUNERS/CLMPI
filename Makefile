include ./Makefile.config

SRC_DIR=.

#===== edit "clmpi" to your binary name ===========
clmpi_SRCS =	$(SRC_DIR)/clmpi_status.c \
		$(SRC_DIR)/clmpi.cpp \
		$(SRC_DIR)/clmpi_piggyback.c \
		$(SRC_DIR)/clmpi_request.cpp \

clmpi_OBJS =	$(SRC_DIR)/clmpi_status.o \
		$(SRC_DIR)/clmpi.o \
		$(SRC_DIR)/clmpi_piggyback.o \
		$(SRC_DIR)/clmpi_request.o \

clmpi_DEPS =	$(SRC_DIR)/clmpi_status.d \
		$(SRC_DIR)/clmpi.d \
		$(SRC_DIR)/clmpi_piggyback.d \
		$(SRC_DIR)/clmpi_request.d \

clmpi_HEAD = ./clmpi.h
clmpi_o_LIBS  =	./libclmpi.o
clmpi_a_LIBS  =	./libclmpi.a 
clmpi_so_LIBS =	./libclmpi.so	
#===================================================

OBJS = $(clmpi_OBJS)
DEPS = $(clmpi_DEPS)
LIBS = $(clmpi_a_LIBS) $(clmpi_so_LIBS) 
#LIBS = $(clmpi_a_LIBS) 

#$@: target name
#$<: first dependent file
#$^: all indemendent files

all: $(LIBS)

-include $(DEPS)


$(clmpi_a_LIBS):  $(clmpi_OBJS)
#	ws 0 $^
#	ld -o $(clmpi_o_LIBS) -r $^
#	ar cr  $@ $^
	ws $(clmpi_o_LIBS) 0 $^
	ar cr  $@ $(clmpi_o_LIBS)
	ranlib $@

$(clmpi_so_LIBS):  $(clmpi_OBJS) $(clmpi_a_LIBS)
#	ws 0 $^
#	$(CC) -shared -o $@ $^
	$(CC) -shared -o $@ $(clmpi_o_LIBS)


.SUFFIXES: .c .o
.c.o: 
	$(CC) $(CFLAGS) $(LDFLAGS) -c -MMD -MP $< 
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ -c $< 

.SUFFIXES: .cpp .o
.cpp.o:
	$(CC) $(CXXFLAGS) $(LDFLAGS) -c -MMD -MP $<
	$(CC) $(CXXFLAGS) $(LDFLAGS) -o $@ -c $< 

install: $(LIBS)
#	for mymod in $(clmpi_so_LIBS); do ( $(PNMPI_BIN_PATH)/pnmpi-patch $$mymod    $(PNMPI_MOD_LIB_PATH)/$$mymod ); done
	for mymod in $(clmpi_so_LIBS); do ( cp $$mymod    $(PNMPI_MOD_LIB_PATH)/$$mymod ); done
	for mymod in $(clmpi_a_LIBS);  do ( cp $$mymod    $(PNMPI_MOD_LIB_PATH)/$$mymod ); done
	for myheader in $(clmpi_HEAD); do ( cp $$myheader $(PNMPI_INC_PATH)/$$myheader  ); done

uninstall:
	for mymod in $(LIBS);          do ( rm $(PNMPI_MOD_LIB_PATH)/$$mymod ); done
	for myheader in $(clmpi_HEAD); do ( rm $(PNMPI_INC_PATH)/$$myheader  ); done

.PHONY: clean
clean:
	-rm -rf $(PROGRAM) $(OBJS) $(DEPS) $(LIBS) $(clmpi_o_LIBS)

.PHONY: clean_core
clean_core:
	-rm -rf *.core

