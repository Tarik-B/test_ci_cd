# test_ci_cd

## Pipeline

Static code analysis → Build → Unit tests → Functional (Robot Framework) tests → Deliver

## Todo

- [ok] version number
- [ok] static analysis: cppcheck, gcov coverage

- pre commit hooks
- valgrind, memcheck
- other static analyzers: clang-tidy, clazy (qt-oriented analyzer)
- code formatting: clang-format, cpplint
- auto trigger build
- github pull requests checks
- github actions
- use github actions runner to bypass nat for jenkins integration?
- dockerize

## Jenkins plugins

- [Robot Framework][jenkins_robot]
- [Git][jenkins_git]
- [Build Name and Description Setter][jenkins_build_name]
- [Workspace Cleanup][jenkins_clean]

## Credits

- [Robot Framework real world example in C / C++][robot] sample project by Paran Lee (Apache-2.0 license)
- [GitVersion][versioning] CMake script for getting version from git by Amin Khozaei (no license)

[jenkins_robot]: https://plugins.jenkins.io/robot/
[jenkins_git]: https://plugins.jenkins.io/git/
[jenkins_build_name]: https://plugins.jenkins.io/build-name-setter/
[jenkins_clean]: https://plugins.jenkins.io/ws-cleanup/

[robot]: https://github.com/paranlee/robotframework-c-cpp-demo/
[versioning]: https://dev.to/khozaei/automating-semver-with-git-and-cmake-2hji