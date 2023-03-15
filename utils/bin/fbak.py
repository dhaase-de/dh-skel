#!/usr/bin/env python3

import argparse
import pathlib
import shutil
import sys


def get_args():
    parser = argparse.ArgumentParser(description="Copy a given file to a filename with '.bak000' added (or '.bak001', if it exists, etc.)")
    parser.add_argument("filename", help="File to be backed up")
    parser.add_argument("-d", "--debug", action="store_true", help="Show full stack trace for errors")
    parser.add_argument("-s", "--simulate", action="store_true", help="Just show what would be done and exit")
    args = parser.parse_args()
    return args


def main(args):
    file_path = pathlib.Path(args.filename)
    
    # find existing backup files
    bak_paths_existing = sorted(file_path.parent.glob(file_path.name + ".bak[0-9][0-9][0-9]"))

    # determine next backup ID
    if len(bak_paths_existing) == 0:
        bak_max_id = -1
    else:
        bak_max_id = int(str(bak_paths_existing[-1])[-3:])

    # copy file to backup name
    bak_path = pathlib.Path(str(file_path) + f".bak{bak_max_id + 1:03d}")
    assert not bak_path.exists()
    if not args.simulate:
        shutil.copy2(file_path, bak_path)
        print(f"Copied file '{file_path}' to '{bak_path}'")
    else:
        print(f"Would now copy file '{file_path}' to '{bak_path}' (but skipped, due to '--simulate')")
        

if __name__ == "__main__":
    args = get_args()
    try:
        main(args=args)
    except Exception as e:
        print("ERROR: {} ({})".format(e, type(e).__name__))
        if args.debug:
            raise e
        else:
            sys.exit(1)

