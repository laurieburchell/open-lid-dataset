"""Preprocesses text prior to language identification. 
    Assume language is unknown, does not apply sentence segmentation or tokenization.
    Script removes social-media specific features (emojis, hashtags, mentions, URLs), normalizes punctuation, and removes non-printing characters.

    input: raw text data, one input per line, to be processed for classification
    output: preprocessed text data, one input per line, ready for language identification
    author: laurie

"""

import argparse
from sacremoses import MosesPunctNormalizer
from unicodedata import normalize as unicode_normalize
from tools.demojizer import Demojizer
from tools.remove_non_printing_char import get_replacer 
from tools.defines import Patterns

## might need these for running on cluster
# import sys
# import os
# SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
# sys.path.append(os.path.dirname(SCRIPT_DIR))

demojiser = Demojizer()

class Cleaner:
    """Cleans test set sentences for language identification"""
    def __init__(self):
        self.mpn = MosesPunctNormalizer(lang='en')  # assumes English since no lang label
        self.replace_nonprinting = get_replacer(" ")

    def __call__(self, file):
        """Iterate through file, cleaning each line. May leave empty string"""
        for line in file:
            clean = line.strip()
            clean = self.mpn.normalize(clean)
            clean = self.replace_nonprinting(clean)
            clean = unicode_normalize("NFKC", clean)
            clean = demojiser(clean, "")
            # twitter-specific preprocessing: urls, @mentions, reserved words
            clean = Patterns.URL_PATTERN.sub("", clean)
            clean = Patterns.MENTION_PATTERN.sub("", clean)
            clean = Patterns.RESERVED_WORDS_PATTERN.sub("", clean)
            yield (line, clean)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("input_file", type=str, help="path to input file to process")
    parser.add_argument("output_file", type=str, help="full path to where to write output")

    return parser.parse_args()

def main():
    """Run preprocessing (especially for tweets) prior to classification on LID test files."""
    args = parse_args()  # contains input_file and output_file

    empty_count = 0

    with open(args.input_file, 'r') as infile:
        with open(args.output_file, 'w') as outfile:
            cleaner = Cleaner()
            for sent, clean in cleaner(infile):
                if len(clean)<1:
                    empty_count+=1
                outfile.write(f"{clean}\n")
    
    print(f"Finished cleaning file. Wrote {empty_count} empty lines.")
            

if __name__ == "__main__":
    main()