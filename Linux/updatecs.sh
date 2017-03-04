#!/bin/bash

# disable globbing, i.e. wild expansion (*)
set -f

rm -rf files.cs.txt.* cscope.out* tags

FF=" ( -name *.h "
FF+="-o -name *.hpp "
FF+="-o -name *.inl "
FF+="-o -name *.hrh "

FF+="-o -name *.cpp "
FF+="-o -name *.cc  "
FF+="-o -name *.c   "
FF+="-o -name *.S   "

FF+="-o -name *.java "
FF+="-o -name *.xml "
FF+="-o -name *.pl  "
FF+="-o -name *.py  "
FF+="-o -name *.vhd "

FF+="-o -name *.php "
FF+="-o -name *.js  "

FF+="-o -name [Mm]akefile* "
FF+="-o -name *.mk "
FF+=" ) "

searchDir() {
	if [ -n "$1" ]; then
		echo "Collecting [$(readlink -f $1)] ..."
		find "$(readlink -f $1)" -not -iwholename '*.svn*' -not -iwholename '*.bak/*' $FF -type f -exec readlink -f {} \; >> files.cs.txt.1
	fi
}

searchDir .

for dir in "$@"; do
	searchDir $dir
done

#sort files.cs.txt -o files.cs.txt
sort files.cs.txt.1 -o files.cs.txt.2

sed "s/\/export\/local\/eda/~/" <files.cs.txt.2 >files.cs.txt
sed -i '/ /s/^\(.\+\)$/"&"/' files.cs.txt

sed 's/^/"/' <files.cs.txt.2 >files.cs.txt.3
sed 's/$/"/' <files.cs.txt.3 >files.cs.txt.2

echo "Generating cscope database ..."
cscope -kb -i files.cs.txt.2 || rm files.cs.txt
ctags -L files.cs.txt --c++-kinds=+p --fields=+iaS --extra=+q

rm -rf files.cs.txt.1 files.cs.txt.2 files.cs.txt.3


gen_cpp_tag_v1 () {
	# from: http://stackoverflow.com/questions/24489855/generate-ctags-for-libstdc-from-current-gcc

	# Please note that the real trick to getting most of the tags generated is the -I option!
	# It may need to be tweaked. Of course, the --c-kinds/c++-kinds and fields options can be adjusted as well.

	CPP_VERSION=4.8
	INC_DIR=/usr/include/c++/$CPP_VERSION
	CPP_TARGET=x86_64-linux-gnu
	SYSTEM=/usr/lib/gcc/x86_64-linux-gnu/4.8/include
	SYSTEM2=/usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed

	ctags -f cpp_tags           \
		--c-kinds=cdefgmstuv    \
		--c++-kinds=cdefgmstuv  \
		--fields=+iaSmKz --extra=+q \
		--langmap=c++:+.tcc.  \
		--languages=c,c++ \
		-I "_GLIBCXX_BEGIN_NAMESPACE_VERSION _GLIBCXX_END_NAMESPACE_VERSION _GLIBCXX_VISIBILITY+" \
		-n $INC_DIR/* /usr/include/$CPP_TARGET/c++/$CPP_VERSION/bits/* /usr/include/$CPP_TARGET/c++/$CPP_VERSION/ext/* $INC_DIR/bits/* $INC_DIR/ext $SYSTEM/* $SYSTEM2/*
}

gen_cpp_tag_v2 () {
	# from: http://stackoverflow.com/questions/24489855/generate-ctags-for-libstdc-from-current-gcc

	cp -R /usr/include/c++/$GCC_VERSION ~/.vim/cpp_src
	# it is not necessary to rename headers without an extension 
	# replace the "namespace std _GLIBCXX_VISIBILITY(default)" with "namespace std" 
	find . -type f | xargs sed -i 's/namespace std _GLIBCXX_VISIBILITY(default)/namespace std/' 
	ctags -f cpp_tags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -I _GLIBCXX_NOEXCEPT cpp_src

	<<VIMRC
	" OmniCppComplete
	let OmniCpp_NamespaceSearch = 1
	let OmniCpp_GlobalScopeSearch = 1
	let OmniCpp_ShowAccess = 1
	let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
	let OmniCpp_MayCompleteDot = 1 " autocomplete after .
	let OmniCpp_MayCompleteArrow = 1 " autocomplete after -&gt;
	let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
	" also necessary for fixing LIBSTDC++ releated stuff
	let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
	" automatically open and close the popup menu / preview window
	au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif set completeopt=menuone,menu,longest,preview
	VIMRC
}

