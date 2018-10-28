#include<opencv2/opencv.hpp>
int main() {
	
	std::deque<cv::Vec6d> circles;
	for (int i = 0; i < 10; i++) {
		circles.push_back(cv::Vec6d(rand() % 500, rand() % 500, rand() % 250,rand()%255,rand()%255,rand()%255));
	}
	while (true) {
		cv::Mat img = cv::Mat::zeros(500, 500, CV_8UC3) + cv::Scalar(255, 255, 255);
		for (auto&c : circles) {
			cv::circle(img, cv::Point(c[0], c[1]), c[2], cv::Scalar(c[3], c[4], c[5]), CV_FILLED, CV_AA);
		}
		cv::imshow("circles", img);
		cv::waitKey(100);
		circles.pop_front();
		circles.push_back(cv::Vec6d(rand() % 500, rand() % 500, rand() % 250, rand() % 255, rand() % 255, rand() % 255));
	}
}