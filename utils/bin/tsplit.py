#!/usr/bin/env python3

import argparse
import getpass
import math
import sys


def get_args():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("text", nargs="?", help="Text to split. If not specified, will be read interactively.")
    parser.add_argument("-c", "--characters-per-chunk", default=4, type=int, help="Number of characters per chunk.")
    parser.add_argument("-i", "--show-input", action="store_true", help="If set, do not hide the entered text when reading it interactively.")
    parser.add_argument("-l", "--chunks-per-line", default=4, type=int, help="Number of chunks per line.")
    parser.add_argument("-s", "--chunk-sep", default=" ", type=str, help="Separator between chunks.")
    args = parser.parse_args()
    return args 


def chunks(x, size):
    """
    http://stackoverflow.com/a/312464/1913780
    """
    for n_from in range(0, len(x), size):
        yield x[n_from:(n_from + size)]


def main():
    args = get_args()

    # settings
    characters_per_chunk = args.characters_per_chunk
    chunks_per_line = args.chunks_per_line
    chunk_sep = args.chunk_sep

    # get text to split
    text = args.text
    if text is None:
        prompt = "Enter text to split: "
        if args.show_input:
            text = input(prompt)
        else:
            text = getpass.getpass(prompt)
    if len(text) == 0:
        print("Warning: text is empty, stopped")
        sys.exit(1)

    # split text
    cs = list(chunks(text, characters_per_chunk))
    chunk_count = len(cs)
    line_count = math.ceil(chunk_count / chunks_per_line)
    character_count = len(text)
    character_count_length = math.ceil(math.log10(character_count))
    character_count_format = "{:>" + str(character_count_length) + "d}"

    # print splits
    for n_line in range(line_count):
        print((character_count_format + "-" + character_count_format + ":  {}").format(
            n_line * chunks_per_line * characters_per_chunk + 1,
            min(character_count, (n_line + 1) * chunks_per_line * characters_per_chunk),
            chunk_sep.join(str(c) for c in cs[(n_line * chunks_per_line):((n_line + 1) * chunks_per_line)])
        ))


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Aborted")
        sys.exit(1)

