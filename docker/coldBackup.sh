#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

if docker ps | grep -q static_hazmit_db; then
  echo 'This script creates a File System Level Backup (aka cold backup).'
  echo '  It must only be run while the database is shut down.'
  echo 
  echo '  See: https://www.postgresql.org/docs/9.6/backup-file.html'
  exit 1
fi;
 
tar -c pgdata/ | pbzip2 -c -p4 -m100 > "hazmit.docker-pgdata.$(date +%s).tar.bz2"
