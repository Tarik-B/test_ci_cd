#include <catch2/catch.hpp>

// #include <iostream>

#include "common.h"

TEST_CASE("Test case 1.1", "[category1]") {
    INFO("Test info");

    {
        REQUIRE(1u == 1);
    }

    {
        // REQUIRE(0x0 == 0);
    }
}

TEST_CASE("Test case 1.2", "[category1]") {}
