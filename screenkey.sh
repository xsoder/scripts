#!/bin/bash

if pgrep -x "screenkey" > /dev/null; then
    pkill screenkey
else
     screenkey -p fixed -g 30%x4%-10%+10%
fi

