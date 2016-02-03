#! /usr/bin/python

# importing listdir from os command
from os import listdir

# importing isfile and splitext from os.path
# this is used to filter out only files
from os.path import isfile, splitext

# import regular expression lib
import re

# import sys for command line arguments
import sys

# set the searchPath of the script
searchPath = "."

# sort out all files from the directory.
files = [f for f in listdir(searchPath) if(isfile(f))]

# remove all files that are not .c or.cpp files
	# define search parameters in regex
cfiles = re.compile('.*c$|.*cpp$')

	# remove all non cfiles
files = [f for f in files if(re.match(cfiles, f)) ]

# find the file containing the main function
	# define regex for main function as " main ("
main = re.compile('.* *main *\(')

	# default value for mainFile
	# used if the file containing the main function is not found
mainFile = "Main file not found"

	# look for main function in files
for f in files:
	for i, line in enumerate(open(f)):
		# checks file for the main function
		if(re.match(main, line)):
			# if found, set mainFile to f
			mainFile = f

	# remove mainfril from the file list
files.remove(mainFile)

# set executable name
if len(sys.argv) > 1:
	# if command line arg exists, use that as name
	exeName = sys.argv[1]
else:
	# otherwise, use mainfile's name
	exeName, junk = splitext(mainFile)



# write makefile
	# open makefile for writing
outfile = open("Makefile", "w")

	# erase it if it already exists
outfile.truncate();

	# write the compiler options
outfile.write("CC=gcc\n")
outfile.write("CPC=g++\n")
outfile.write("\n")

outfile.write("CFLAGS=-g -Wall -Wextra -std=c++11 -pthread -lrt -Wl,--no-as-needed\n")
outfile.write("\n")

objFiles = []

	# write dependency aliases
for f in files:
	srcName = f;
	baseName, junk = splitext(f)
	headerName = baseName + ".h"
	objFiles.append(baseName + ".o") 
	if isfile(headerName):
		outfile.write( baseName.upper() + "=" + srcName + " " + headerName + "\n")
	else:
		outfile.write( baseName.upper() + "=" + srcName + "\n")
outfile.write("\n")

	# create regex to sort out C from C++ files
cppFile = re.compile('.*cpp$')

	# Write out main File compile line
outfile.write(exeName + ": " + " ".join(objFiles) + " \n")

	# if the mainFile is a C++ file, use g++ else use gcc
if re.match(cppFile, mainFile):
	outfile.write("	$(CPC) $(CFLAGS) " + mainFile + " " + " ".join(objFiles) + " -o " + exeName + "\n")
else:
	outfile.write("	$(CC) $(CFLAGS) " + mainFile + " " + " ".join(objFiles) + " -o " + exeName + "\n")

outfile.write("\n")

includeFile = re.compile('^ *#include "')

	# write out compile lines for dependencies
for f in files:
	baseName, junk = splitext(f)
	dependencies = []
	totDeps = []	
	for i, line in enumerate(open(f)):
		# checks file for the main function
		if(re.match(includeFile, line)):
			depBaseName = re.search('^ *#include "(.*)\.h".*', line)
			dependencies.append(depBaseName.group(1))
	
	for d in dependencies:
		totDeps.append("$(" + d.upper() + ")")

		for i, line in enumerate(open(d + ".h")):
			# checks file for the main function
			if(re.match(includeFile, line)):
				depBaseName = re.search('^ *#include "(.*)\.h".*', line)
				totDeps.append("$(" + depBaseName.group(1).upper() + ")")
	
	outfile.write( baseName + ".o: " + " ".join(totDeps) + "\n")
	# if the mainFile is a C++ file, use g++ else use gcc
	if re.match(cppFile, mainFile):
		outfile.write("	$(CPC) $(CFLAGS) -c " + baseName + ".cpp  -o " + baseName + ".o \n")
	else:
		outfile.write("	$(CC) $(CFLAGS) -c " + baseName + ".c  -o " + baseName + ".o \n")
	outfile.write("\n")

outfile.write("\n")

	# write the clean function
outfile.write("clean:\n")
outfile.write("	rm *.o &> /dev/null; rm " + exeName + " &> /dev/null\n")

