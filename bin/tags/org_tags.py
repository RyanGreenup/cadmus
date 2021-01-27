#!/usr/bin/env python3

## This doesn't work yet, the problem is at line 21, it identifies a lot of crap
## as tags if there are ~:~ characters in the heading.
import os
import re
import glob
import sys
import subprocess

# Set Working Directory
try:
    os.chdir(sys.argv[1])
    # os.chdir((os.getenv('HOME')))
    # os.chdir('Notes/Org/')
except:
    print("Exiting; Unable to Access Directory " + str(sys.argv[1]))

ripgrep_command = ['rg', '--vimgrep', '-t', 'org', r"^\*+\s.*\s+:.+:"]
grep_results = subprocess.run(ripgrep_command, stdout=subprocess.PIPE).stdout.decode('utf-8')

# TODO  Identifies any `:` in a heading as tag seperator, I can't extract
# org-mode tags until I fix this
grep_results = str(grep_results).split('\n')



# Match org-mode files
def printOrgFiles(dir):
    os.chdir(dir)
    files = os.listdir()
    orgFiles = []
    for file in files:
        pattern = re.compile('.+\.org$')
        if re.match(pattern, file) and not re.match(pattern, file):
            orgFiles.append(file)



# Search for Tags in org-files

lines = {
    'filename': [],
    'lineNumber': [],
    'title': [],
    'tags': []
}

for line in grep_results:
    line_list = str(line).split(':')
    try:
        lines['filename'].append(line_list[0])
        lines['lineNumber'].append(line_list[1])
        lines['title'].append(line_list[3]) # 2 is column number, we just want first
        lines['tags'].append(list(line_list[4:-1])) # make sure that a single tag is still a list for consistency
    except:
        pass
        # print('missing value, skip line')
# print('---')
# print(lines)

# Print the filename, tag and line number

for i in range(len(lines['lineNumber'])):
    try:
        filename = lines['filename'][i]
        lineNumber = lines['lineNumber'][i]
        tags = lines['tags'][i]
#        print(filename + ',' + lineNumber + ',' + str(tags))
        print("tmsu tag '" + filename + "' " + str(tags).replace('[', '').replace(']',''))
    except:
        pass
        # Do nothing in exception for clean STDOUT
