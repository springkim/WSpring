#include"ispring/File.h"
#include<iostream>
#include<Windows.h>
bool SystemPathAdd(char* name) {
	const char* PATH = "Path";
	const HKEY hkey = HKEY_LOCAL_MACHINE;
	const char* sub_key_name = "System\\CurrentControlSet\\Control\\Session Manager\\Environment";
	HKEY sub_hkey;
	bool ret = true;
	do {
		RegOpenKeyExA(hkey, sub_key_name, 0, KEY_QUERY_VALUE | KEY_SET_VALUE, &sub_hkey);
		DWORD size;
		std::string value;
		if (RegQueryValueExA(sub_hkey, PATH, 0, NULL, NULL, &size) != ERROR_SUCCESS) {
			ret = false;
			break;
		}
		char* data = new char[size];
		RegQueryValueExA(sub_hkey, PATH, 0, NULL, (LPBYTE)data, &size);
		value.assign(data);
		delete[] data;

		std::string::size_type pos = value.find(name, 0);
		while (pos != std::string::npos) {
			if ((0 == pos || (';' == value[pos - 1])) && ((pos + strlen(name) == value.length()) || (';' == value[pos + strlen(name)]))) {
				pos = 0;
				break;
			}
			pos = value.find(name, pos + 1);
		}
		if (pos == 0 || value.length() == 0) {
			ret = false;
			break;
		}
		value = value + ';' + name;
		RegOpenKeyExA(hkey, sub_key_name, 0, KEY_QUERY_VALUE | KEY_SET_VALUE, &sub_hkey);
		RegSetValueExA(sub_hkey, PATH, 0, REG_EXPAND_SZ, reinterpret_cast<BYTE const *>(value.c_str()), value.length() + 1);
		DWORD_PTR result;
		SendMessageTimeoutA(HWND_BROADCAST, WM_SETTINGCHANGE, NULL, reinterpret_cast<LPARAM>("Environment"), SMTO_NORMAL, 100U, &result);
	} while (0);
	RegCloseKey(hkey);
	return ret;
}
int main(int argc, char** argv) {
	if (argc == 2) {
		std::string path = argv[1];
		std::string p;
		for (auto&c : path) {
			if (c != '\"') {
				p.push_back(c);
			}
		}
		if (ispring::File::DirectoryExist(p)) {
			SystemPathAdd(p.c_str());
			return 0;
		}
		std::cerr << "Path error!" << std::endl;
		return 1;
	} else {
		std::cerr << "Argument error!" << std::endl;
	}
	return 1;
}