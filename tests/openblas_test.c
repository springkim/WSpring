#include<openblas/cblas.h>
int main() {
	float A[] = {
		2.0F,2.0F,2.0F
	};
	float B[] = {
		1.0F
		,2.0F
		,3.0F
	};
	float C[1];
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 1, 1, 3, 1.0F, A, 3, B, 1, 0.0F, C, 1);
	printf("%f\n", C[0]);
	return 0;
}