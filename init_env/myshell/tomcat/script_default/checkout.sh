#!/bin/sh

source context/Config/server1/config.sh

echo '---set param and init---'
_codePath="$CONTEXT/App/$DOMAIN/code/"

echo '---delete and check out codes---'
if [[ -e $_codePath ]]
then
	rm -r $_codePath
fi

mkdir -p $_codePath

if [ -n "$SVN_username" -a -n "$SVN_password" ]
	svn co --username $SVN_username --password $SVN_password $SVN_url $_codePath
else
	svn co $SVN_url $_codePath
fi

echo '------------------------------------'
echo
echo
echo 'source code checkout finished! the path is '$SVN_PATH
echo
echo
echo '------------------------------------'
