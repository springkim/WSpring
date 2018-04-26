#include<cblas.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
void Gemm_Time() {
	//[nxn] * [nxn]
	int n = 1000;
	float* A = (float*)calloc(n*n, sizeof(float));
	float* B = (float*)calloc(n*n, sizeof(float));
	float* C = (float*)calloc(n*n, sizeof(float));
	for (int i = 0; i < n*n; i++) {
		A[i] = (float)rand() / RAND_MAX + rand();
		B[i] = (float)rand() / RAND_MAX + rand();
	}
	float t_beg = clock();
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, n, n, n, 1.0F, A, n, B, n, 0.0F, C, n);
	float t_end = clock();
	printf("time : %f\n", (t_end - t_beg) / CLOCKS_PER_SEC);
	printf("%f\n", C[0]);
}
void Gemm_Example() {
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
}
void Gemv_Example() {
	float X[] = {
		1.0F
		,2.0F
		,3.0F
		,4.0F
	};
	float A[] = {
		1.0F,1.0F,1.0F,1.0F
		,2.0F,2.0F,2.0F,2.0F
		,3.0F,3.0F,3.0F,3.0F
	};
	int n = 4;
	int m = 3;
	float Y[3] = { 0 };
	cblas_sgemv(CblasRowMajor, CblasNoTrans, m, n, 1.0F, A, n, X, 1, 0.0F, Y, 1);
	for (int i = 0; i < 3; i++) {
		printf("[%f]\n", Y[i]);
	}
}
void Dot_Example() {
	float X[] = {1.0F,2.0F,3.0F,4.0F};
	float Y[] = { 1.0F,2.0F,3.0F,4.0F };
	int n = 4;
	float dot=cblas_sdot(n, X, 1, Y, 1);
	printf("%f\n", dot);
}
void Axpy_Example() {
	float X[] = { 1.0F,2.0F,3.0F,4.0F };
	float Y[4] = { 0 };
	int n = 4;
	cblas_saxpy(n, 2.0F, X, 1, Y, 1);
	for (int i = 0; i < 4; i++) {
		printf("[%f]", Y[i]);
	}
}
int main() {
	Dot_Example();
	Axpy_Example();
	Gemv_Example();
	Gemm_Example();
	Gemm_Time();
	return 0;
}