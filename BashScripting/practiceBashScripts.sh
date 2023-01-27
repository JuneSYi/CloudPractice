#!/bin/bash

# practice from https://learnxinyminutes.com/docs/bash/

echo "echo command"
echo "separating echo's with semi-colon"; echo "this echo is on the same line but with a semi-colon after the previous echo"

var="duck"

demo="you can use variables with spaces between the equal signs"
echo "echoing the variable var: ${var}"

echo "${var/duck/hippo}"
l
en=2

echo "${var:0:len}"echo "${var: -2}"
echo ${#var}

extendvar=var
echo "Using ! before the variable will let us extend. here var=duck and we attache dvar to extendvar, echoing !extendvar shows: ${extendvar}"
echo "echoing extendvar without ! will only show extend=var so just var: ${extendvar}"

#setting default values, if foo is assigned a value, it'll show foo, otherwise it'll show the long string
foo="testing foo"
echo $foo
foo=
echo "testing if foo=${foo}"
echo ${foo:-"thisIsTheDefaultStringIfNothingIsAssignedToFoo"}
# can also use null (foo=) and empty string (foo="")

# or we can set the default variable and ALSO assign it to the variable at the same time
echo ${bar:="defaultbarvalue"}

# declaring an array with 6 elements
array=(one two three four five six)
echo "echo "\${array[0]}" shows: ${array[0]}"
echo "echo "\${array[@]}" shows: ${array[@]}"
echo "echo "\${#array[@]}" shows: ${#array[@]}"
echo "echo "\${#array[2]}" shows: ${#array[2]}"
echo "echo "\${array[@]:3:2}" shows: ${array[@]:3:2}"

echo "for item in \${array[@]}; do echo \$item"
for item in ${array[@]}
do
     echo $item
done

# Built-in variables
echo "Last program's return value \$? aka exit status: $?"
echo "Script's PID \$$: $$"
echo "Number of arguments passed to script \$#: $#"
echo "All arguments passed to script \$@: $@"
echo "Script's arguments separated into different variables \$1 \$2: $1 $2..."