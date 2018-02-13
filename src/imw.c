#include<stdio.h>
#include<Windows.h>
int main(int argc,char** argv) {
	//argv[1]=Image path
	HINSTANCE hInstance = GetModuleHandle(NULL);
	HWND hWnd = FindWindow(TEXT("ConsoleWindowClass"), NULL);
	HBITMAP hImage=NULL, hOldBitmap;
	HDC hdc = GetDC(hWnd);
	HDC hMemDC = CreateCompatibleDC(hdc);
	hImage = (HBITMAP)LoadImageA(NULL,argv[1],IMAGE_BITMAP,0,0,LR_LOADFROMFILE | LR_CREATEDIBSECTION);
	hOldBitmap = (HBITMAP)SelectObject(hMemDC, hImage);
	while (1) {
		BitBlt(hdc, 10, 10, 128, 128, hMemDC, 0, 0, SRCCOPY);
		Sleep(1);
	}
	SelectObject(hMemDC, hOldBitmap);
	DeleteObject(hImage);
	DeleteDC(hMemDC);
	ReleaseDC(hWnd, hdc);
	return 0;
}