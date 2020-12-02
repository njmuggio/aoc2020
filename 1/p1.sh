#!/bin/bash

sort -h input | xargs -I%% awk -v LVAL=%% '{if($0 + LVAL == 2020){print LVAL * $0}}' input
