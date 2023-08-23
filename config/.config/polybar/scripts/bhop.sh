#!/bin/bash
# Belgium Heating Oil Prices
PRICE=$(curl -s https://bestat.statbel.fgov.be/bestat/api/views/665e2960-bf86-4d64-b4a8-90f2d30ea892/result/JSON | jq '.facts[] | select(.Product=="Heating gasoil 50S (<2000L) (€/L)")."Price incl. VAT"')
printf "%.2f \n" "$PRICE"
