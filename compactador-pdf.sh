#!/bin/bash

diretory=$1
backup=$2

sudo find "$diretory" -type f -iname "*.pdf" | while read -r file
do
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dBATCH -dQUIET -sOutputFile="$file.pdf" "$file"

	uncompressedFileSize=$(wc -c <"$file")
	compressedFileSize=$(wc -c <"$file.pdf")

	if [ $uncompressedFileSize -le $compressedFileSize ]; then
		rm "$file.pdf"
	else

    filePath=$(echo ${file%/*})
    backupPath="$backup/${filePath#$diretory}"

	  if [ -d "$backupPath/"]; then
      mv "$file" "$backupPath"
    else
      mkdir -p "$backupPath"
      mv "$file" "$backupPath"
    fi

		mv "$file.pdf" "$file"
	fi
done
