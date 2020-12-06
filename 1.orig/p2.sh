#!/bin/bash

cat input | xargs -I% sed -e 's/$/ %/' input | xargs -I% sed -e 's/$/ %/' input | awk '{if($1 + $2 + $3 == 2020){print $1 * $2 * $3}}'
