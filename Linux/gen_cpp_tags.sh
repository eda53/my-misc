#!/bin/sh


gen_cpp_tag_v1 () {
	# from: http://stackoverflow.com/questions/24489855/generate-ctags-for-libstdc-from-current-gcc

	# Please note that the real trick to getting most of the tags generated is the -I option!
	# It may need to be tweaked. Of course, the --c-kinds/c++-kinds and fields options can be adjusted as well.

	CPP_VERSION=5.4.0
	INC_DIR=/usr/include/c++/$CPP_VERSION
	CPP_TARGET=x86_64-linux-gnu
	SYSTEM=/usr/lib/gcc/x86_64-linux-gnu/$CPP_VERSION/include
	SYSTEM2=/usr/lib/gcc/x86_64-linux-gnu/$CPP_VERSION/include-fixed

	ctags -f ~/.bin/cpp_tags    \
		--c-kinds=cdefgmstuv    \
		--c++-kinds=cdefgmstuv  \
		--fields=+iaSmKz --extra=+q \
		--langmap=c++:+.tcc.  \
		--languages=c,c++ \
		-I "_GLIBCXX_BEGIN_NAMESPACE_VERSION _GLIBCXX_END_NAMESPACE_VERSION _GLIBCXX_NOEXCEPT _GLIBCXX_VISIBILITY+" \
		-n $INC_DIR/* /usr/include/$CPP_TARGET/c++/$CPP_VERSION/bits/* /usr/include/$CPP_TARGET/c++/$CPP_VERSION/ext/* $INC_DIR/bits/* $INC_DIR/ext/* $SYSTEM/* $SYSTEM2/*
}

gen_cpp_tag_v1
