#!/bin/bash
# Belgium Heating Oil Prices

URL="https://bestat.statbel.fgov.be/bestat/api/views/665e2960-bf86-4d64-b4a8-90f2d30ea892/result/JSON"
PRODUCT="Heating gasoil (H0/H7) (<2000L) (€/L)"
PRICE=$(curl -s "$URL" | jq '.facts[] | select(.Product=="'"$PRODUCT"'")."Price incl. VAT"')

# Check if price equal null
if [ "$PRICE" = "null" ]; then
	echo "N/A"
else
  printf "%.2f \n" "$PRICE"
fi
