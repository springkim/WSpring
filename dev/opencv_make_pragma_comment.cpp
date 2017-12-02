#include<iostream>
#include"ispring\File.h"
std::string lib = "#ifdef _DEBUG\n\
#pragma comment(lib,\"opencv_world331d.lib\")\n\
#else\n\
#pragma comment(lib,\"opencv_world331.lib\")\n\
#endif\n\
";
int main() {
	std::vector<std::string> files = ispring::File::FileList("C:/Users/spring/Desktop/opencv_wspring/include", "*.*", true);
	for (auto& file : files) {
		std::ifstream fin;
		fin.open(file, std::ios::in);
		std::string str;
		str.assign(std::istreambuf_iterator<char>(fin), std::istreambuf_iterator<char>());
		fin.close();
		std::ofstream fout;
		fout.open(file, std::ios::out);
		fout << lib << str;
		fout.close();
	}
	return 0;
}