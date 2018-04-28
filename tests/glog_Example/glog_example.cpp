#include <glog/logging.h>
int foo() {
	return 3;
}
int main() {
	google::InitGoogleLogging("Test");
	google::SetLogDestination(google::GLOG_INFO, "./Test.");      

	LOG(INFO) << "this is info logging";
	LOG(WARNING) << "this is warning logging";

	CHECK(foo() == 3) << "foo() is 3";

	FLAGS_v = 1;
	VLOG(1) << "I'm printed when you run the program with --v=1 or higher";
	VLOG(2) << "I'm printed when you run the program with --v=2 or higher";

	google::ShutdownGoogleLogging();
	return 0;
}