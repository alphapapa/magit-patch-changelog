#!/bin/sh -ex

EMACS="${EMACS:=emacs}"
BASENAME=$(basename "$1")

( cask emacs -Q --batch \
           --visit "$1" \
           --eval "(checkdoc-eval-current-buffer)" \
           --eval "(princ (with-current-buffer checkdoc-diagnostic-buffer \
                                               (buffer-string)))" \
           2>&1 | egrep -a "^$BASENAME:" ) && false

!( cask emacs -Q --batch \
           -l package-lint \
           --eval "(package-initialize)" \
           --eval "(push (quote (\"melpa\" . \"http://melpa.org/packages/\")) \
                         package-archives)" \
           --eval "(package-refresh-contents)" \
           -f package-lint-batch-and-exit "$1" 2>&1 | egrep -a "^$BASENAME:" | egrep -v "Emacs" | grep "." )
