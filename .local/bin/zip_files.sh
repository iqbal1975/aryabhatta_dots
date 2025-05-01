#!/usr/bin/env bash

dir="$1"
timestamp=$(date "+%Y%m%d_%H%M%S")
dirname=$(basename "$dir")
zipfile="${dirname}_${timestamp}.zip"
zip -r "$zipfile" "$dir"
