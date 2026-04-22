#!/bin/bash

# Remove all markdown files in the current directory
rm -r *.md

# Create a new README.md file with a title
echo "# SkillVerse" > README.md

# Find all directories (excluding hidden ones) and store them in LIST
LIST=$(find -mindepth 1 -maxdepth 1 -type d ! -name ".*" | sed "s/.*\///g")
for i in ${LIST} ; do
    # Add each directory as a section in README.md
    if [[ ${i} != ___* ]]; then
      echo "  - ### [$(echo ${i} | sed -e 's/_/ /g')](${i}.md)" >> README.md
    fi
    # Create a new markdown file for each directory with a title
    echo "# $(echo ${i} | sed -e 's/_/ /g')" > ${i}.md

    # Find all chapter markdown files in the directory and rename them temporarily
    LIST1=$(find ${i} -mindepth 1 -maxdepth 1 -type f -name "chapter_*.md")
    for j in ${LIST1} ; do
        TMP_NAME=$(echo ${j} | sed "s/chapter_/temp_chapter_/g")
        mv ${j} ${TMP_NAME}
    done

    # Rename the temporary chapter files back to their original names with zero-padded numbers
    count=1
    LIST2=$(find ${i} -mindepth 1 -maxdepth 1 -type f -name "temp_chapter_*.md")
    for j in ${LIST2} ; do
        FINAL_NAME=$(echo ${j} | sed "s/temp_chapter_.*\./chapter_$(printf "%05d." ${count})/g")
        mv ${j} ${FINAL_NAME}
        count=$((count + 1))
    done

    # Add each chapter file as a section in the directory's markdown file
    LIST3=$(find ${i} -mindepth 1 -maxdepth 1 -type f -name "chapter_*.md")
    for j in ${LIST3} ; do
        TITLE=$(cat ${j} | grep -m 1 "^# " | sed "s/^# //g" | sed "s/:.*//g")
        echo "## $(echo "${j}" | sed "s/.*chapter_0*//g" | sed "s/\..*//g"). [$(echo ${TITLE} | sed -e 's/_/ /g')](${j})" >> ${i}.md
        cat ${j} | grep "^## " | sed "s/^## /  - /g" | sed "s/:.*//g" | sed "s/\*//g" | sed "s/#//g"  | sed "s/\`//g" >> ${i}.md
    done

done

# Find all markdown files and update copyright information
list=$(find -type f -name "*.md")

for file in ${list} ; do
  # Check if the file already contains a copyright notice
  if grep -Eq "Copyright \(c\) [0-9]{4} ChipVerge" $file ; then
    # Update the existing copyright notice with the current year
    sed -i "s/.*Copyright (c) [0-9]\{4\} ChipVerge.*/##### Copyright (c) $(date +%Y) ChipVerge/g" $file
  else
    # Add a new copyright notice if not present
    echo "" >> $file
    echo "##### Copyright (c) $(date +%Y) ChipVerge" >> $file
    echo "" >> $file
  fi
done
