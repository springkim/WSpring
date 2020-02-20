#include<opencv/cv.h>
#include<opencv/highgui.h>
int main() {
	IplImage* img = cvCreateImage(cvSize(500, 500), IPL_DEPTH_8U, 1);
	memset(img->imageData, 0, img->widthStep*img->height);
	cvNamedWindow("img",CV_WINDOW_AUTOSIZE);
	cvShowImage("img", img);
	cvWaitKey(0);
	cvDestroyAllWindows();
	return 0;
}