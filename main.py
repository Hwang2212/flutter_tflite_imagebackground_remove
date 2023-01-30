

import argparse
import json
import sys
import os

from rembg import remove
from PIL import ImageGrab, Image

CMD_SYS_VERSION = 0
CMD_REMOVE_BACKGROUND = 1
# CMD_OCR_CLIPBOARD = 20


def run(command):
    if command["cmd"] == CMD_SYS_VERSION:
        return {
            "sys.version": sys.version,
        }

    elif command["cmd"] == CMD_REMOVE_BACKGROUND:
        filePath = command["path"]
        current_directory = os.getcwd()
        print(current_directory)

        return{"ded":current_directory}
    else:
        return {"error": "Unknown command."}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--uuid")
    args = parser.parse_args()
    stream_start = f"`S`T`R`E`A`M`{args.uuid}`S`T`A`R`T`"
    stream_end = f"`S`T`R`E`A`M`{args.uuid}`E`N`D`"
    while True:
        cmd = input()
        cmd = json.loads(cmd)
        try:
            result = run(cmd)
        except Exception as e:
            result = {"exception": e.__str__()}
        result = json.dumps(result)
        print(stream_start + result + stream_end)