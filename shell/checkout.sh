#!/bin/sh

source ./config.sh

echo '---set param and init---'
SOURCE_PATH="$CONTEXT/App/$DOMAIN_NAME/code/"
SHELL_HOME="$CONTEXT/Shell/$DOMAIN_NAME"

echo '---delete and check out codes---'
rm -r $SOURCE_PATH
mkdir -p $SOURCE_PATH
svn co $SVN_URL $SOURCE_PATH

echo '------------------------------------'
echo
echo
echo 'source code checkout finished! the path is '$SVN_PATH
echo
echo
echo '------------------------------------'
