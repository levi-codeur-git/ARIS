# Phase 3 — Administration Linux / VMware

## Objectif
Introduire une infrastructure serveur Linux virtualisée et acquérir les bases nécessaires à son administration.

## Réalisation
`SERVER-01` utilise Ubuntu Server 24.04.5 LTS sous VMware Workstation Pro. Il dispose de deux interfaces : `ens33` sur le réseau NAT/administration (`192.168.63.128/24`) et `ens37` sur le réseau laboratoire VMnet1 (`192.168.99.20/24`).

`CLIENT-01-VM` est utilisé comme poste client pour les tests et l'administration.

La phase couvre notamment le hostname, les utilisateurs et groupes, les permissions, SSH, systemd, les processus, les ressources et les journaux Linux.

## Résultat
L'environnement Linux virtualisé est opérationnel et sert de base aux services, à la supervision, à la sécurité et à l'automatisation.
