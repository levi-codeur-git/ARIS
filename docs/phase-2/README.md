# Phase 2 — Réseau Cisco / Packet Tracer

## Objectif
Concevoir et valider l'infrastructure réseau d'ARIS dans Cisco Packet Tracer.

## Réalisation
L'infrastructure comprend deux bâtiments, 30 postes, sept VLAN et deux serveurs dans le VLAN 99. Le routage inter-VLAN repose sur Router-on-a-Stick et le DHCP est centralisé sur le serveur `192.168.99.10`.

VLAN : 10 Direction, 20 Finance, 30 RH-Commercial, 40 Info-Support, 50 Management, 60 Production et 99 Serveurs.

La topologie finale utilise des trunks inter-switch et fait transiter le VLAN 60 par la liaison inter-bâtiments jusqu'au routeur, sans liaison directe Routeur → Switch2.

## Validation
Les tests DHCP, les passerelles, la communication avec le serveur et les communications inter-VLAN ont été validés.

## Résultat
La partie réseau simulée d'ARIS est fonctionnelle et constitue la base réseau du projet.
