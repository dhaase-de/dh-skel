#!/usr/bin/env python3

import argparse
import pathlib
import shutil
import sys


def bytes_to_human_str(b: int) -> str:
    prefixes = ["", "k", "M", "G", "T"]
    prefix_count = len(prefixes)
    n_prefix = 0
    while (b >= 1024.0) and (n_prefix + 1 < prefix_count):
        b /= 1024.0
        n_prefix += 1

    return f"{b:.2f} {prefixes[n_prefix]}B"


def get_args():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("source_paths", metavar="source_path", nargs="+", type=str, help="Path(s) which should be copied recursively.")
    parser.add_argument("-t", "--target-base-path", type=str, default="/dev/shm", help="Target base path.")
    parser.add_argument("-d", "--debug", action="store_true", help="Display full stack trace on error.")
    args = parser.parse_args()
    return args


def main(args):
    source_paths = tuple(pathlib.Path(path) for path in args.source_paths)
    target_base_path = pathlib.Path(args.target_base_path)

    if not target_base_path.exists():
        raise FileNotFoundError(f"Target base path '{target_base_path}' does not exist")

    print(f"Scanning for files...")
    paths_to_copy = []
    for source_path in source_paths:
        if source_path.is_file():
            paths_to_copy.append(source_path)
        else:
            for path in source_path.glob("**/*"):
                if path.is_file():
                    paths_to_copy.append(path)
    size_to_copy = sum(path.stat().st_size for path in paths_to_copy)
    print(f"Found {len(paths_to_copy)} file(s) ({bytes_to_human_str(size_to_copy)}) to copy")

    print("Copying files...")
    size_copied = 0
    for (n_path, path) in enumerate(paths_to_copy):
        source_path = path.absolute()
        source_filename = str(source_path)
        assert source_filename.startswith("/")
       
        target_path = target_base_path.joinpath(source_filename[1:])
        target_path.parent.mkdir(parents=True, exist_ok=True)

        shutil.copy2(source_path, target_path)
        size_copied += source_path.stat().st_size
        print(f"[{n_path + 1}/{len(paths_to_copy)}]  [{bytes_to_human_str(size_copied)} / {bytes_to_human_str(size_to_copy)}]  {target_path}")


if __name__ == "__main__":
    args = get_args()
    try:
        main(args=args)
    except Exception as e:
        if args.debug:
            raise e
        else:
            print("ERROR: {} ({})".format(e, type(e).__name__))
            sys.exit(1)
