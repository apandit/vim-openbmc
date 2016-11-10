#!/bin/sh

# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
