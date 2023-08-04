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

sudo nixos-rebuild switch --upgrade --flake .
