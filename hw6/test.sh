#! /bin/bash
. bashcalc-function.sh

echo $(bashcalc "3 + 2") '  ==  ' 5


echo $(sine 3) '  ==   ' $(python -c "import math, sys; sys.stdout.write(str(math.sin(3)))")

echo $(cosine 3) '  ==   ' $(python -c "import math, sys; sys.stdout.write(str(math.cos(3)))")

echo $(angle_reduce 12) '  ==   ' $(python -c "import angles, sys; sys.stdout.write(str(angles.r2r(12)))")


if float_lt 3.13 4.13; then
    echo float_lt passed;
fi

if $(float_lte 3.13 3.13); then
    echo float_lte passed;
fi

if $(float_eq 3.13 3.13); then
    echo float_eq passed;
fi