#!/bin/bash

#database config
HOST="localhost"
MASTER_USER="database_user"
MASTER_PW="database_password"
MASTER_DB="database_name"

# what do you want to backup
BACKUP_TARGET="/path/to/workspace/"

# where the backups are held locally
BACKUP_DIR="/home/angela/backups/directories/"

# vanilla db
SCHEMA_LOCATION="/var/www/html/workspace-snapshots/database.sql"

# database graveyard
DB_BACKUP_DIRECTORY="/home/angela/backups/databases"

# where is the workspace snapshot?
WORKSPACE_SNAPSHOT="/var/www/html/workspace-snapshots/workspace.vanilla/"
#do not edit below this line


SHORT_NAME=$(basename $BACKUP_TARGET)
DATE="`date +%m-%d-%y-%s`"

# backup master
echo "  Backing up the database..."
mysqldump -u"$MASTER_USER" -p"$MASTER_PW" --host="$HOST" "$MASTER_DB" > "$DB_BACKUP_DIRECTORY"/"$MASTER_DB"-"$DATE".sql

# purge the master db
echo "  Purging the database..."
mysqldump -u"$MASTER_USER" -p"$MASTER_PW" --add-drop-table --no-data "$MASTER_DB" | grep ^DROP | mysql -u"$MASTER_USER" -p"$MASTER_PW" "$MASTER_DB"

# import from the waiting sql!
echo "  Importing $(basename $SCHEMA_LOCATION)..."
mysql -u "$MASTER_USER" -p"$MASTER_PW" "$MASTER_DB" < "$SCHEMA_LOCATION"

echo -e "  DATABASE IMPORT COMPLETE!\n\n"

# backup & restore of the dev environment
echo "  Onto workspace backup & restoration..."
echo "  Compressing $BACKUP_TARGET directory..."

cd $(dirname $BACKUP_TARGET)
tar -cjf $SHORT_NAME-$DATE.tar.bz2 $(basename $BACKUP_TARGET)

# send it to the backup directory
mv $SHORT_NAME-$DATE.tar.bz2 $BACKUP_DIR

# remove the old target; but first make sure it exists, cause this is a (potentially) dangerous command..
if [ -d $BACKUP_TARGET ];
then
  rm -rf $BACKUP_TARGET
fi

# restore the workspace snapshot
cp -a $WORKSPACE_SNAPSHOT $BACKUP_TARGET

echo "  DONE!"
