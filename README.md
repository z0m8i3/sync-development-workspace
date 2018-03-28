## Bash Script to Sync Development Workspaces ##
This script is useful in environments when you're developing applications and need to frequently refresh the workspace to its original state.

At the command of an alias, this script:
* Compresses the existing workspace directory files and and makes backups of both database and environment
* Purges the existing workspace & empties the database
* Syncs a vanilla workspace and database within seconds, returning you to its original state

### To Install ###
Place the .sh script in your scripts directory, make note of its path.

Make it executable:
```bash
chmod +x workspace-sync.sh
```


Add the alias to your bashrc file (run as the user that will be triggering the command; not necessarily root):
```bash
echo alias wssync=\'~/scripts/workspace-sync.sh\' >> ~/.bashrc
```
(adjust the filepath accordingly)


Refresh the bashrc file without needing to log out:
```bash
. ~/.bashrc
```

Done.

To trigger it, enter `wssync` in your cli.
