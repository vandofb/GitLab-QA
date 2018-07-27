[![Gem Version](https://badge.fury.io/rb/gitlab-qa.svg)](https://rubygems.org/gems/gitlab-qa)
[![build status](https://gitlab.com/gitlab-org/gitlab-qa/badges/master/build.svg)](https://gitlab.com/gitlab-org/gitlab-qa/pipelines)

# GitLab QA orchestrator

## Definitions

- **GitLab QA framework**: A framework that allows developer to write end-to-end
  tests simply and efficiently.
  Located at [`gitlab-org/gitlab-ce@qa/qa/`][qa-framework].
- **GitLab QA instance-level scenarios**: RSpec scenarios that are using
  GitLab QA framework and Capybara to setup and perform individual end-to-end
  tests against a live GitLab instance.
  Located at [`gitlab-org/gitlab-ce@qa/qa/specs/features/`][instance-level-scenarios].
- **GitLab QA orchestrator** (this project): An orchestration tool that allows to run various
  QA test suites in a simple manner.
- **GitLab QA orchestrated scenarios**: Scenarios where containers are started,
  configured and that run instance-level scenarios against a live GitLab
  instance.
  Located at [`gitlab-org/gitlab-qa@lib/gitlab/qa/scenario/test/`][orchestrated-scenarios].

[qa-framework]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/
[instance-level-scenarios]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/specs/features/
[orchestrated-scenarios]: https://gitlab.com/gitlab-org/gitlab-qa/blob/master/lib/gitlab/qa/scenario/test/

## Goals and objectives

GitLab consists of multiple pieces configured and packaged by
[GitLab Omnibus](https://gitlab.com/gitlab-org/omnibus-gitlab).

The purpose of the QA end-to-end test suite is to verify that all pieces
integrate well together.

### GitLab QA tests running in the CI/CD environment

Manual steps should not be needed to run the QA test suite.
GitLab QA orchestrator is CI/CD environment native, which means that we should
add new features and tests when we are comfortable with running new code in the
CI/CD environment.

### GitLab QA test failure are reproducible locally

Despite the fact that GitLab QA orchestrator has been built to run in the CI/CD
environment, it is really important to make it easy for developers to reproduce
test failures locally. It is much easier to debug things locally, than in the
CI/CD.

To make it easier to reproduce test failures locally we have published the
`gitlab-qa` gem [on rubygems.org](https://rubygems.org/gems/gitlab-qa) and we
are using exactly the same approach to run tests in the CI/CD environment.

It means that using `gitlab-qa` CLI tool, that orchestrates test environment and
runs GitLab QA test suite, is a reproducible way of running tests locally and
in the CI/CD.

It also means that we cannot have a custom code in `.gitlab-ci.yml` to, for
example, start new containers / services.

### Test installation / deployment process too

We distribute GitLab in a package (like Debian package or a Docker image) so
we want to test installation process to ensure that our package is not broken.

But we are also working on making GitLab be a cloud native product. This means
that using Helm becomes yet another installation / deployment process that we
want to test with GitLab QA.

Keeping in mind that we want to test our Kubernetes deployments is especially
important with consideration of the need of testing changes in merge requests.

### Testing changes in merge requests before the merge

The ultimate goal is to make it possible to run the QA test suite for any
merge request, even before merging code into the `master` branch.

### We can run tests against any instance of GitLab

GitLab QA is a click-driven, black-box testing tool. We also use it to run
tests against the staging, and we strive for making it useful for our users
as well.

## Documentation

All the documentation can be found under [`docs/`](/docs/README.md).

## How do we use it

Currently we trigger the test suite against GitLab Docker images created by Omnibus
nightly. This happens in the [nightly](https://gitlab.com/gitlab-org/quality/nightly/pipelines)
and [staging](https://gitlab.com/gitlab-org/quality/staging/pipelines) project pipelines.

We also trigger GitLab QA pipelines whenever someone clicks `package-and-qa` manual
action in a merge request.

## How can you use it

GitLab QA tool is published as a [Ruby Gem](https://rubygems.org/gems/gitlab-qa).

You can install it with `gem install gitlab-qa`. It will expose a `gitlab-qa`
command in your system.

If you want to run the scenarios against your GDK and/or develop them on Mac OS,
please read [Run QA tests against your GDK setup](/docs/run_qa_against_gdk.md)
as there are caveats and things that may work differently.

All the scenarios you can run are described in the
[What tests can be run?](/docs/what_tests_can_be_run.md) documentation.

### How to add new scenarios

Scenarios (test cases) and scripts to run them are located in
[CE](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/qa) and
[EE](https://gitlab.com/gitlab-org/gitlab-ee/tree/master/qa)
repositories under `qa/` directory, so please also check the documentation there.

## Contributing

Please see the [contribution guidelines](CONTRIBUTING.md).
