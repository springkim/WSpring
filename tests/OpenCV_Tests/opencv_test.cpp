#include<opencv2/opencv.hpp>
int main() {
	cv::VideoCapture vc(0);
	cv::Mat frame;
	while (vc.read(frame)) {
		cv::imshow("frame", frame);
		if (cv::waitKey(1) == 27)break;
	}
	cv::destroyAllWindows();
	return 0;
}