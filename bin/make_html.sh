#!/bin/bash
PWD=`pwd`
cd `dirname $0`/../doc

for file in `ls -1 *.md`; do
     NAME=`basename $file|sed -e 's/\.md$//'`
     pandoc -s -S --toc -c ./css/bootstrap.css $file -o ../html/$NAME.html --template pandoc-template.html5 --toc-depth=5 --self-contained
done
cd $PWD
