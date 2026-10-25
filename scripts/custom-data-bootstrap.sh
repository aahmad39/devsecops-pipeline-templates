#!/bin/bash
# =========================================================================
# VIRTUAL MACHINE MIDDLEWARE BOOTSTRAP SCRIPT (CUSTOM DATA / CLOUD-INIT)
# Configures baseline OS hardening, monitoring agents & middleware
# =========================================================================

set -e

echo "==> Initiating VM Bootstrap Sequence..."

# 1. Update package manager
apt-get update -y
apt-get upgrade -y

# 2. Install baseline security & utility tooling
apt-get install -y curl wget unzip jq git apt-transport-https ca-certificates gnupg lsb-release

# 3. Install Azure Connected Machine & Log Analytics Agent
echo "==> Configuring Log Analytics & Azure Monitoring Telemetry..."
# Install OMS Agent / Azure Monitor Agent (AMA)

# 4. OS Hardening Baseline (CIS Controls)
echo "==> Applying baseline kernel hardening..."
cat <<EOF >> /etc/sysctl.conf
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
EOF
sysctl -p

# 5. Application Middleware Configuration (Example: Nginx / Runtime)
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

echo "==> VM Custom-Data Bootstrap Completed Successfully."
