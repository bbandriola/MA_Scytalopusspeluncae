#!/bin/bash

file_list="$1"
output="$2"  # Remove the spaces around the equal sign

# Initialize an associative array to hold common identifiers
declare -A common_ids

# First, loop through the file list and extract the identifiers from the first file
first_file=$(head -n 1 "$file_list")
awk '{print $1}' "$first_file" > "$output"

# Loop over the rest of the files and filter out identifiers that are not common
while read file; do
  awk '{print $1}' "$file" > tmp_identifiers.txt
  grep -F -f tmp_identifiers.txt "$output" > "$output.tmp"  # Store intermediate result in a temp file
  mv "$output.tmp" "$output"  # Move the temporary file to the actual output file
done < <(tail -n +2 "$file_list")

# Now that we have the common identifiers, filter the lines in all files
while read identifier; do
  # Loop through each file and print the lines containing the common identifier
  while read file; do
    awk -v id="$identifier" '$1 == id {print $0}' "$file"
  done < "$file_list"
done < "$output"
