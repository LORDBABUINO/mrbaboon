#!/bin/bash

diretory=$1
mkdir $diretory/../backup-files

sudo find $diretory -type f -iname *.pdf | while read -r file
do
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dBATCH -dQUIET -sOutputFile="$file.pdf" "$file"

	uncompressedFileSize=$(wc -c <"$file")
	compressedFileSize=$(wc -c <"$file.pdf")

	if [ $uncompressedFileSize -le $compressedFileSize ]; then
		rm "$file.pdf"
	else
		mv "$file" "$diretory/../backup-files"
		mv "$file.pdf" "$file"
	fi
done
