#!/bin/bash

# Parse command line arguments.
if [ ${#@} -ne 3 ]; then
    echo "Usage: $0 <USERS-FILE> <INPUT-DIR> <OUTPUT-DIR>"
    echo
    echo "  <USERS-FILE> CVS file for the list of users."
    echo "  <INPUT-DIR>  Directory generated by \"assign-texts.sh\" script."
    echo "  <OUTPUT-DIR> Output directory."
    exit 1
fi
USERS_FILE=$1
INP_DIR=$2
OUT_DIR=$3

# Function to extract a particular column from a CSV file line.
csv_get_column() {
    echo "$1" | awk -F "," "{print \$$2}"
}

# Get current directory.
CUR_DIR=$(pwd)

# Parse users.
cat "$USERS_FILE" | while read LINE; do
    # Extract CSV columns.
    USER_ID=$(csv_get_column "$LINE" 1)

    # Make ZIP directory
    mkdir -p "$OUT_DIR/$USER_ID"

    # Copy TXT files.
    cp "$INP_DIR/$USER_ID"/*.txt "$OUT_DIR/$USER_ID/"

    # Copy README file.
    cp mail-readme.html "$OUT_DIR/$USER_ID"/README.html

    # Create ZIP file.
    cd "$OUT_DIR/$USER_ID"
    zip -9 ../"ses_kayit_$USER_ID.zip" *
    cd "$CUR_DIR"
done
