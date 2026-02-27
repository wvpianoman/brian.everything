# ------------- firewall ---------------
echo -e "\n🛡️ configuring firewall (firewalld)..."
sleep 2

# enable firewalld
if ! systemctl is-active --quiet firewalld; then
    echo "[+] enabling firewalld..."
    sudo systemctl enable --now firewalld
fi

# detect local subnet
interface=$(ip -o -4 route show to default | awk '{print $5}')
subnet=$(ip -o -4 addr show dev "$interface" | awk '{print $4}')
echo "[+] detected subnet: $subnet"
sleep 2

# allow necessary ports
ports_in=(
  "139/tcp" "445/tcp"
  "137/udp" "138/udp"
  "22/tcp"
  "5357/tcp" "5357/udp"
  "3702/udp"
  "5353/udp"
  "427/udp"
  "161/udp" "162/udp"
  "9100/tcp"
  "631/tcp"
  "8080/tcp"
  "5000/tcp"
  "1900/udp"
  "53317/tcp" "53317/udp"
)

for port in "${ports_in[@]}"; do
    sudo firewall-cmd --zone=public --add-port="$port" --permanent
done

# allow subnet (samba discovery)
sudo firewall-cmd --zone=public --add-source="$subnet" --permanent

# reload
echo "[+] reloading firewalld..."
sudo firewall-cmd --reload

# show status
echo "[+] current firewall status:"
sudo firewall-cmd --list-all

echo -e "\n✅ custom full firewalld setup complete!"
echo -e "\n[+]--------------------------------------------------------------[+]"
sleep 3
