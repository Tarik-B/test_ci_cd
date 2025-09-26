#include <iostream>
#include <string>
#include <cstring>

#include <QApplication>

#include "mainwindow.h"

int main(int argc, char* argv[])
{
    if( argc != 3 ) {
        std::cout << "Error: arguments not matched" << std::endl;
        return 1;
    }
    if( strlen(argv[1]) > 5 || strlen(argv[2]) > 5 ) {
        std::cout << "Error: Too many chracter" << std::endl;
        return 1;
    }

    std::string arg1(argv[1]), arg2(argv[2]);
    bool bool1 = 0 == arg1.compare("hello");
    bool bool2 = 0 == arg2.compare("world");

    if(!bool1) {
        std::cout << "Error: First argument should hello." << std::endl;
    }

    if(!bool2) {
        std::cout << "Error: Second argument should world." << std::endl;
    }

    if(bool1 && bool2) {
        std::cout << arg1 << ", " << arg2 << std::endl;
    }

    // std::cout << "hello, world" << std::endl;
    // QApplication a(argc, argv);
    // MainWindow w;
    // w.show();
    // return a.exec();

    return 0;
}
