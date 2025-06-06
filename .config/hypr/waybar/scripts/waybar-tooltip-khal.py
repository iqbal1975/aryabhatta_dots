#!/usr/bin/env python

import datetime
import json
import locale
import subprocess
from html import escape
import itertools
import re

months = ['Jan', 'Feb', 'Apr', 'Mar', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
max_len = 64
cal_sep_len = 2
cal_indent_line = 24
time_len = 12
schedule_max_len = max_len - cal_indent_line
cal_indent_line += cal_sep_len

data = {}

today = datetime.date.today().strftime("%Y-%m-%d")

next_week = (datetime.date.today() +
             datetime.timedelta(days=8)).strftime("%Y-%m-%d")

cal_output = subprocess.check_output("khal calendar now "+next_week, shell=True)
cal_output = cal_output.decode("utf-8")
output = subprocess.check_output("khal list now "+next_week, shell=True)
output = output.decode("utf-8")

#print(next_week)

cal_lines = []
lines = cal_output.split("\n")
month_counter = 0
for line in lines:
    if month_counter >= 4:
        break
    if line[:3] in months:
        month_counter += 1
        clean_line = escape(line).split("     ")[0]
    else:
        try:
            clean_line = re.match("^[ \t]+(?P<days>.*?)   .*?", line).groupdict()["days"]
        except AttributeError:
            continue
        else:
            if len(clean_line) == 0:
                clean_line=""
            elif clean_line[1] == " ":
                clean_line = "     " + clean_line
            else:
                clean_line = "    " + clean_line
    if 'Mo Tu We' in clean_line:
        clean_line = "\n<b>"+clean_line+"</b>"
    cal_lines.append(clean_line)

new_lines = []
lines = output.split("\n")
for line in lines:
    if re.match("^[a-zA-Z]*?, [0-9]*?-[0-9]*?-[0-9]*?$", line):
        new_lines.append("<b>"+line+"</b>")
    elif re.match("^[0-9]{2}:[0-9]{2}-[0-9]{2}:[0-9]{2}.*?$", line):
        if " ::" in line:
            line = escape(line).split(" ::")[0]
        if len(line) > schedule_max_len:
            new_lines.append(line[:schedule_max_len])
            rest = line[schedule_max_len:]
            chunks = [rest[i:i+schedule_max_len-time_len] for i in range(0, len(rest), schedule_max_len-time_len)]
            chunks = [" "*time_len + chunk.strip() for chunk in chunks]
            new_lines.extend(chunks)
        else:
            new_lines.append(line)
# print(new_lines)

out_lines = []
cal_sep = " " * cal_sep_len
cal_indent = " " * cal_indent_line
for cal_line, new_line in itertools.zip_longest(cal_lines, new_lines):
    #print(cal_line, new_line, len(new_line))
    if not new_line:
        new_line = ""
    if cal_line:
        out_line = f"{cal_line}{cal_sep}{new_line}"
    else:
        out_line = f"{cal_indent}{new_line}"
    out_lines.append(out_line)
output = "\n".join(out_lines).strip()

locale.setlocale(locale.LC_TIME, "en_US.UTF-8")
mytime = datetime.datetime.now().strftime("%H:%M")
mydate = datetime.datetime.now().strftime("%a %b %d")

# if today in output:
#     # data['text'] = f"{mydate}  {mytime}"
#     data['text'] = f" {mydate}"
# else:
#     # data['text'] = f"{mydate}  {mytime}"
#     data['text'] = f" {mydate}"

if today in output:
    data["text"] = ""
else:
    data["text"] = ""

data["tooltip"] = output

print(json.dumps(data))
