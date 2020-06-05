#!/usr/bin/env bash
set -e
set -u

script_pwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
project_root=$( cd "$( dirname "${script_pwd}" )" && pwd )

# Requies gnu sed and csplit: 
# `brew install gnu-sed coreutils` (coreutils contains gnu csplit)

# binaries
gnuSed=/usr/local/opt/gnu-sed/libexec/gnubin/sed
pdf2txt=/usr/local/bin/pdftotext

# input
downloadFile=$HOME/Downloads/Notes_from_How_Emotions_Are_Made_The_Secret_Life_of_the_Brain_by_Lisa_Feldman_Barrett.pdf

# output
workspace=/tmp/workspace
tmpOutputFile="$workspace"/output.txt
regExMatchDir="$workspace"/regExMatch
outputFile="$HOME"/Downloads/ibook-notes.txt
# workspaceFiles=`/usr/bin/find $workspace -iname "*.txt" -type f`

_clean() {
	rm -rfv $workspace
	rm -rfv $outputFile
}

_create() {
	/bin/mkdir -p -v "$regExMatchDir"
    /usr/bin/touch "$tmpOutputFile"
}

_pdf2txt() {
    $pdf2txt $downloadFile $tmpOutputFile
}

# _createImportFile() {
#     local regEx='^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)'
#     while read LINE; do
#         # remove double quotes from $regEx
#         if [[ $LINE =~ $regEx ]]; then 
#             echo "FOUND U: $LINE"
#         else 
#             echo "NOT FOUND." 
#         fi
#     done < "$tmpOutputFile"
# }

_splitTxtFile() {
    # split by month of the year
    local gCsplit=/usr/local/opt/coreutils/libexec/gnubin/csplit
    local regEx='^Jan.*\|^Feb.*\|^Mar.*\|^Apr.*\|May.*\|Jun.*\|Jul.*\|Aug.*\|Sep.*\|Oct.*\|Nov.*\|Dec.*'
    cd $regExMatchDir && "$gCsplit" --prefix="Note" --suffix-format="%02d.txt" "$tmpOutputFile" /"$regEx"/ "{*}"
}

_createFiles() {
    echo "$workspaceFiles"
	# set -l workspaceFiles (find $workspace -iname "*.txt" -type f)
    #
	# for txtFile in $workspaceFiles
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
    # _createImportFile
    # _createFiles

	# echo "Output file is @ $outputFile"
}

main
