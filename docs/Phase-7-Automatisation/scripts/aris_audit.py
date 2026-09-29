#!/usr/bin/env python3

import subprocess
import socket
from datetime import datetime


SERVICES = [
    "ssh",
    "nginx",
    "named",
    "smbd",
    "fail2ban",
    "netdata"
]


def run_command(command):
    result = subprocess.run(
        command,
        capture_output=True,
        text=True
    )
    return result.stdout.strip()


def get_hostname():
    return socket.gethostname()


def get_uptime():
    return run_command(["uptime", "-p"])


def get_memory():
    memory = {}

    with open("/proc/meminfo", "r") as file:
        for line in file:
            key, value = line.split(":", 1)
            memory[key] = int(value.strip().split()[0])

    total_gb = memory["MemTotal"] / (1024 ** 2)
    available_gb = memory["MemAvailable"] / (1024 ** 2)

    percentage = (available_gb / total_gb) * 100

    return total_gb, available_gb, percentage


def get_disk():
    result = run_command(
        ["df", "/", "--output=pcent"]
    )

    percentage = result.splitlines()[1].strip().replace("%", "")

    return int(percentage)


def check_service(service):
    result = subprocess.run(
        ["systemctl", "is-active", "--quiet", service]
    )

    return result.returncode == 0


def evaluate_disk(usage):
    if usage >= 90:
        return "CRITICAL"
    elif usage >= 80:
        return "WARNING"
    else:
        return "OK"


def evaluate_memory(available):
    if available < 10:
        return "CRITICAL"
    elif available < 20:
        return "WARNING"
    else:
        return "OK"


def save_report(content):
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    report_path = f"/opt/aris/reports/audit_{timestamp}.txt"

    with open(report_path, "w") as report:
        report.write(content)

    return report_path


def main():

    status = 0
    output = []

    output.append("===== ARIS SYSTEM AUDITOR v3 =====")
    output.append(f"Hostname : {get_hostname()}")
    output.append(f"Date     : {datetime.now()}")
    output.append(f"Uptime   : {get_uptime()}")

    output.append("\n===== MEMOIRE =====")

    total, available, percentage = get_memory()
    memory_status = evaluate_memory(percentage)

    output.append(f"Total système       : {total:.2f} GB")
    output.append(f"Mémoire disponible  : {available:.2f} GB")
    output.append(f"Disponible          : {percentage:.0f}%")
    output.append(f"Statut              : {memory_status}")

    if memory_status == "WARNING":
        status = max(status, 1)
    elif memory_status == "CRITICAL":
        status = 2

    output.append("\n===== DISQUE =====")

    disk = get_disk()
    disk_status = evaluate_disk(disk)

    output.append(f"Disque utilisé      : {disk}%")
    output.append(f"Statut              : {disk_status}")

    if disk_status == "WARNING":
        status = max(status, 1)
    elif disk_status == "CRITICAL":
        status = 2

    output.append("\n===== SERVICES ARIS =====")

    for service in SERVICES:
        if check_service(service):
            output.append(f"[OK] {service}")
        else:
            output.append(f"[CRITICAL] {service}")
            status = 2

    output.append("\n===== RESULTAT GLOBAL =====")

    if status == 0:
        output.append("STATUS: OK")
    elif status == 1:
        output.append("STATUS: WARNING")
    else:
        output.append("STATUS: CRITICAL")

    output.append(f"Code de sortie : {status}")

    report = "\n".join(output)

    print(report)

    report_path = save_report(report)

    print(f"\nRapport généré : {report_path}")

    return status


if __name__ == "__main__":
    exit(main())
