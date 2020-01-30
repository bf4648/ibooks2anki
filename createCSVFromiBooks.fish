#!/usr/bin/env fish
function ibooksCreateCSVFromClipboard
	# this assumes that you have emailed your iBook notes to your email and have copied all the notes to your clipboard
	set -l bookTitle $argv

	# Requies gnu sed and csplit: `brew install gnu-sed csplit`
	set -l csplit /usr/local/opt/coreutils/libexec/gnubin/csplit
	set -l gnuSed /usr/local/opt/gnu-sed/libexec/gnubin/sed

	# tmp output
	set -l tmpOutputDir /tmp/notes
	set -l tmpOutputFile $tmpOutputDir/output.txt
	set -l outputFile ~/Downloads/ibook-notes.csv

	# clean
	rm -rfv $tmpOutputDir
	rm -rfv $outputFile

	# create
	mkdir -p -v $tmpOutputDir
	pbpaste > $tmpOutputFile

	# csplit
	/bin/sh -c "cd $tmpOutputDir && $csplit --quiet --prefix='Note' --suffix-format='%02d.txt' $tmpOutputFile '/^\$/' '{*}'"
	set -l tmpOutputDirFiles (find $tmpOutputDir -iname "*.txt" -type f)

	for txtFile in $tmpOutputDirFiles
		$gnuSed -i '/^$/d' $txtFile
		set -l date (cat $txtFile | head -n 1)
		set -l front (cat $txtFile | head -n 3 | tail -n 1)
		set -l back 'back'

		# format tag chapter
		set -l unformattedTagChapter (cat $txtFile | head -n 2 | tail -n 1)
		set -l removeColonInTagChapter (echo $unformattedTagChapter | tr -d ':')
		set -l removeDotInTag (echo $removeColonInTagChapter | tr -d '.')
		set -l replaceSpaceWithDashInTagChapter (echo $removeDotInTag | tr ' ' '-')
		set -l lowerCaseTagChapter (echo $replaceSpaceWithDashInTagChapter | tr [:upper:] [:lower:])

		# format tag title
		set -l replaceSpaceWithDashInBookTitle (echo $bookTitle | tr ' ' '-')
		set -l lowerCaseTagBookTitle (echo $replaceSpaceWithDashInBookTitle | tr [:upper:] [:lower:])

		# set tags
		set -l tags (echo $lowerCaseTagBookTitle $lowerCaseTagChapter)
		echo "Tags: $tags"

		# output
		# echo -e "$front\t$back\t$tags $lowerTitle" >> $outputFile
	end

	echo "Output file is @ $outputFile"
end

if test -n "$argv"
	ibooksCreateCSVFromClipboard $argv
else
	echo 'This script needs a title, i.e. ./createCSVFromiBooks.fish "Book Title"'
end
