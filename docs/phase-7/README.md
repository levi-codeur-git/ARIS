# Phase 7 — Automatisation

## Objectif
Automatiser des tâches d'administration récurrentes afin de rendre l'exploitation d'ARIS plus fiable et reproductible.

## Réalisation
Plusieurs scripts ont été intégrés au dépôt :

- `aris_audit.py` : audit de l'environnement ARIS ;
- `health_check.sh` : contrôle de l'état du serveur et des services ;
- `backup.sh` : sauvegarde ;
- `cleanup_reports.sh` : nettoyage des anciens rapports.

Des unités **systemd** et des **timers** permettent d'automatiser les contrôles, audits et sauvegardes.

## Résultat
Les tâches d'exploitation récurrentes sont partiellement automatisées et les scripts sont conservés dans le dépôt Git du projet.
