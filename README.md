# CMake-based C++ project with Jenkins build pipeline

## Pipeline

- Buildsystem generation (CMake)
- Static code analysis (Cppcheck)
- Build
- Sanity check (Valgrind's memcheck)
- Unit tests and coverage (CTest)
- Functional/Robot Framework tests
- Delivery

## Todo

- [X] version number
- [X] static analysis: cppcheck, gcov coverage
- [X] valgrind, memcheck
- [X] auto trigger build  (via smee https://smee.io)
- [X] github pull requests checks
- [X] jenkins desktop notifications (via catlight https://catlight.io/downloads/linux/beta)
- [X] dockerize
- [ ] pre commit hooks
- [ ] other static analyzers: clang-tidy, clazy (qt-oriented analyzer)
- [ ] code formatting: clang-format, cpplint
- [ ] cross compilation
- [ ] dependency (like catch2) management via conan?
- [ ] use clang?
- [ ] use ninja as generator?
- [ ] separate debug symbols? (+ generate symbols in release too)
- [ ] JCasC (Jenkins Configuration as Code)?
- [ ] ~~use github actions runner to bypass nat for jenkins integration?~~

## Jenkins plugins used

- [Robot Framework][jenkins_robot]
- [Git][jenkins_git]
- [Build Name and Description Setter][jenkins_build_name]
- [Workspace Cleanup][jenkins_clean]
- [Multibranch Scan Webhook Trigger][jenkins_webhook]
- [CatLight Notification][jenkins_catlight]

[jenkins_robot]: https://plugins.jenkins.io/robot/
[jenkins_git]: https://plugins.jenkins.io/git/
[jenkins_build_name]: https://plugins.jenkins.io/build-name-setter/
[jenkins_clean]: https://plugins.jenkins.io/ws-cleanup/
[jenkins_webhook]: https://plugins.jenkins.io/multibranch-scan-webhook-trigger/
[jenkins_catlight]: https://plugins.jenkins.io/catlight/

## Credits

- [Robot Framework real world example in C / C++][robot] sample project by Paran Lee (Apache-2.0 license)
- [GitVersion][versioning] CMake script for getting version from git by Amin Khozaei (no license)

[robot]: https://github.com/paranlee/robotframework-c-cpp-demo/
[versioning]: https://dev.to/khozaei/automating-semver-with-git-and-cmake-2hji