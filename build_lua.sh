#!/bin/bash
JIT_TYPE=$2
function build_lua
{
echo "$1\n";
luas=`find $1 -name "*.lua"`
for lua_file in $luas;
do
		echo "$1"
	echo "${lua_file}"
	dest_file=`basename ${lua_file}`
	dest_lua=${lua_file}
	if [ x$JIT_TYPE != x ] && [ $JIT_TYPE == "arm64" ]; then
		echo "luajit64 -b ${lua_file} ${dest_lua}"
		`/usr/local/luajitFor64/bin/luajit -b ${lua_file} ${dest_lua}`
		find $1 -name luaScript|xargs -I {} mv {} {}64
	else
		echo "luajit -b ${lua_file} ${dest_lua}"
		`luajit -b ${lua_file} ${dest_lua}`
	fi
done
}
build_lua $1
