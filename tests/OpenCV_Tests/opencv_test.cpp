#include<opencv2/opencv.hpp>
#pragma pack(push,1)
#define ENTIRES_ICO 1
#define ENTIRES_CUR 2
struct ICOCUR_Entires {
	unsigned char width;
	unsigned char height;
	unsigned char color_count;
	unsigned char reserved;
	union {
		unsigned short x_hot_spot;
		unsigned short planes;
	};
	union {
		unsigned short y_hot_spot;
		unsigned short bit_counts;
	};
	unsigned int size_in_bytes;
	unsigned int file_offset;
};
struct ICOCUR_InfoHeader {
	unsigned int size;
	unsigned int width;
	unsigned int height;
	unsigned short planes;
	unsigned short bit_count;
	unsigned int compression;
	unsigned int image_size;
	unsigned int x_pixels_per_M;
	unsigned int y_pixels_per_M;
	unsigned int colors_used;
	unsigned int colors_important;
};
struct CUR_Header {
	short reserved = 0;
	short type = 2;
	short count = 1;
	ICOCUR_Entires entires;
	ICOCUR_InfoHeader info_header;
};
#pragma pack(pop)
uchar* ToICOorCUR(cv::Mat img,unsigned short type) {
	//https://www.daubnet.com/en/file-format-cur
	//https://www.daubnet.com/en/file-format-ico
	if (img.channels() != 4) {
		return nullptr;
	}
	if (img.cols != 32 && img.rows != 32) {
		cv::resize(img, img, cv::Size(32, 32));
	}
	int W = 32;
	int H = 32;
	CUR_Header header;
	header.reserved = 0;
	header.type = type;
	header.count = 1;
	header.entires.width = 32;
	header.entires.height = 32;
	header.entires.color_count = 0;
	header.entires.reserved = 0;
	if (type == ENTIRES_CUR) {
		header.entires.x_hot_spot = 15;
		header.entires.y_hot_spot = 15;
	} else if (type == ENTIRES_ICO) {
		header.entires.planes = 1;
		header.entires.bit_counts = 8;
	}
	header.entires.size_in_bytes = 40 + 4 * (W*H) + (W*H) / 8;
	header.entires.file_offset = 22;
	header.info_header.size = 40;
	header.info_header.width = 32;
	header.info_header.height = 64;
	header.info_header.planes = 1;
	header.info_header.bit_count = 32;
	header.info_header.compression = 0;
	header.info_header.image_size = (W*H) * 4;
	header.info_header.x_pixels_per_M = 0;
	header.info_header.y_pixels_per_M = 0;
	header.info_header.colors_used = 0;
	header.info_header.colors_important = 0;
	int size = sizeof(header) + (W*H) * 4 + (W*H) / 8;
	uchar* cur = (uchar*)calloc(size, sizeof(uchar));
	uchar* p_header = cur;
	uchar* p_colors = cur + sizeof(header);
	unsigned int* p_monochrome = (unsigned int*)(cur + (sizeof(header) + (W*H) * 4));
	memcpy(p_header, &header, sizeof(header));
	for (int y = 31; y >= 0; y--) {
		for (int x = 31; x >= 0; x--) {
			cv::Vec4b& c = img.at<cv::Vec4b>(y, x);
			*p_colors++ = c[0];
			*p_colors++ = c[1];
			*p_colors++ = c[2];
			*p_colors++ = c[3];
			if (c[3] == 255) {
				*p_monochrome |= 1 << x;
			}
		}
		char* cm = (char*)p_monochrome;
		cm[0] ^= cm[3];
		cm[3] ^= cm[0];
		cm[0] ^= cm[3];
		cm[1] ^= cm[2];
		cm[2] ^= cm[1];
		cm[1] ^= cm[2];
		p_monochrome++;
	}
	return cur;
}
uchar* cvMat2Cur(cv::Mat img) {
	return ToICOorCUR(img, ENTIRES_ICO);
}
uchar* cvMat2Ico(cv::Mat img) {
	return ToICOorCUR(img, ENTIRES_CUR);
}

int main() {
	printf("%d\n", sizeof(ICOCUR_Entires));
	printf("%d\n", sizeof(ICOCUR_InfoHeader));
	std::string png = "bitbucket.png";
	cv::Mat img = cv::imread("bitbucket.png", cv::IMREAD_UNCHANGED);
	std::string cur = png.substr(0, png.find_last_of('.')) + ".cur";
	std::string ico = png.substr(0, png.find_last_of('.')) + ".ico";
	FILE* fp_cur = fopen(cur.c_str(), "wb");
	FILE* fp_ico = fopen(ico.c_str(), "wb");
	uchar* cur_bytes = cvMat2Cur(img);
	uchar* ico_bytes = cvMat2Cur(img);
	fwrite(cur_bytes, 4294, 1, fp_cur);
	fwrite(ico_bytes, 4294, 1, fp_ico);
	fclose(fp_cur);
	fclose(fp_ico);
	free(cur_bytes);
	free(ico_bytes);
	return 0;
}