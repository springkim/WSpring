#include <fstream>
#include <iostream>
#include <string>
#include <locale>
#include <codecvt>
#include <vector>
#include<algorithm>
#include<Windows.h>
enum CHARACTER_ENCODING{
    ANSI,
    Unicode,
    Unicode_big_endian,
    UTF8_with_BOM,
    UTF8_without_BOM,
	NOTAFILE
};
CHARACTER_ENCODING get_text_file_encoding(const char *filename){
    CHARACTER_ENCODING encoding;
    unsigned char uniTxt[] = {0xFF, 0xFE};		// Unicode file header
    unsigned char endianTxt[] = {0xFE, 0xFF};	// Unicode big endian file header
    unsigned char utf8Txt[] = {0xEF, 0xBB};		// UTF_8 file header
    DWORD dwBytesRead = 0;
    HANDLE hFile = CreateFile(filename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE){
        hFile = NULL;
        CloseHandle(hFile);
		return CHARACTER_ENCODING::NOTAFILE;
    }
    BYTE *lpHeader = new BYTE[2];
    ReadFile(hFile, lpHeader, 2, &dwBytesRead, NULL);
    CloseHandle(hFile);

    if (lpHeader[0] == uniTxt[0] && lpHeader[1] == uniTxt[1])// Unicode file
        encoding = CHARACTER_ENCODING::Unicode;
    else if (lpHeader[0] == endianTxt[0] && lpHeader[1] == endianTxt[1])//  Unicode big endian file
        encoding = CHARACTER_ENCODING::Unicode_big_endian;
    else if (lpHeader[0] == utf8Txt[0] && lpHeader[1] == utf8Txt[1])// UTF-8 file
        encoding = CHARACTER_ENCODING::UTF8_with_BOM;
    else
        encoding = CHARACTER_ENCODING::ANSI;   //Ascii

    delete []lpHeader;
    return encoding;
}
// Convert a wide Unicode string to an UTF8 string
std::string utf8_encode(const std::wstring &wstr)
{
	int size_needed = WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), NULL, 0, NULL, NULL);
	std::string strTo(size_needed, 0);
	WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), &strTo[0], size_needed, NULL, NULL);
	return strTo;
}

// Convert an UTF8 string to a wide Unicode String
std::wstring utf8_decode(const std::string &str)
{
	int size_needed = MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), NULL, 0);
	std::wstring wstrTo(size_needed, 0);
	MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), &wstrTo[0], size_needed);
	return wstrTo;
}

// Convert an wide Unicode string to ANSI string
std::string unicode2ansi(const std::wstring &wstr)
{
	int size_needed = WideCharToMultiByte(CP_ACP, 0, &wstr[0], -1, NULL, 0, NULL, NULL);
	std::string strTo(size_needed, 0);
	WideCharToMultiByte(CP_ACP, 0, &wstr[0], (int)wstr.size(), &strTo[0], size_needed, NULL, NULL);
	return strTo;
}

// Convert an ANSI string to a wide Unicode String
std::wstring ansi2unicode(const std::string &str)
{
	int size_needed = MultiByteToWideChar(CP_ACP, 0, &str[0], (int)str.size(), NULL, 0);
	std::wstring wstrTo(size_needed, 0);
	MultiByteToWideChar(CP_ACP, 0, &str[0], (int)str.size(), &wstrTo[0], size_needed);
	return wstrTo;
}
int main(int argc,char** argv){
	CHARACTER_ENCODING ce=get_text_file_encoding(argv[1]);
	switch(ce){
		case ANSI:puts("ANSI");break;
		case Unicode:puts("Unicode");break;
		case Unicode_big_endian:puts("Unicode_big_endian");break;
		case UTF8_with_BOM:puts("UTF8_with_BOM");break;
		case UTF8_without_BOM:puts("UTF8_without_BOM");break;
		default:puts("UNKNOWN");break;
	}
	return 0;
}
/*
// Write file in UTF-8
std::wofstream wof;
wof.imbue(std::locale(std::locale::empty(), new std::codecvt_utf8<wchar_t,0x10ffff,std::generate_header>));
wof.open(L"file.txt");
wof << L"This is a test.";
wof << L"This is another test.";
wof << L"\nThis is the final test.\n";
wof.close();

// Read file in UTF-8
std::wifstream wif(L"file.txt");
wif.imbue(std::locale(std::locale::empty(), new std::codecvt_utf8<wchar_t,0x10ffff, std::consume_header>));

std::wstringstream wss;
wss << wif.rdbuf();*/
