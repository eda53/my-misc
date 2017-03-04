if [ -n "$1" ]; then pushd $1; fi

for fil in `find . -type f -not -path '*.svn*' -exec egrep -q '^LDFLAGS[ \t]*\+=[ \t]*-Wl[ \t]$' {} \; -printf "%p "`; do
    echo "processing {$fil}..."
    sed -i.bak 's/LDFLAGS\s*+=\s*-Wl\s$/#&/' $fil
done

if [ -n "$1" ]; then popd; fi
