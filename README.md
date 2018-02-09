[![Gem Version](https://badge.fury.io/rb/gitlab-qa.svg)](https://rubygems.org/gems/gitlab-qa)
[![build status](https://gitlab.com/gitlab-org/gitlab-qa/badges/master/build.svg)](https://gitlab.com/gitlab-org/gitlab-qa/pipelines)

# GitLab end-to-end tests

End-to-end test suite that verifies GitLab as a whole.

GitLab consists of multiple pieces configured and packaged by
[GitLab Omnibus](https://gitlab.com/gitlab-org/omnibus-gitlab).

The purpose of this test suite is to verify that all pieces do integrate well together.

## Architecture

See the [GitLab QA architecture](/docs/architecture.md).

## Goals and objectives

### GitLab QA tests running in the CI/CD environment

GitLab QA is an automated end-to-end testing framework, which means that no
manual steps should be needed to run GitLab QA test suite. This framework is
CI/CD environment native, which means that we should design new features and
tests that we can comfortable run in the CI/CD environment.

### GitLab QA test failure are reproducible locally

Despite the fact GitLab QA has been built to run in the CI/CD environment, it
is really important to make it easy for developers to reproduce GitLab QA test
failure locally. It is much easier to debug things locally, than in the CI/CD.

To make it easier to reproduce test failures locally we have published
`gitlab-qa` gem [on rubygems.org](https://rubygems.org/gems/gitlab-qa) and we
are using the same code to run tests in the CI/CD environment.

It means that using `gitlab-qa` CLI tool that orchestrates test environment and
runs GitLab QA test suite is a reproducible way of running tests.

It also means that we can not have a custom code in `.gitlab-ci.yml` to, for
example, start new containers.

### Test installation / deployment process too

We distribute GitLab as a package (like Debian package or a Docker image) and
we want to test installation process, to ensure that our package is not broken.

But we are also working on making GitLab a cloud native product. This means
using Helm becomes yet another installation / deployment process that we want
to test with GitLab QA.

Keeping in mind that we want to test our Kubernetes deployments is especially
important with consideration of the need of testing changes in merge requests.

### Testing changes in merge requests before the merge

The ultimate goal of GitLab QA was to make it possible to test changes in
merge requests, even before merging a code into the stable / master branch.

### We can run tests against any instance of GitLab

GitLab QA is a click-driven, black-box testing tool. We also use it to run
tests against the staging, and we strive for making to useful for our users
as well.

## How do we use it

Currently we trigger test suite against GitLab Docker images created by Omnibus
nightly.

We also trigger GitLab QA pipelines whenever someone clicks `package-qa` manual
action in a merge request.

## How can you use it

GitLab QA tool is published as a [Ruby Gem](https://rubygems.org/gems/gitlab-qa).

You can install it with `gem install gitlab-qa`. It will expose a `gitlab-qa`
command in your system.

If you want to run the scenarios or develop them on Mac OS, please read
[Mac OS specific documentation](/docs/macos.md) as there are caveats and things
that may work differently.

1. Run tests against a Docker image with GitLab:

    `gitlab-qa Test::Instance::Image CE|EE|<full image address>`

1. Run tests against a Docker image with GitLab and Mattermost:

    `gitlab-qa Test::Integration::Mattermost CE|EE|<full image address>`

1. Run tests agains a Docker image with GitLab Geo:

    `export EE_LICENSE=$(cat /path/to/Geo.gitlab_license)`

    `gitlab-qa Test::Integration::Geo EE`

1. Test update process between two CE or EE subsequent versions:

    `gitlab-qa Test::Omnibus::Update CE|EE|<full image address>`

1. Test upgrade process from CE to EE:

    `gitlab-qa Test::Omnibus::Upgrade CE|<full CE image address>`

1. Run tests against any existing instance:

    `gitlab-qa Test::Instance::Any CE|EE nightly|latest http://your.instance.gitlab`

    For instance, to run it against https://staging.gitlab.com:

    `GITLAB_USERNAME=your_username GITLAB_PASSWORD=your_password gitlab-qa Test::Instance::Any EE latest https://staging.gitlab.com`

### How to add new scenarios

Scenarios (test cases) and scripts to run them are located in
[CE](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/qa) and
[EE](https://gitlab.com/gitlab-org/gitlab-ee/tree/master/qa)
repositories under qa/ directory, so please also check the documents there.

## How does it work?

GitLab QA handles a few scenarios:

### `Test::Omnibus::Image CE|EE|<full image address>`

This scenario only tests that a GitLab Docker container can be run.

This spins up a GitLab Docker container based on the given edition or image:
  - `gitlab/gitlab-ce:nightly` for `CE`
  - `gitlab/gitlab-ee:nightly` for `EE`
  - the given custom image for `<full image address>`

### `Test::Omnibus::Upgrade CE|EE|<full image address>`

This scenario tests that:

- the GitLab Docker container works as expected by running tests against it (see
  `Test::Instance::Image` below)
- that it can be upgraded to a new (`nightly` or custom image) container
- that the new GitLab container still works as expected

### `Test::Instance::Image CE|EE|<full image address>`

This scenario tests that the GitLab Docker container works as expected by
running tests against it.

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the `Test::Instance`
scenario (located under `qa/scenario/test/instance` in the GitLab codebase).

### `Test::Integration::Mattermost CE|EE|<full image address>`

This scenario tests that GitLab instance works as expected when
enabling the embedded Mattermost server (see `Test::Instance::Image`
above).

### `Test::Instance::Any CE|EE|<full image address>`

This scenario tests that the any GitLab instance works as expected by running
tests against it (see `Test::Instance::Image` above).

## Supported environment variables

* `GITLAB_USERNAME` - username to use when signing in to GitLab
* `GITLAB_PASSWORD` - password to use when signing in to GitLab
* `EE_LICENSE` - Enterprise Edition license
* `QA_SCREENSHOTS_DIR` - Path to a directory where screenshots for failing tests
  will be saved (default: `/tmp/gitlab-qa/screenshots`)
* `QA_LOGS_DIR` - Path to a directory where logs will be saved (default:
  `/tmp/gitlab-qa/logs`)
* `DOCKER_HOST` - Docker host to run tests against (default: `http://localhost`)
* `CHROME_HEADLESS` - when running locally, set to `false` to allow Chrome tests to be visible - watch your tests being run

## Contributing

Please see the [contribution guidelines](CONTRIBUTING.md)
