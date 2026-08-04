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

  "DiagnosticSessionControl")
    par="$2"
    if [ "$par" = "ProgrammingSession" ]; then 
      cansend $INTERFACE ${FUN_ID}#021002000000000000
    elif [ "$par" = "extendedDiagnosticSession" ]; then
      cansend $INTERFACE ${FUN_ID}#021003000000000000
    fi
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
    DID="$2"
    RAW_DATA="$3"

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
    ./uds-client.sh SecurityAccess requestSeed ; ./uds-client.sh SecurityAccess sendKey deadbeef
  ;;

  "TesterPresent")
    while true; do
      cansend $INTERFACE ${PHY_ID}#023E000000000000
      sleep 4
    done 
    ;;

  "RequestUpload")
    cansend $INTERFACE ${PHY_ID}#0635002100000d00
  ;;

  "RequestTransferExit")
    cansend $INTERFACE ${PHY_ID}#0137000000000000
    ;;

  "TransferData")
    BS="$2"
    cansend $INTERFACE ${PHY_ID}#0236${BS}0000000000
    ;;
  *)
  echo "Invalid command"

esac

