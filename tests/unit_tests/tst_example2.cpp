#include <catch2/catch.hpp>

// #include <iostream>

#include "common.h"

TEST_CASE("Test case 2.1", "[category2]")
{
    INFO("Test info");

    {
        REQUIRE(1u == 1);
    }

    {
        REQUIRE(0x0 == 0);
    }
}

TEST_CASE("Test case 2.2", "[category2]")
{
    REQUIRE(true);
}
