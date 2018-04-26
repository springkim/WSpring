#include<opencv2/opencv.hpp>
int main() {
	cv::Mat img = cv::Mat::zeros(500, 500, CV_8UC3);
	for (int i = 0; i < 50; i++) {
		cv::circle(img, cv::Point(rand() % img.cols, rand() % img.rows), rand() % (img.cols / 3)
				   , cv::Scalar(rand() % 255, rand() % 255, rand() % 255), CV_FILLED);
	}
	cv::imshow("img", img);
	cv::waitKey();
	cv::destroyAllWindows();
	return 0;
}