#!/bin/bash

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

    # verific dacă IP-ul din /etc/hosts se potrivește cu cel din DNS
    # nslookup caută numele pe internet
    # 2>/dev/null redirectioneaza posibile erori
    # grep -q caută dacă IP-ul din fișierul nostru apare în răspunsul DNS
    # ! neaga valoarea de adevar; eu verific daca NU coincid
    if ! nslookup "$name" 8.8.8.8 2>/dev/null  | grep -q "$ip"; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done
