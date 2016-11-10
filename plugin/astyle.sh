#!/bin/sh

# Some versions of astyle have a bug that adds a newline each time it's run
# To get around it, chomp the output before returning
#

astyle --style=allman --add-brackets \
    --convert-tabs --max-code-length=80 \
    --indent=spaces=4 --indent-classes --indent-switches --indent-labels \
    --indent-preproc-define --min-conditional-indent=0 --pad-oper \
    --pad-header --unpad-paren --break-after-logical \
    --align-pointer=type --align-reference=type \
    $@ | perl -pe 'chomp if eof'
