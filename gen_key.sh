#!/bin/sh

umask 077

priv=$(awg genkey)
pub=$(printf "%s" "$priv" | awg pubkey)

echo "PrivateKey = $priv"
echo "PublicKey  = $pub"

