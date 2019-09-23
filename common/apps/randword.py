#! /usr/bin/python

from random import randint
import sys

###############################################################################
#																	  Constants
###############################################################################

# Define ratio of words without a tailing consonant, to ones with
TAIL_CONST_RATIO = 5

# Define ratio of words without double letter, to double letters
DOUBLE_LETTER_RATIO = 5

# Define the minimum and maximum pairs in each word
MIN_NUM_PAIRS = 3
MAX_NUM_PAIRS = 4

# Define list of vowels and consonants
# --- Vowels
VOWEL_LIST = 	["a", "e", "i", "o", "u"]
# --- Consonants
CONSONANT_LIST = ["b", "c", "d", "f", "g", 
				  "h", "j", "k", "l", "m", 
				  "n", "p", "q", "r", "s", 
				  "t", "v", "w", "y", "z"]

# Define the max index of each list
MAX_CONST_IDX = len(CONSONANT_LIST) - 1
MAX_VOWEL_IDX = len(VOWEL_LIST) - 1

###############################################################################
#																	  Functions
###############################################################################

def randWord(numPairs):
	# Initialize the word to empty string
	word = ""

	hasDblLetters = False;
	
	# Loop, and create pairs of Consonants and Vowels
	for pair in range(0, numPairs):
		
		# --- Choose the consonant
		consonant = CONSONANT_LIST[randint(0, MAX_CONST_IDX)]
		
		# --- Apply adjustments based on choosen consonant
		if(consonant == "q"):
			vowel = "u"
		else:
			vowel = VOWEL_LIST[randint(0, MAX_VOWEL_IDX)]
	
		if(	(not hasDblLetters) and 
			(not (pair == numPairs - 1)) and 
			(not (pair == 0)) and
			(randint(1, DOUBLE_LETTER_RATIO) == 1)):

			if(	consonant == "l" or 
				consonant == "m" or
				consonant == "r" or
				consonant == "s" or
				consonant == "t"):
				consonant += consonant
				hasDblLetters = True;

		# --- Create word with Consonant, Vowel pair
		word += consonant + vowel

	# Add tail consonant
	if(randint(1, TAIL_CONST_RATIO) == 1):
		word += CONSONANT_LIST[randint(0, MAX_CONST_IDX)]

	return word
# End randWord

###############################################################################
#																		   Body
###############################################################################

# Check if there are enough arguments
if(len(sys.argv) < 2):
	print 'ERROR: Not enough arguments'
	print 'Usage: randWord.py <Number of Words to Generate>'
	sys.exit(1)

# Grab number of words to generate from command line arg
numWords = int(sys.argv[1])

for _ in range(0, numWords):
	# Choose the number of pairs
	numPairs = randint(MIN_NUM_PAIRS, MAX_NUM_PAIRS)

	# Print out the created word
	print randWord(numPairs)
