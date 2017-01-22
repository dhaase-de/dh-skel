#!/usr/bin/python3

import math
import sys


##
## main
##


def chunks(x, size):
    """
    http://stackoverflow.com/a/312464/1913780
    """
    for nFrom in range(0, len(x), size):
        yield x[nFrom:(nFrom + size)]


def main():
    # settings
    charactersPerChunk = 4
    chunksPerLine = 4
    chunkSep = " - "

    #
    text = sys.argv[1]
    cs = list(chunks(text, charactersPerChunk))
    chunkCount = len(cs)
    lineCount = math.ceil(chunkCount / chunksPerLine)
    characterCount = len(text)
    characterCountLength = math.ceil(math.log10(characterCount))
    characterCountFormat = "{:>" + str(characterCountLength) + "d}"

    for nLine in range(lineCount):
        print((characterCountFormat + "-" + characterCountFormat + ":  {}").format(
            nLine * chunksPerLine * charactersPerChunk + 1,
            min(characterCount, (nLine + 1) * chunksPerLine * charactersPerChunk),
            chunkSep.join(str(c) for c in cs[(nLine * chunksPerLine):((nLine + 1) * chunksPerLine)])
        ))


if __name__ == "__main__":
    main()
