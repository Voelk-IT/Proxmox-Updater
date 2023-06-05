#!/bin/bash
# Update LXC Debian & Ubuntu Container
# Bash Script auf dem Proxmox Host einrichten
# Version: 1.1.5

# Einstellungen:
# Hier sind die Einstellungen für den Updater
COMPANY="Voelk-IT"        # Hier wird der Firmen Namen eingetragen
HOST="PVE-01"             # Hostname des Proxmox
IP="10.0.1.1"             # IP der Proxmox Hosts
ADMIN="mail@admin.de"     # Die E-Mail Adresse des Admins
AUTOREBOOT="OFF"          # Hier kann mit ON / OFF eingestellt werden das er nach dem Updaten den Host Neustartet

LOGFILE="/var/log/updater.log"

# Liste der Container-IDs 
containers=$(pct list | tail -n +2 | cut -f1 -d' ')

function update_container() {
  container=$1
  echo -e "\033[36m[Voelk-IT]\033[0m\033[33m[INFO]\033[0m Aktualisierung von $container..."
  # Hier wird der Bash Befehl an den Container gesendet das dies dann ausführt
  if pct exec $container -- bash -c "apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y && apt autoremove -y"; then
    echo -e "\033[36m[Voelk-IT]\033[0m\033[33m[INFO]\033[0m $container erfolgreich aktualisiert."
  else
    echo -e "\033[36m[Voelk-IT]\033[0m\033[31m[FEHLER]\033[0m Fehler beim Aktualisieren von $container."
    send_error_email
  fi
}

function send_error_email() {
  echo -e "Subject: [Voelk-IT][PROXMOX][ERROR] $COMPANY - $HOST - $IP\n\nFehler beim Aktualisieren des Systems" | sendmail $ADMIN
}

echo -e "\033[36m[Voelk-IT]\033[0m\033[33m[Update]\033[0m Update Proxmox Host" | tee -a $LOGFILE
if apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y && apt autoremove -y; then
  echo -e "\033[36m[Voelk-IT]\033[0m\033[33m[INFO]\033[0m Proxmox Host erfolgreich aktualisiert." | tee -a $LOGFILE
  if [ "$AUTOREBOOT" = "ON" ]; then
    echo -e "\033[36m[Voelk-IT]\033[0m\033[33m[INFO]\033[0m Neustart des Hosts wird durchgeführt..." | tee -a $LOGFILE
    reboot
  fi
else
  echo -e "\033[36m[Voelk-IT]\033[0m\033[31m[FEHLER]\033[0m Fehler beim Aktualisieren des Proxmox Hosts." | tee -a $LOGFILE
  send_error_email
fi

echo -e "\033[36m[Voelk-IT]\033[0m\033[33m[Update]\033[0m  Update Container" | tee -a $LOGFILE
for container in $containers
do
  update_container $container | tee -a $LOGFILE
done

echo -e "\033[36m[Voelk-IT]\033[0m\033[33m[Update]\033[0m \033[32mUpdates wurden ausgeführt...\033[0m" | tee -a $LOGFILE

# Send email notification
echo -e "Subject: [Voelk-IT][PROXMOX][UPDATES] $COMPANY - $HOST - $IP\n\nUpdates wurden ausgeführt" | sendmail $ADMIN
