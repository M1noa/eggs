#!/bin/ash
# AdGuard Home Installation Script
#
# Server Files: /mnt/server

cd /mnt/server

echo "Starting AdGuard Home installation..."

# Get latest version URL
LATEST_RELEASE=$(curl -sSL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep -o 'https://.*_linux_amd64.tar.gz')
echo "Latest release URL: ${LATEST_RELEASE}"

# Download and extract in one command
echo "Downloading and extracting AdGuard Home..."
curl -L ${LATEST_RELEASE} | tar -xz --strip-components=1

# Ensure the binary is executable
chmod +x AdGuardHome

# Create work directory
echo "Creating work directory..."
mkdir -p work
chmod 777 work

# Create configuration file
echo "Creating configuration file..."
cat > AdGuardHome.yaml <<EOL
bind_host: 0.0.0.0
bind_port: {{server.build.default.port}}
auth_name: ${ADMIN_USERNAME}
auth_pass: ${ADMIN_PASSWORD}
users: []
dns:
  bind_hosts:
    - 0.0.0.0
  port: ${DNS_PORT}
  protection_enabled: true
  filtering_enabled: true
  safebrowsing_enabled: ${SAFE_BROWSING}
  parental_enabled: false
  safesearch_enabled: false
  querylog_enabled: true
  ratelimit: 20
  refuse_any: true
  bootstrap_dns:
    - 1.1.1.1
    - 1.0.0.1
  upstream_dns:
    - https://dns.cloudflare.com/dns-query
    - https://dns.google/dns-query
tls:
  enabled: false
filters:
  - enabled: true
    url: https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
    name: AdGuard DNS filter
    id: 1
whitelist_filters: []
user_rules: []
dhcp:
  enabled: false
EOL

chmod 777 AdGuardHome.yaml

echo "-----------------------------------------"
echo "Installation completed successfully"
echo "Files in /mnt/server:"
ls -la
echo "-----------------------------------------"