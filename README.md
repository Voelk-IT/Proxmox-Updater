![Logo](https://proxmox.com/images/proxmox/Proxmox_logo_standard_hex_400px.png)

# Proxmox Updater

Dieses Werkzeug ermöglicht eine Automatiesierung der Updates für die Nodes & LXC Container.
Das System Updatet Debian & Ubuntu Systeme


## Einrichtung & Installation

Schritt für Schritt ans Ziel.

```bash
  mkdir /root/Voelk-IT/
  mkdir /root/Voelk-IT/Proxmox
  nano /root/Voelk-IT/Proxmox/updater.bash // Code einfügen gegebenenfalls anpassen.
  chmod +x /root/Voelk-IT/Proxmox/updater.bash
  /root/Voelk-IT/Proxmox/updater.bash // Test ob das Script auch geht.
  crontab -e
  0 0 * * 0 /bin/bash /root/Voelk-IT/Proxmox/updater.bash // dies lässt das Script 1x die Woche laufen.
```

## Manuelle Updates

```bash
/root/Voelk-IT/Proxmox/updater.bash
```

## Entwikler

- [@Aydin Völk](https://github.com/Voelk-IT)
