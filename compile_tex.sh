#!/bin/sh

SRC="$1"
BASENAME="$(basename $SRC .tex)"
LOGFILE="$BASENAME.log"

pdflatex -shell-escape -interaction=nonstopmode -halt-on-error >/dev/null "$SRC"

if [ $? -ne 0 ] ; then
    ERROR_LINE=$(grep -n -m 1 -E "^! " $LOGFILE | cut -d ":" -f 1)
    LINE_COUNT=$(wc -l $LOGFILE | cut -d " " -f 1)
    tail -n "$(( $LINE_COUNT - $ERROR_LINE + 1 ))" $LOGFILE
    exit 1
fi

find .  -type f -name "$BASENAME*" -not -name "*.tex" -not -name "*.pdf" -delete
