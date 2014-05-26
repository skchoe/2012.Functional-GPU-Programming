#include <stdio.h>

int main(int argc, char *argv[])
{
int c;
FILE *fIn;

if(argc < 2)
{
fprintf(stderr, "Usage: %s <file>\n", argv[0]);
	return 1;
}
							
	fIn = fopen(argv[1], "rb");
	if(fIn == NULL)
{
	fprintf(stderr, "Error opening file \"%s\"\n", argv[1]);
	return 2;
}
																				
																					while((c = fgetc(fIn)) != EOF)
																					{
	printf("%#02x ", c);
		}
	fclose(fIn);

	return 0;
}
