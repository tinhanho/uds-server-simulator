# How to test

## Server
Run ```make``` to enable the UDS server

## Client
1. Run ```sudo ip link add dev can0 type vcan``` and ```sudo ip link set can0 up``` to enable a virtual can interface
2. Use ```./uds-client.sh```  with following parameter

|Parameter|Header Value|Example|
|-|-|-|
|ReadDataByIdentifier $(DID)|0x22|./uds-client.sh f190|
|DiagnosticSessionControl $(SubFunc)|0x10|./uds-client.sh DiagnosticSessionControl extendedDiagnosticSession|
|SecurityAccess \$(SubFunc) \$(OptionalKeyValue)|0x27|./uds-client.sh SecurityAccess SendKey deadbeef|
|WriteDataByIdentifier \$(DID) \$(Value)|0x2E|./uds-client.sh WriteDataByIdentifier f190 aabbccddee|
|TestPresent|0x3E||

## Sniffer
1. Make sure that can-utils is installed
2. Run ```candump -a can0```