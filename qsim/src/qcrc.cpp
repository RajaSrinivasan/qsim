#include <stdio.h>
#include <stdint.h>

int main()
{
  for (uint32_t dividend = 0; dividend < 256; dividend++) {
    uint32_t remainder = dividend; for (int bit = 8; bit > 0; bit--)
      {
        if (remainder & 1) {
          remainder = (remainder >> 1) ^ 0xEDB88320;
        } else {
          remainder >>= 1;
        }
      }
    //crc32_tab[ dividend ] = remainder;
    printf(" 16#%08x# , ",remainder);
    if (dividend % 8 == 0) printf("\n");
  }
  printf("\n");
}
