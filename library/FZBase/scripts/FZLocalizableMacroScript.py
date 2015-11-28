#!/usr/bin/python

# Description:  A script which will generate a Macros header file repersenting all of the entries in your Localizable.strings file.
#
# Setup:
# 1. Copy this to your top level project directory
# 2. In the build phase for your project add a "Run Script" phase and add the following line minus the quotes  'python ${PROJECT_DIR}/FZLocalizableMacroScript.py'. in Xode 5 add it to your 'pre-actions' in your scheme.
# 3. If you want to move the file to any other directory, just change the build path specified in step 2 to point to that directory
# 4. Add FZLocalizableStringsMacros.h to your project
# 5. Needs to be added for each target
# Note: The script will run anytime you update the localizable strings file(for any language).  Sometimes you will get a compile error that the file ran before the precompiler, ignore this and build again.

import os, datetime, sys, time

def get_macro_line(line):
	end_char = line.find("\"", 1)
	string = line[1:end_char]
	macro = "#define {0} NSLocalizedString(@\"{0}\", @\"{0}\")\n".format(string)
	return macro

def make_macros_from_lines(lines):
	macro_lines = []
	for line in lines:
		if len(line) > 0:
			if line[0] == "\"":
				macro_lines.append(get_macro_line(line))
	return macro_lines
	
def make_macro_file_with_macros(macros):
	os.chdir("..")
	with open('FZLocalizableStringsMacros.h', "w") as macros_file:
		macros_file.writelines(macros)

def main():
	#The macros file will be the same for all languages. its just a mapping to the localizable strings file, which will be different for different locales
	os.chdir(os.environ['SRCROOT'])
	os.chdir('en.lproj')

	stringsFileModifiedDate = os.path.getmtime('Localizable.strings')
	if os.path.isdir('../FZLocalizableStringsMacros.h'):
		macrosFileModifiedDate = os.path.getmtime('../FZLocalizableStringsMacros.h')
	else:
		macrosFileModifiedDate = 0
	
	print "StringDate:, MacroDate:", stringsFileModifiedDate, macrosFileModifiedDate

	if stringsFileModifiedDate > macrosFileModifiedDate:
		print "Updating the macros File."
		with open('Localizable.strings') as strings_file:
			lines = [line.rstrip("\n") for line in strings_file]
			macro_lines = make_macros_from_lines(lines)

			if len(macro_lines):
				comment_string = "//\n// ../FZLocalizableStringsMacros.h\n// Fuzz Productions \n//\n\n"
				macro_lines.insert(0, comment_string)
				make_macro_file_with_macros(macro_lines)
			else:
				print "Cannot complete operation"
	else:
		print "Macros file is up to date.  StringDate:, MacroDate:", stringsFileModifiedDate, macrosFileModifiedDate
		
main()