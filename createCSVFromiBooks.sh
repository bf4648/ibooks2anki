#!/usr/bin/env bash

# Requies gnu sed and csplit: 
# `brew install gnu-sed coreutils` (coreutils contains gnu csplit)

# binaries
csplit=/usr/local/opt/coreutils/libexec/gnubin/csplit
gnuSed=/usr/local/opt/gnu-sed/libexec/gnubin/sed
pdf2txt=/usr/local/bin/pdftotext

# input
downloadFile=$HOME/Downloads/Notes_from_How_Emotions_Are_Made_The_Secret_Life_of_the_Brain_by_Lisa_Feldman_Barrett.pdf

# output
tmpOutputDir=/tmp/notes
tmpOutputFile="$tmpOutputDir"/output.txt
outputFile="$HOME"/Downloads/ibook-notes.txt
tmpOutputDirFiles=`/usr/bin/find $tmpOutputDir -iname "*.txt" -type f`

_clean() {
	rm -rfv $tmpOutputDir
	rm -rfv $outputFile
}

_create() {
	/bin/mkdir -p -v $tmpOutputDir
    /usr/bin/touch "$tmpOutputFile"
}

_pdf2txt() {
    $pdf2txt $downloadFile $tmpOutputFile
}

_splitTxtFile() {
	/bin/sh -c "cd $tmpOutputDir && $csplit --quiet --prefix='Note' --suffix-format='%02d.txt' "$tmpOutputFile" '/^May/' '{*}'"
}

_createFiles() {
    echo "$tmpOutputDirFiles"
	# set -l tmpOutputDirFiles (find $tmpOutputDir -iname "*.txt" -type f)
    #
	# for txtFile in $tmpOutputDirFiles
	# 	$gnuSed -i '/^$/d' $txtFile
	# 	set -l date (cat $txtFile | head -n 1)
	# 	set -l front (cat $txtFile | head -n 3 | tail -n 1)
    #     echo $font
	# 	set -l back 'back'
    #
	# 	# format tag chapter
	# 	set -l unformattedTagChapter (cat $txtFile | head -n 2 | tail -n 1)
	# 	set -l removeColonInTagChapter (echo $unformattedTagChapter | tr -d ':')
	# 	set -l replaceSpaceWithDashInTagChapter (echo $removeColonInTagChapter | tr ' ' '-')
	# 	set -l lowerCaseTagChapter (echo $replaceSpaceWithDashInTagChapter | tr [:upper:] [:lower:])
    #
	# 	# format tag title
	# 	set -l replaceSpaceWithDashInBookTitle (echo $bookTitle | tr ' ' '-')
	# 	set -l lowerCaseTagBookTitle (echo $replaceSpaceWithDashInBookTitle | tr [:upper:] [:lower:])
    #
	# 	# set tags
	# 	set -l tags (echo $lowerCaseTagBookTitle $lowerCaseTagChapter)
    #
	# 	# output
	# 	echo -e "$front\t$back\t$tags $lowerTitle" >> $outputFile
	# end
}

main() {
    _clean
    _create
    _pdf2txt
    _splitTxtFile
    _createFiles

	echo "Output file is @ $outputFile"
}

main
