#!/bin/bash

BACKUP_DIR="/opt/aris/backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/aris_backup_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

if tar -czf "$BACKUP_FILE" /opt/aris/scripts /opt/aris/reports 2>/dev/null; then
    echo "Sauvegarde créée : $BACKUP_FILE"
else
    echo "ERREUR : échec de la sauvegarde"
    rm -f "$BACKUP_FILE"
    exit 1
fi

# Conservation des 5 dernières sauvegardes
ls -1t "$BACKUP_DIR"/aris_backup_*.tar.gz 2>/dev/null |
    tail -n +6 |
    xargs -r rm -f

echo "Rétention : 5 dernières sauvegardes conservées"
exit 0
