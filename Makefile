KDIR:=/opt/iot-devkit/1.7.2/sysroots/i586-poky-linux/usr/src/kernel
CC = i586-poky-linux-gcc
CROSS_COMPILE = i586-poky-linux-

PWD:= $(shell pwd)

ARCH = x86
SROOT=/opt/iot-devkit/1.7.2/sysroots/i586-poky-linux
EXTRA_CFLAGS += -Wall

LDLIBS = -L$(SROOT)/usr/lib
CCFLAGS = -I$(SROOT)/usr/include/libnl3

APP = 
EXAMPLE = genl_ex

obj-m:= genl_drv.o

.PHONY:all
all: genl_ex genl_ex.ko

genl_ex.ko:
	make ARCH=x86 CROSS_COMPILE=$(CROSS_COMPILE) -C $(KDIR) M=$(PWD) modules

genl_ex:
	$(CC) -Wall -o $(EXAMPLE) genl_ex.c $(CCFLAGS) -lnl-genl-3 -lnl-3

.PHONY:clean
clean:
	make -C $(KDIR) M=$(PWD) clean
	rm -f *.o $(EXAMPLE) $(APP)

deploy:
	tar czf programs.tar.gz $(APP) $(EXAMPLE) genl_drv.ko
	scp programs.tar.gz root@10.0.1.100:/home/root
	ssh root@10.0.1.100 'tar xzf programs.tar.gz'
