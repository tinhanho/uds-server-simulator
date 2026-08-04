GXX = gcc
TARGET = uds-server-simulator
DEPENDENCY = ../uds-server-simulator.c ../third/cJSON.c
CONFIG = config.json
SHELLSCRIPT = uds-client.sh

all:
	$(GXX) -w $(DEPENDENCY) -o $(TARGET)
	cp ../$(CONFIG) $(CONFIG)
	cp ../$(SHELLSCRIPT) $(SHELLSCRIPT)
	sudo ip link add dev can0 type vcan || true
	sudo ip link set can0 up || true
	./$(TARGET) -e TBOX can0

clear:
	rm $(TARGET)
	rm $(CONFIG)
	rm $(SHELLSCRIPT)