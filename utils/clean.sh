#!/bin/sh

find . -name a.out -execdir rm '{}' \;
find . -name '*.vcd' -execdir rm '{}' \;
find . -name '*.lxt' -execdir rm '{}' \;
find . -name '*.lx2' -execdir rm '{}' \;
find . -name '*~' -execdir rm '{}' \;
find . -name '#*#' -execdir rm '{}' \;
