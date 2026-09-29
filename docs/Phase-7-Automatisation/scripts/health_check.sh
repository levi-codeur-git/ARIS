#!/bin/bash

REPORT="/opt/aris/reports/health_$(date +%Y-%m-%d_%H-%M-%S).txt"

STATUS=0

echo "===== ARIS SYSTEM HEALTH CHECK v2 =====" > "$REPORT"
echo "Hostname : $(hostname)" >> "$REPORT"
echo "Date     : $(date)" >> "$REPORT"
echo "Uptime   : $(uptime -p)" >> "$REPORT"

echo "" >> "$REPORT"
echo "===== DISQUE =====" >> "$REPORT"

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK_USAGE" -ge 90 ]; then
    echo "[CRITICAL] Disque : ${DISK_USAGE}%" >> "$REPORT"
    STATUS=2
elif [ "$DISK_USAGE" -ge 80 ]; then
    echo "[WARNING] Disque : ${DISK_USAGE}%" >> "$REPORT"
    [ "$STATUS" -lt 1 ] && STATUS=1
else
    echo "[OK] Disque : ${DISK_USAGE}%" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "===== MEMOIRE =====" >> "$REPORT"

MEM_AVAILABLE=$(free | awk '/Mem:/ {printf "%.0f", ($7/$2)*100}')

if [ "$MEM_AVAILABLE" -lt 10 ]; then
    echo "[CRITICAL] Mémoire disponible : ${MEM_AVAILABLE}%" >> "$REPORT"
    STATUS=2
elif [ "$MEM_AVAILABLE" -lt 20 ]; then
    echo "[WARNING] Mémoire disponible : ${MEM_AVAILABLE}%" >> "$REPORT"
    [ "$STATUS" -lt 1 ] && STATUS=1
else
    echo "[OK] Mémoire disponible : ${MEM_AVAILABLE}%" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "===== SERVICES ARIS =====" >> "$REPORT"

for service in ssh nginx named smbd fail2ban netdata; do
    if systemctl is-active --quiet "$service"; then
        echo "[OK] $service" >> "$REPORT"
    else
        echo "[CRITICAL] $service est arrêté" >> "$REPORT"
        STATUS=2
    fi
done

echo "" >> "$REPORT"
echo "===== RESEAU =====" >> "$REPORT"
ip -br addr >> "$REPORT"

echo "" >> "$REPORT"
echo "===== RESULTAT GLOBAL =====" >> "$REPORT"

if [ "$STATUS" -eq 0 ]; then
    echo "STATUS: OK" >> "$REPORT"
elif [ "$STATUS" -eq 1 ]; then
    echo "STATUS: WARNING" >> "$REPORT"
else
    echo "STATUS: CRITICAL" >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "===== FIN DU RAPPORT =====" >> "$REPORT"

echo "Rapport genere : $REPORT"
echo "Code de sortie : $STATUS"

exit "$STATUS"
