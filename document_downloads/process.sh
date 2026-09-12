#!/bin/bash

# Author: Claude
# Contact: ckseet@gmail.com
# Session: https://claude.ai/code/session_01FppH5Xh6paiiGFiLC4oB7z

# Define file extensions to process
EXTENSIONS=("pdf" "mobi" "docx" "txt")

# Replace spaces with underscores for all files
for file in *; do [ -f "$file" ] && mv "$file" "${file// /_}"; done

# Remove parentheses from all files
for file in *; do [ -f "$file" ] && mv "$file" "${file//[()]/}"; done

# Add 99_ prefix to all files
for file in *; do [ -f "$file" ] && mv "$file" "99_$file"; done
