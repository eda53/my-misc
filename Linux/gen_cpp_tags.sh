#!/bin/sh

gen_cpp_tag_v1 () {
        # from: http://stackoverflow.com/questions/24489855/generate-ctags-for-libstdc-from-current-gcc

        # Please note that the real trick to getting most of the tags generated is the -I option!
        # It may need to be tweaked. Of course, the --c-kinds/c++-kinds and fields options can be adjusted as well.

        CPP_VERSION=4.9.2
        INC_DIR=/opt/Xilinx/SDK/2016.1/gnu/aarch32/lin/gcc-arm-linux-gnueabi/arm-linux-gnueabihf/include/c++/$CPP_VERSION
        CPP_TARGET=arm-linux-gnueabihf
        SYSTEM=/usr/lib/gcc/x86_64-linux-gnu/4.8/include
        SYSTEM2=/usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed

        ctags -f cpp_tags           \
                --c-kinds=cdefgmstuv    \
                --c++-kinds=cdefgmstuv  \
                --fields=+iaSmKz --extra=+q \
                --langmap=c++:+.tcc.  \
                --languages=c,c++ \
                -I "_GLIBCXX_BEGIN_NAMESPACE_VERSION _GLIBCXX_END_NAMESPACE_VERSION _GLIBCXX_VISIBILITY+" \
                -n $INC_DIR/* \
                $INC_DIR/$CPP_TARGET/bits/* \
                $INC_DIR/$CPP_TARGET/ext/* \
                $INC_DIR/bits/* \
                $INC_DIR/ext/* \
                $INC_DIR/tr1/* \
                $INC_DIR/tr2/*
}

gen_cpp_tag_v1
