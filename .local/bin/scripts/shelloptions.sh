#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=eN4_nmREzCQ

# copy this to your .bashrc or something like that

# shelloptions
# combine output of "bind -V", "set -o" and "shopt", thereby showing all shell
# options in one place. Display nicely with color and column alignment.
#
# Sample output:
# bind-V:bind-tty-special-chars  on
# bind-V:blink-matching-paren    off
# ...
# set-o:allexport                off
# set-o:braceexpand              on
# ...
# shopt:cdable_vars              off
# shopt:cdspell                  off
# ...
function shelloptions() {
	command awk '
    BEGIN {
      green = "\033[32m";
      red = "\033[31m";
      cyan = "\033[96m";
      reset = "\033[0m";
      prefixes[1] = "bind-V:";
      prefixes[2] = "set-o:";
      prefixes[3] = "shopt:";
    }
    FNR == 1 {
      prefixIndex++;
    }
    {
      prefix=prefixes[prefixIndex];
      $0 = cyan prefix reset $0;
      $NF = gensub(/^.?(on).?$/, green "\\1" reset, "g", $NF);
      $NF = gensub(/^.?(off).?$/, red "\\1" reset, "g", $NF);
      if (substr($NF, 1, 1) == "`") {
        $NF = substr($NF, 2, length($NF) - 2);
      }
      print $1 "\t" $NF;
    }' <(builtin bind -V) <(builtin set -o) <(builtin shopt) | column -t
}
