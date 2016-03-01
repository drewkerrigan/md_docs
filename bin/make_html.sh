#!/bin/bash
PWD=`pwd`
cd `dirname $0`/../doc
PROJECT=$1
NAME=`basename $PROJECT`

pandoc -s -S --toc -c ./css/bootstrap.css $PROJECT/*.md -o $PROJECT/$NAME.html --template pandoc-template.html5 --toc-depth=5 --self-contained
