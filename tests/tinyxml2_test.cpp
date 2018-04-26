#include<tinyxml2.h>
int main() {
	tinyxml2::XMLDocument xml;
	tinyxml2::XMLDeclaration* decl = xml.NewDeclaration();
	tinyxml2::XMLElement* elem = xml.NewElement("Hello");
	elem->LinkEndChild(xml.NewText("World"));
	xml.LinkEndChild(decl);
	xml.LinkEndChild(elem);
	xml.SaveFile("a.xml");
	return 0;
}