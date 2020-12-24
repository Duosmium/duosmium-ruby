import yaml, sys, re, os, git
from datetime import datetime

fil_list = []

uncommit_list = []

repo_root = os.path.dirname(os.path.dirname(sys.argv[0]))

directory = repo_root + '/data'

repo = git.Git(repo_root)

for fil in os.listdir(directory):
    if fil[0:2] in ['19', '20']:
        abs_path = directory + '/' + fil
        output = repo.log('--format=%ai', '--reverse', '--', abs_path)
        first_commit = output.split('\n')[0]
        if first_commit == '':
            uncommit_list.append((fil, 0))
        else:
            fil_list.append((fil, datetime.strptime(first_commit, '%Y-%m-%d %H:%M:%S %z')))
uncommit_list.sort(key=lambda x: x[0], reverse=True)
fil_list.sort(key=lambda x: x[1], reverse=True)
full_list = uncommit_list + fil_list

with open(directory + '/recents.yaml', 'w') as outfil:
    outfil.write('''# To update this file, run 'recents-update.py' in the 'scripts' directory.
---
''')
    yaml.dump([i[0] for i in full_list], outfil)
