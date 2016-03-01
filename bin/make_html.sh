#!/bin/bash
PWD=`pwd`
cd `dirname $0`/../doc
PROJECT=$1
NAME=`basename $PROJECT`

pandoc -s -S --toc -c ./css/bootstrap.css $PROJECT/*.md -o ../html/$NAME.html --template pandoc-template.html5 --toc-depth=5 --self-contained

pandoc ../html/$NAME.html -o ../html/$NAME.pdf

# for file in `ls -1 *.md`; do
#      NAME=`basename $file|sed -e 's/\.md$//'`
#      pandoc -s -S --toc -c ./css/bootstrap.css "$file" -o ../html/$NAME.html --template pandoc-template.html5 --toc-depth=5 --self-contained
#      # pandoc -r markdown_github -s -S --toc "$file" -o ../html/$NAME.html --toc-depth=5 --self-contained
# done
# cd $PWD
