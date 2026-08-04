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
|TestPresent|0x3E|(TestPresent is sent periodically and shall be executed in another process)|
|RequestUpload|0x35||
|RequestTransferExit|0x36||
|TransferData|0x37|./uds-client.sh TransferData 01|

> "SecurityTest" to quickly get seed and send key

> "FC" to send CAN TP flow control packet 

## Sniffer
1. Make sure that can-utils is installed
2. Run ```candump -a can0```

## End of the test
Run ```make clear``` to remove the test files