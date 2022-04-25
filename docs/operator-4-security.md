# Secure your VPS

### Change root password

When you get a VPS with Lixux OS you will be provided with a root password by the VPS provider. Change the root password:

````bash
sudo passwd root
````

### Add a non-root user

For best security practice root should not be default user. Add a non-root user:

````bash
sudo adduser userNameHere
````

### Install Network Time Protocol

To avoid time drift use Network Time Protocol (NTP). First install:

````bash
 sudo apt-get update
````

````bash
 sudo apt-get install ntp ntpdate
````

Stop NTP service and point to NTP server:

````bash
sudo service ntp stop
````

````bash
sudo ntpdate pool.ntp.org
````

Start NTP service and check status:

````bash
sudo service ntp start
````

````bash
sudo systemctl status ntp
````

### Install Htop

It is useful to be able to monitor CPU and memory use on your server. For this purpose install Htop:

````bash
sudo apt install htop
````

### Secure shell (SSH)

It is sensible to use SSH when connection to your server. Most VPS hosting sites have a SSH guide specific to their hosting platform, so you should follow the specifics of your hosting provider's SSH guide.

### Configure your firewall

Disable firewall off, set default to block incoming traffic and allow outgoing:

````bash
sudo ufw disable
````

````bash
sudo ufw default deny incoming
````

````bash
sudo ufw default allow outgoing
````

Allow specific ports for Secure Shell (SSH) and Partisia:

````bash
sudo ufw allow your-SSH-port-number
````

Enable rate limiting on your SSH connection

````bash
sudo ufw limit your-SSH-port-number
````

````bash
sudo ufw allow 9888:9897/tcp
````

Enable logging, start the firewall and check status:

````bash
sudo ufw logging on
````

````bash
sudo ufw enable
````

````bash
sudo ufw status
````
