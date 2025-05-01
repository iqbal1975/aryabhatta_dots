#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=lSOVozD7Iio

### Add this to your .bashrc

export LESS="--RAW-CONTROL-CHARS --quit-if-one-screen --clear-screen --tilde"

# version of less that scrolls
alias less="less --chop-long-lines --status-column --rscroll='>'"
alias l="less"

# version of less that wraps lines
alias lesswrap="command less"
alias lw="lesswrap"

### Add this to your .config/lesskey

#command
h left-scroll
l right-scroll
j forw-scroll
k back-scroll
