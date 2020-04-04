mbr.bin:
	nasm mbr.asm -o ./.target/mbr.bin

.PHONY: run
run:
	dd if=./.target/mbr.bin of=./.target/boot.img
	read
	bochs -f ./bochrc

.PHONY: dis
dis:
	ndisasm ./.target/mbr.bin > ./dis.out
