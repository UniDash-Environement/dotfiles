#! /usr/bin/env nix-shell
#! nix-shell -i bash -p wireguard-tool

echo "Setup Wireguard private key [N/y]: "
read WG_KEY

if [[ "${WG_KEY}x" == "Yx" || "${WG_KEY}x" == "yx" ]]; then
  # Create wg key
  for file in config/{SRV,NAS}/{A,B,C}/wireguard/key/{wan,lan,admin}; do
    wg genkey | tee ${file}/privateKey
    cat ${file}/privateKey | wg pubkey | tee ${file}/publickey
  done

  wg genkey | tee ./config/SRV/wireguard/key/failover/privateKey
  cat ./config/SRV/wireguard/key/failover/privateKey | wg pubkey | tee ./config/SRV/wireguard/key/failover/publickey
fi

NEXTCLOUD_DB_PASS="aaa"
REPETE="bbb"
if [ ! -f "/var/lib/nixos-containers/nextcloud/etc/nextcloud/dbpass" ]; then
  while [ "${NEXTCLOUD_DB_PASS}x" != "${REPETE}x" ]; do
    echo "Enter your nextcloud database password: "
    read -s NEXTCLOUD_DB_PASS
    echo "Repete this: "
    read -s REPETE
  done
  sudo mkdir -p /var/lib/nixos-containers/nextcloud/etc/nextcloud/ /etc/nextcloud/
  echo "${NEXTCLOUD_DB_PASS}" | sudo tee /var/lib/nixos-containers/nextcloud/etc/nextcloud/dbpass
else
  NEXTCLOUD_DB_PASS=$(cat "/var/lib/nixos-containers/nextcloud/etc/nextcloud/dbpass")
fi

NEXTCLOUD_PASS="aaa"
REPETE="bbb"
if [ ! -f "/var/lib/nixos-containers/nextcloud/etc/nextcloud/adminpass" ]; then
  while [ "${NEXTCLOUD_PASS}x" != "${REPETE}x" ]; do
    echo "Enter your nextcloud admin password: "
    read -s NEXTCLOUD_PASS
    echo "Repete this: "
    read -s REPETE
  done
  echo "${NEXTCLOUD_PASS}" | sudo tee /var/lib/nixos-containers/nextcloud/etc/nextcloud/adminpass
else
  NEXTCLOUD_PASS=$(cat "/var/lib/nixos-containers/nextcloud/etc/nextcloud/adminpass")
fi

sudo nixos-rebuild switch --upgrade --flake .

if [[ "${WG_KEY}x" == "Yx" || "${WG_KEY}x" == "yx" ]]; then
  sudo mkdir -p /etc/wireguard/failover
  sudo cp -r ./config/$(cat /etc/hostname | cut -d "-" -f 2)/$(cat /etc/hostname | cut -d "-" -f 3)/wireguard/key/* /etc/wireguard/
  sudo rm -f /etc/wireguard/{admin,lan,wan}/publickey
  sudo cp ./config/SRV/wireguard/key/failover/privateKey /etc/wireguard/failover/
fi
sudo mysql -u root --execute "ALTER USER 'nextcloud'@'localhost' IDENTIFIED BY '${NEXTCLOUD_DB_PASS}';"
