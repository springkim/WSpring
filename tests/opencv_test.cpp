#include<opencv2/opencv.hpp>
int main() {
	cv::Mat img = cv::Mat::zeros(500, 500, CV_8UC1);
	cv::imshow("img", img);
	cv::waitKey();
	cv::destroyAllWindows();
	return 0;
}