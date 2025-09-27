#include <version.h>

// #include <QApplication>
#include <cstring>
#include <iostream>
// #include <string>

// #include "mainwindow.h"

// void print_version() {
//     std::cout << "Application Version: " << PROJECT_VERSION << std::endl;
//     // std::cout << "Full Version: " << FULL_VERSION << std::endl;
//     std::cout << "Version Details:" << std::endl;
//     std::cout << "Major: " << PROJECT_VERSION_MAJOR << std::endl;
//     std::cout << "Minor: " << PROJECT_VERSION_MINOR << std::endl;
//     std::cout << "Patch: " << PROJECT_VERSION_PATCH << std::endl;
//     std::cout << "Build Date: " << __DATE__ << std::endl;
//     std::cout << "Build Time: " << __TIME__ << std::endl;
// }

int main(int argc, char* argv[]) {
    // print_version();

    auto test = new int;
    *test = 23;
    if (false)
        delete test;  // To prevent static analysis from detecting the memleak

    if (argc != 3) {
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

    return EXIT_SUCCESS;
}
