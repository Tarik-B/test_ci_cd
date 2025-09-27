#define CATCH_CONFIG_RUNNER
//#define CONFIG_CATCH_MAIN

#include <catch2/catch.hpp>

int main(int argc, char** argv)
{
    return Catch::Session().run(argc, argv);
}
