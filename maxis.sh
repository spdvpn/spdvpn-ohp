#!/bin/bash
# Program: OHPServer For Maxis
# Date: 03-08-2021
# Last Update: 07-08-2021

# installing wget and unzip
if [[ -e /usr/bin/unzip && /usr/bin/wget  ]]; then
echo -e "wget and unzip already install"
sleep 3;clear
else
echo -e "installing wget and unzip"
sleep 3;clear
apt install wget unzip
fi

# installing ohpserver
if [[ -e /usr/bin/ohpserver  ]]; then
echo -e "ohpserver already install"
sleep 3;clear
else
echo -e "installing ohpserver"
sleep 3;clear
wget https://raw.githubusercontent.com/givps/open-http-puncher/main/ohpserver-linux32.zip
unzip ohpserver-linux32.zip
rm *.zip
mv ohpserver /usr/bin/
chmod +x /usr/bin/ohpserver
fi

# adding maxis for ohpserver
if [[ -e /usr/bin/maxis  ]]; then
echo -e "maxis for ohpserver exist but will be update"
sleep 3;clear
rm /usr/bin/maxis
cat> /usr/bin/maxis << END
#!/bin/bash
screen -dmS tls ohpserver -port 9087 -proxy 127.0.0.1:9999 -tunnel 127.0.0.1:443
screen -dmS non ohpserver -port 9088 -proxy 127.0.0.1:9999 -tunnel 127.0.0.1:1194
screen -dmS openssh ohpserver -port 9085 -proxy 127.0.0.1:9999 -tunnel 127.0.0.1:22
screen -dmS dropbear ohpserver -port 9086 -proxy 127.0.0.1:9999 -tunnel 127.0.0.1:109
END
chmod +x /usr/bin/maxis
else
echo -e "adding maxis for ohpserver"
sleep 3;clear
cat> /usr/bin/maxis << END
#!/bin/bash
screen -dmS tls ohpserver -port 9087 -proxy 127.0.0.1:9999 -tunnel 127.0.0.1:443
screen -dmS non ohpserver -port 9088 -proxy 127.0.0.1:9999 -tunnel 127.0.0.1:1194
screen -dmS openssh ohpserver -port 9085 -proxy 127.0.0.1:9999 -tunnel 127.0.0.1:22
screen -dmS dropbear ohpserver -port 9086 -proxy 127.0.0.1:9999 -tunnel 127.0.0.1:109
END
chmod +x /usr/bin/maxis
fi

# adding maxis service for running
if [[ -e /etc/systemd/system/maxis.service  ]]; then
echo -e "maxis service already adding"
sleep 3;clear
else
echo -e "adding maxis service for running"
sleep 3;clear
cat> /etc/systemd/system/maxis.service << END
[Unit]
Description=OHP MAXIS

[Service]
Type=forking
ExecStart=/usr/bin/maxis

[Install]
WantedBy=multi-user.target
END
systemctl daemon-reload
systemctl enable maxis
fi

if [[ -e /root/log-ohp.txt  ]]; then
rm /root/log-ohp.txt
echo -e "Installation has been completed!!"
echo ""
echo ""
echo "Openvpn TLS : 9087" | tee -a log-ohp.txt
echo "Openvpn Non : 9088" | tee -a log-ohp.txt
echo "OpenSSH : 9085" | tee -a log-ohp.txt
echo "Dropbear : 9086" | tee -a log-ohp.txt
echo ""
echo ""
read -n 1 -r -s -p $'Press any key to reboot...\n';reboot
else
echo -e "Installation has been completed!!"
echo ""
echo ""
echo "Openvpn TLS : 9087" | tee -a log-ohp.txt
echo "Openvpn Non : 9088" | tee -a log-ohp.txt
echo "OpenSSH : 9085" | tee -a log-ohp.txt
echo "Dropbear : 9086" | tee -a log-ohp.txt
echo ""
echo ""
read -n 1 -r -s -p $'Press any key to reboot...\n';reboot
fi