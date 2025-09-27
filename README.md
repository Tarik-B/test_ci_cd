# test_ci_cd

## Pipeline

Static code analysis → Build → Unit tests → Functional (Robot Framework) tests → Deliver


## Todo

- auto trigger build
- version number
- static analysis (cppcheck, cpplint, clang-format, gcov coverage)
- dockerize
- code formatting
- pre commit hooks
- github pull requests checks
- github actions
- use github actions runner to bypass nat for jenkins integration?

### Credits

- [Robot Framework real world example in C / C++] sample project by Paran Lee (Apache-2.0 license)
- [GitVersion][versioning] CMake script for getting version from git by Amin Khozaei (no license)

[robot]: https://github.com/paranlee/robotframework-c-cpp-demo/
[versioning]: https://dev.to/khozaei/automating-semver-with-git-and-cmake-2hji