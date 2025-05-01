#!/usr/bin/env python3

import json

record_icon="⭕"

data = {
        "text": f"{record_icon} On Air",
        "tooltip": f"Click {record_icon} to stop screen recording"
}

print(json.dumps(data))
