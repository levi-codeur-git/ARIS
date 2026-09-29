#!/bin/bash

REPORT_DIR="/opt/aris/reports"

# Conservation des 20 derniers rapports de chaque type
for prefix in audit health; do
    ls -1t "$REPORT_DIR"/${prefix}_*.txt 2>/dev/null |
        tail -n +21 |
        xargs -r rm -f
done

exit 0
