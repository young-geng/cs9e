#!/bin/bash
# Cat & Mouse Framework
# CS9E - Assignment 4.2
#
# Framework by Jeremy Huddleston <jeremyhu@cs.berkeley.edu>
# $LastChangedDate: 2007-10-11 15:49:54 -0700 (Thu, 11 Oct 2007) $
# $Id: catmouse-fw.sh 88 2007-10-11 22:49:54Z selfpace $

# Source the file containing your calculator functions:
. bashcalc-function.sh

# Additional math functions:

# angle_between <A> <B> <C>
# Returns true (exit code 0) if angle B is between angles A and C and false otherwise
function is_caught {
	local A=$1
	local B=$2
	local C=$3
	local catL=$4

	test $(bashcalc "c($B - $A) > c($C - $A) && c($C - $B) > c($C - $A) && $catL == 1") -eq 1

	# ADD CODE HERE FOR PART 1
}

### Simulation Functions ###
# Variables for the state
RUNNING=0
GIVEUP=1
CAUGHT=2

function updateCatA {
	local catA=$1;
	local catL=$2;
    catA=$(bashcalc "$catA - 1.25 / $catL");
    catA=$(angle_reduce $catA)
    echo $catA;
}

function updateCatL {
	local catL=$1;
    if [ $(bashcalc "$catL < 2") -eq 1 ]; then
        catL=1;
        echo $catL;
        return 0;
    fi;
    catL=$(bashcalc "$catL - 1");
    echo $catL;

}

function updateMouseA {
	local mouseA=$1;
    mouseA=$(bashcalc "$mouseA - 1");
    mouseA=$(angle_reduce "$mouseA");
    echo $mouseA;
}

# does_cat_see_mouse <cat angle> <cat radius> <mouse angle>
#
# Returns true (exit code 0) if the cat can see the mouse, false otherwise.
#
# The cat sees the mouse if
# (cat radius) * cos (cat angle - mouse angle)
# is at least 1.0.
function does_cat_see_mouse {
	local catA=$1
	local catL=$2
	local mouseA=$3
	test $(bashcalc "1 <= $catL * c($catA - $mouseA)") -eq 1 
	# ADD CODE HERE FOR PART 1
}

# next_step <current state> <current step #> <cat angle> <cat radius> <mouse angle> <max steps>
# returns string output similar to the input, but for the next step:
# <state at next step> <next step #> <cat angle> <cat radius> <mouse angle> <max steps>
#
# exit code of this function (return value) should be the state at the next step.  This allows for easy
# integration into a while loop.
function next_step {
	local state=$1
	local -i step=$2
	local old_cat_angle=$3
	local old_cat_radius=$4
	local old_mouse_angle=$5
	local -i max_steps=$6

	local new_cat_angle=${old_cat_angle}
	local new_cat_radius=${old_cat_radius}
	local new_mouse_angle=${old_mouse_angle}

	# First, make sure we are still running
	if (( ${state} != ${RUNNING} )) ; then
		echo ${state} ${step} ${old_cat_angle} ${old_cat_radius} ${old_mouse_angle} ${max_steps}
		return ${state}
	fi

	# ADD CODE HERE FOR PART 2

	# Move the cat first
	if does_cat_see_mouse $old_cat_angle $old_cat_radius $old_mouse_angle; then
		# Move the cat in if it's not at the statue and it can see the mouse
		new_cat_radius=$(updateCatL $old_cat_radius);
	else
		# Move the cat around if it's at the statue or it can't see the mouse
		new_cat_angle=$(updateCatA $old_cat_angle $old_cat_radius);
		# Check if the cat caught the mouse
	fi

	# Now move the mouse if it wasn't caught
	if ! is_caught $old_cat_angle $old_mouse_angle $new_cat_angle $new_cat_radius ; then
		# Move the mouse
		new_mouse_angle=$(updateMouseA $old_mouse_angle);
		# Give up if we're at the last step and haven't caught the mouse
		if [[ $step == $max_steps ]] ; then
			state=$GIVEUP;
		fi
	else
		state=$CAUGHT;
	fi
	step=$(($step+1));

	echo ${state} ${step} ${new_cat_angle} ${new_cat_radius} ${new_mouse_angle} ${max_steps}
	return ${state}
}

### Main Script ###

if [[ ${#} != 4 ]] ; then
	echo "$0: usage" >&2
	echo "$0 <cat angle> <cat radius> <mouse angle> <max steps>" >&2
	exit 1
fi

# ADD CODE HERE FOR PART 3
state=$RUNNING
step=0;
cat_angle=$1;
cat_radius=$2;
mouse_radius=$3;
max_steps=$4;
while [[ $state == $RUNNING ]]; do
	res=$(next_step $state $step $cat_angle $cat_radius $mouse_radius $max_steps);
	state=$(echo $res | cut -d ' ' -f 1);
	step=$(echo $res | cut -d ' ' -f 2);
	cat_angle=$(echo $res | cut -d ' ' -f 3);
	cat_radius=$(echo $res | cut -d ' ' -f 4);
	mouse_radius=$(echo $res | cut -d ' ' -f 5);
	echo "step: $step, cat angle: $cat_angle, cat radius: $cat_radius, mouse_radius: $mouse_radius"
	if [[ $state == $CAUGHT ]]; then
		echo "Mouse caught";
		exit 0;
	elif [[ $state == $GIVEUP ]]; then
		echo "Give up"
		exit 0;
	fi
done


