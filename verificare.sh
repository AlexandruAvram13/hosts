#!/bin/bash


verifica_ip() {
    local nume_host=$1
    local ip=$2
    local server_dns=$3

    if ! nslookup "$nume_host" "$server_dns" 2>/dev/null | grep -q "$ip"; then
        echo "Bogus IP for $nume_host in /etc/hosts!"
    fi
}

cat /etc/hosts | while read -r ip name restul
do
    # ignor liniile goale
    if [ -z "$ip" ]; then
        continue
    fi

    # ignor comentariile
    if [[ "$ip" == \#* ]]; then
        continue
    fi

    # ignor liniile incomplete (sa nu imi dea eroare mai tarziu)
    if [ -z "$name" ]; then
        continue
    fi

    # ignor adresele locale
    if [[ "$ip" == 127.* ]]; then
        continue
    fi

    # ignor adresele IPv6, care conțin ':'
    if [[ "$ip" == *:* ]]; then
        continue
    fi

    # apelez funcția cu cei 3 parametri: nume host, IP și server DNS
    verifica_ip "$name" "$ip" "8.8.8.8"
done
