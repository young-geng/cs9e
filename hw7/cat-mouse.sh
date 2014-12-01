#! /bin/bash



catA=${1:-'0'}
catL=${2:-'10'}
mouseA=${3:-'0'}
. bashcalc-function.sh


function updateCatA {
    catA=$(bashcalc "$catA - 1.25 / $catL");
    catA=$(angle_reduce $catA)
}

function updateCatL {
    if [ $(bashcalc "$catL < 2") -eq 1 ]; then
        catL=1;
        return 0;
    fi;
    catL=$(bashcalc "$catL - 1");

}

function updateMouseA {
    mouseA=$(bashcalc "$mouseA - 1");
    mouseA=$(angle_reduce "$mouseA");
}



function runCat {
    oldCatA=$catA;
    if [ $(bashcalc "1 <= $catL * c($catA - $mouseA)") -eq 1 ]; then
        updateCatL;
    else
        updateCatA;
    fi;
    if [ $(bashcalc "c($mouseA - $oldCatA) > c($catA - $oldCatA) && c($catA - $mouseA) > c($catA - $oldCatA)") -eq 1 ]; then
        return 0;
    fi;
    return 1;
}

function printStep {
    echo "cat angle:  $catA";
    echo "cat radius: $catL";
    echo "mouse angle: $mouseA";
}


for ((minute=1;minute <= 30; minute += 1)); do
    minute=$(($minute + 1));
    echo "minute: $minute";
    if runCat; then
        echo "The cat catches the mouse !!!!!!!!!!";
        printStep;
        break;
    fi
    updateMouseA;
    printStep;
done


