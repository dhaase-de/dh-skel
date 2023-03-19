#!/usr/bin/env python3

import argparse
import configparser
import os
import os.path
import sys

import dh.utils


def get_args():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("-e", "--entry-name", type=str, default="__default__", help="")
    args = parser.parse_args()
    return args


def main():
    args = get_args()
    config_filename = os.path.join(os.path.dirname(__file__), "yubicopy.conf")
    
    config = configparser.ConfigParser()
    config.read(config_filename)

    call_str = "ykman --device='{device}' oath accounts code '{issuer}:{name}' | head -n1 | awk '{{print $(NF)}}' | tr -d '\n' | xsel --input --primary --selectionTimeout 30000".format(
        device=config[args.entry_name]["device"],
        issuer=config[args.entry_name]["issuer"],
        name=config[args.entry_name]["name"],
    )
    print(call_str.split(" | ")[0])
    os.system(call_str)
    print("Done")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print("ERROR: {} ({})".format(e, type(e).__name__))
        sys.exit(1)

