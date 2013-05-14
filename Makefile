# image concolution benchmark Makefile
# ==================================================
CXX=g++
CXXFLAGS=-g

# some direct
MACHINE=$(shell uname -s)
ARCH=$(shell uname -p)

# includes
# =========
SDL_INCLUDE=$(shell sdl-config --cflags)
#OPENCL_INCLUDE=-I/home/karkouli/fromRnice/NVIDIA_GPU_Computing_SDK/OpenCL/common/inc/ -I /home/karkouli/fromRnice/NVIDIA_GPU_Computing_SDK/shared/inc/
OPENCL_INCLUDE=-Invidia/inc/
# Libs
# =========

GPU_UTILS_LIB=\
	/home/karkouli/fromRnice/NVIDIA_GPU_Computing_SDK/shared/obj/x86_64/release/shrUtils.cpp.o \
	/home/karkouli/fromRnice/NVIDIA_GPU_Computing_SDK/shared/obj/x86_64/release/cmd_arg_reader.cpp.o \
	/home/karkouli/fromRnice/NVIDIA_GPU_Computing_SDK/shared/obj/x86_64/release/rendercheckGL.cpp.o \
	/home/karkouli/fromRnice/NVIDIA_GPU_Computing_SDK/OpenCL/common/lib/liboclUtil_x86_64.a
	#/Developer/GPU\ Computing/shared/obj/x86_64/release/shrUtils.cpp.o \
	#/Developer/GPU\ Computing/shared/obj/x86_64/release/cmd_arg_reader.cpp.o \
	#/Developer/GPU\ Computing/shared/obj/x86_64/release/rendercheckGL.cpp.o \
	#/Developer/GPU\ Computing/OpenCL/common/lib/liboclUtil_x86_64.a
OPENCL_LIB=

SDL_LIB=$(shell sdl-config --libs) -ljpeg -lpng -ltiff
ifeq ($(MACHINE), Darwin)
SDL_LIB+= /opt/local/lib/libSDL_image.a -lGLEW
OPENCL_LIB+=-framework OpenCL -framework AppKit -lXmu
OPENCL_INCLUDE+=\
	-I/Developer/GPU\ Computing/OpenCL/common/inc		\
	-I/Developer/GPU\ Computing/shared/inc			\
	-F OpenCL

else

#SDL_INCLUDE+= -I/home/evl/kreda/devlib/include
#SDL_LIB+= -lGLU /home/evl/kreda/devlib/lib/libSDL_image.a /home/evl/kreda/devlib/lib/libGLEW.a
#SDL_INCLUDE+=
SDL_LIB+= -lGLU /usr/lib/x86_64-linux-gnu/libSDL_image-1.2.so.0.8.4 /usr/lib/x86_64-linux-gnu/libGLEW.so.1.7.0

endif


# everything together
INCLUDE=-I/usr/include $(SDL_INCLUDE) $(OPENCL_INCLUDE) $(shell freetype-config --cflags)
LIB=$(SDL_LIB) $(OPENCL_LIB) $(GPU_UTILS_LIB) $(shell freetype-config --libs)

# add additional headers for MacOSX
ifeq ($(MACHINE), Darwin)
INCLUDE+= -F OpenGL -I/opt/local/include
LIB+= -framework OpenGL -framework OpenCL
endif

# Object files
# =================================================
OBJ=					\
	graphics.o			\
	timer.o				\
	texture_unit.o			\
	vector_math.o			\
	misc.o				\
	common.o				\
	vis.o				\
	ocl.o				\
	benchmark.o			\
	batch_test.o			\
	FreeType.o			\
	#added
	multithreading.o		\
	shrUtils.o			\
	cmd_arg_reader.o		\
	rendercheckGL.o			\
	#endof added
	main.o

# Header files
# =================================================
HEADER=					\
	graphics.h			\
	timer.h				\
	texture_unit.h			\
	vector_math.h			\
	misc.h				\
	ocl.h				\
	benchmark.h			\
	batch_test.h			\
	common.h				\
	#added
	cmd_arg_reader.h		\
	exception.h			\
	multithreading.h		\
	rendercheckGL.h			\
	shrUtils.h			\
	#endof added	
	FreeType.h

TARGET=benchmark

$(TARGET):	$(OBJ)
	g++ -g $(OBJ) $(LIB) -o $(TARGET)

%.o: %.cpp $(HEADER)
	$(CXX) -c $(CXXFLAGS) $(INCLUDE) -o $@ $<

all:	$(TARGET)

clean:
	rm -rf $(OBJ)
	rm -rf $(TARGET)
	rm -rf nvidia/lib/%.o
	
#nvidia: nvidia/src/%.cpp
#	$(CXX) -c $(CXXFLAGS) $(OPENCL_INCLUDE) -o $@ $<
#	#nvidia/src/multithreading.cpp	nvidia/src/rendercheckGL.cpp  nvidia/src/shrUtils.cpp 





