#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

const char* TEMPLATE = "./template.vhd";
const char* DST = "/Users/zeroisone/VirtualBox VMs/MyOS/learn-asm.vhd";
const int UNIT = 128;

int main(int argc, char* argv[])
{
  if (argc < 2) {
    printf("merge: No input file specified.\n");
    goto fin;
  }
  int fh_template = open(TEMPLATE, O_RDONLY);
  int fh_dst = open(DST, O_WRONLY);
  int fh_src = open(argv[1], O_RDONLY);
  printf("merge: src=%s fh=%d\n", argv[1], fh_src);
  while (1) {
    void *buf_src = malloc(UNIT), *buf_template = malloc(UNIT);
    int read_src = read(fh_src, buf_src, UNIT);
    if (read_src == -1) {
      printf("merge: Error occurred when reading src file.\n");
      perror(argv[1]);
      goto fin;
    }
    int read_template = read(fh_template, buf_template, UNIT);
    if (read_template == -1) {
      printf("merge: Error occurred when reading templaet file.\n");
      perror(TEMPLATE);
      goto fin;
    }
    if (read_src) write(fh_dst, buf_src, UNIT);
    else if (read_template) write(fh_dst, buf_template, UNIT);
    else break;
  }
  close(fh_template);
  close(fh_dst);
  close(fh_src);
 fin: {
    printf("merge: Over\n");
  }
}
