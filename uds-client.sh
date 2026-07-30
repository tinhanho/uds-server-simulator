#!/bin/bash

INTERFACE="can0"
TAR_ID="7E8"
FUN_ID="7DF"
PHY_ID="7E0"


case "$1" in
  "ReadDataByIdentifier")
    # Clean 0x prefix if present
    DID=$(echo "$2" | sed 's/0x//i')
    cansend $INTERFACE ${PHY_ID}#0322${DID}00000000
    ;;

  "extendedDiagnosticSession")
    cansend $INTERFACE ${FUN_ID}#021003000000000000
    ;;

  "SecurityAccess")
    par="$2"
    if [ "$par" = "requestSeed" ]; then
      cansend $INTERFACE ${PHY_ID}#0227030000000000
    elif [ "$par" = "sendKey" ]; then
      DATA="$3"
      cansend $INTERFACE ${PHY_ID}#062704${DATA}00
    fi
    ;;

  "WriteDataByIdentifier")
    DID="F187"
    RAW_DATA="$2"

    DATA_CLEAN=$(echo "$RAW_DATA" | sed 's/0x//i' | tr 'a-z' 'A-Z')

    FULL_HEX="2E${DID}${DATA_CLEAN}"

    SPACED_HEX=$(echo "$FULL_HEX" | sed 's/..\?/& /g' | sed 's/ $//')

    # echo "echo \"$SPACED_HEX\" | isotpsend -s ${PHY_ID} -d ${TAR_ID} $INTERFACE"

    echo "$SPACED_HEX" | isotpsend -s ${PHY_ID:-7E0} -d ${TAR_ID:-7E8} $INTERFACE
    ;;

  "FC")
    cansend $INTERFACE ${PHY_ID}#3000000000000000
    ;;


  "SecurityTest")
    ./uds.sh extendedDiagnosticSession ; ./uds.sh SecurityAccess requestSeed ; ./uds.sh SecurityAccess sendKey deadbeef
  ;;

  "TestPresent")
    while true; do
      cansend $INTERFACE ${PHY_ID}#023E000000000000
      sleep 4
    done 
    ;;

esac

