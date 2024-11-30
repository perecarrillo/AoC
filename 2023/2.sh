#!/bin/bash

sum=0

# 2.in has to end with a newline character
file="2.in"

while IFS= read -r line; do
    echo $line
    array=($line)
    id=(${array[1]::-1})
    games=$(echo "${array[@]:2}" | tr ";" "\n")

    red=0
    green=0
    blue=0

    for game in "$games"; do
        game=$(echo "$game" | tr " " "_")
        cubes=$(echo "$game" | tr "," "\n")
        # echo -e "cubes: $cubes"

        for cube in $cubes; do
            # echo -e "this cube contains $cube \n"
            sp=($(echo "$cube" | tr "_" " "))
            # echo -e "cube 0: ${sp[0]}"
            # echo -e "cube 1: ${sp[1]}"

            if [ "${sp[1]}" == "red" ] && [ $red -lt "${sp[0]}" ]; then
                red="${sp[0]}"
            elif [ "${sp[1]}" == "green" ] && [ $green -lt "${sp[0]}" ]; then
                green="${sp[0]}"
            elif [ "${sp[1]}" == "blue" ] && [ $blue -lt "${sp[0]}" ]; then
                blue="${sp[0]}"
            fi
        done
    
    # echo -e "sum: $sum"
    # echo -e "game number: $id"
    # echo -e "max red: $red"
    # echo -e "max green: $green"
    # echo -e "max blue: $blue \n"

    # Part one
    # if [ $red -le "12" ] && [ $green -le "13" ] && [ $blue -le "14" ]; then
    #     sum=$(($sum + $id))
    # fi

    # Part two
    pow=$(($red*$green*$blue))
    sum=$(($sum + $pow))


    done
done < $file

echo -e "Result: $sum"