#include <stdlib.h>
#include <stdio.h>

#include "Math.h"

int main(int argc, char* argv[]) {
	int firstInput, secondInput;

	printf("Enter two numbers to add:\n");
	scanf("%d", &firstInput);
	scanf("%d", &secondInput);

	printf("%d + %d = %d", firstInput, secondInput, Add(firstInput, secondInput));

	return 0;
}