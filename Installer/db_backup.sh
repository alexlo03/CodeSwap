#!/bin/sh
now=$(date +%Y%m%d)
name="backup_$now.bak"
/usr/bin/sqlite3 ../src/db/development.sqlite3 .dump > ../src/db/backups/$name
