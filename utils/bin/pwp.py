#!/usr/bin/env python3

import argparse
import getpass
import math
import shutil
import sys
import time

try:
    import pyperclip
except ImportError:
    pyperclip = None


def get_args():
    parser = argparse.ArgumentParser(description="")

    # input sources
    parser.add_argument("-c", "--clipboard", action="store_true", help="If set, get the input text from the clipboard.")
    parser.add_argument("-w", "--clipboard-wait", action="store_true", help="If set, get the input text from the clipboard, but only after it changed its value.")
    parser.add_argument("-a", "--arg", action="store_true", help="If set, use the supplied command line argument as input text.")
    parser.add_argument("-i", "--interactive", action="store_true", help="If set, interactively read the input text from the command line.")

    # only for input source: arg via command line
    parser.add_argument("-s", "--show-interactive", action="store_true", help="If set, do not hide the entered text when reading it interactively.")
    parser.add_argument("text", nargs="?", help="Text to split. Will only be used if '-a'/'--arg' is set.")

    # output options
    parser.add_argument("-o", "--output-width", default=None, type=int, help="Width of the output, in characters. If not specified, use the terminal width.")
    parser.add_argument("-f", "--format", choices=["numbers_above", "simple"], default="numbers_above", type=str, help="How to format the output.")

    parser.add_argument("-d", "--debug", action="store_true", help="Show details and in case of errors, show full stack trace.")

    args = parser.parse_args()
    return args


def chunkify(x, size):
    """
    http://stackoverflow.com/a/312464/1913780
    """
    for n_from in range(0, len(x), size):
        yield x[n_from:(n_from + size)]


def get_input_source(args) -> str:
    # determine the source of the input text
    source_count = int(args.clipboard) + int(args.clipboard_wait) + int(args.interactive) + int(args.arg)

    # will be one of "clipboard", "clipboard_wait", "interactive", or "arg"
    source = None

    # no source specified -> define default behavior
    if source_count == 0:
        if pyperclip is not None:
            # if pyperclip is installed, use clipboard
            source = "clipboard"
        else:
            # otherwise, get text interactively from the terminal
            source = "interactive"

    # exactly one source specified: ok
    elif source_count == 1:
        if args.clipboard:
            source = "clipboard"
        if args.clipboard_wait:
            source = "clipboard_wait"
        elif args.interactive:
            source = "interactive"
        elif args.arg:
            source = "arg"

    # too many sources specified -> error
    else:
        raise ValueError("Multiple sources were specified, you must use exactly one of '-c', '-w', 'i', or '-a'")

    return source


def get_input_text(args) -> str:
    input_source = get_input_source(args=args)
    if args.debug:
        print(f"Debug: using input source '{input_source}'")

    if input_source in ("clipboard", "clipboard_wait"):
        if pyperclip is None:
            raise ImportError("Module 'pyperclip' is not installed. Install with 'pip3 install pyperclip'.")
        if input_source == "clipboard":
            return pyperclip.paste()
        else:
            print("Waiting for clipboard to change...")
            current_clipboard = pyperclip.paste()
            while True:
                new_clipboard = pyperclip.paste()
                if new_clipboard != current_clipboard:
                    return new_clipboard
                time.sleep(0.1)

    elif input_source == "interactive":
        prompt = "Enter input text: "
        if args.show_interactive:
            return input(prompt)
        else:
            return getpass.getpass(prompt)

    elif input_source == "arg":
        if args.text is None:
            raise ValueError("Expected input text via command line argument, but none was given")
        else:
            return args.text


def get_formatted_text(input_text, args):
    # determine output width
    width = args.output_width
    if width is None:
        width = max(1, shutil.get_terminal_size()[0] - 1)
    if args.debug:
        print(f"Debug: output width: {width}")

    func_name = f"format_{args.format}"
    try:
        func = globals()[func_name]
    except KeyError:
        raise NotImplementedError(f"Format '{args.format}' is not implemented")

    return func(input_text=input_text, width=width)


def format_simple(input_text, width):
    # split text
    chunks = tuple(chunkify(x=input_text, size=4))

    lines = []
    current_line = ""
    chunks_on_line = 0
    for chunk in chunks:
        if (chunks_on_line > 0) and ((len(current_line) + 1 + len(chunk)) > width):
            # line break
            lines.append(current_line)
            current_line = ""
            chunks_on_line = 0

        if chunks_on_line == 0:
            current_line = chunk
            chunks_on_line = 1
        else:
            current_line += f" {chunk}"
            chunks_on_line += 1

    if chunks_on_line > 0:
        lines.append(current_line)

    return "\n".join(lines)


def format_numbers_above(input_text, width):
    # params
    characters_per_chunk = 4
    chunk_sep = "  "

    # split text
    chunks = tuple(chunkify(x=input_text, size=characters_per_chunk))
    chunk_count = len(chunks)

    chunks_per_line = max(1, math.floor(((width - 13) + len(chunk_sep)) / (characters_per_chunk + len(chunk_sep))))
    line_count = math.ceil(chunk_count / chunks_per_line)

    lines_upper = []
    lines_lower = []

    for n_line in range(line_count):
        current_line_upper = ""
        current_line_lower = ""

        for n_chunk in range(n_line * chunks_per_line, (n_line + 1) * chunks_per_line):
            if n_chunk >= chunk_count:
                # all chunks done, finished
                break
            chunk = chunks[n_chunk]

            if len(current_line_lower) > 0:
                # add separator, but not for the first chunk on a line
                current_line_upper += chunk_sep
                current_line_lower += chunk_sep

            # text for the upper line
            chunk_text_upper = "_" * len(chunk)
            character_str = str(n_chunk * characters_per_chunk + 1)
            if len(character_str) < len(chunk_text_upper):
                chunk_text_upper = character_str + chunk_text_upper[len(character_str):]

            current_line_upper += chunk_text_upper
            current_line_lower += chunk

        lines_upper.append(current_line_upper)
        lines_lower.append(current_line_lower)

    # interweave upper and lower lines
    text = ""
    for (n_line, (line_upper, line_lower)) in enumerate(zip(lines_upper, lines_lower)):
        line_prefix = f"  {n_line * chunks_per_line * characters_per_chunk + 1: >4d}-{min(len(input_text), (n_line + 1) * chunks_per_line * characters_per_chunk): <4d}  "

        text += "\n"
        text += " " * len(line_prefix) + line_upper + "\n"
        text += line_prefix + line_lower + "\n"

    return text


def main(args):
    input_text = get_input_text(args=args)
    if args.debug:
        print(f"Debug: input text length: {len(input_text)}")
    if len(input_text) == 0:
        raise ValueError("Error: input text is empty")

    output_text = get_formatted_text(input_text=input_text, args=args)
    print(output_text)


if __name__ == "__main__":
    args_ = get_args()
    try:
        main(args=args_)
    except KeyboardInterrupt:
        print("Aborted by user")
        sys.exit(1)
    except Exception as e:
        if args_.debug:
            raise
        else:
            print(e)
            sys.exit(1)
