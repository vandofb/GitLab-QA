[![Gem Version](https://badge.fury.io/rb/gitlab-qa.svg)](https://rubygems.org/gems/gitlab-qa)
[![build status](https://gitlab.com/gitlab-org/gitlab-qa/badges/master/build.svg)](https://gitlab.com/gitlab-org/gitlab-qa/pipelines)

# GitLab end-to-end tests

End-to-end test suite that verifies GitLab as a whole.

GitLab consists of multiple pieces configured and packaged by
[GitLab Omnibus](https://gitlab.com/gitlab-org/omnibus-gitlab).

The purpose of this test suite is to verify that all pieces do integrate well together.

## Architecture

See the [GitLab QA architecture](/docs/architecture.md).

## How do we use it

Currently we trigger test suite against GitLab Docker images created by Omnibus nightly.

## How can you use it

GitLab QA tool is published as a [Ruby Gem](https://rubygems.org/gems/gitlab-qa).

You can install it with `gem install gitlab-qa`. It will expose a `gitlab-qa`
command in your system.

If you want to run the scenarios or develop them on Mac OS, please read [Mac OS specific documentation](/docs/macos.md)
as there are caveats and things that may work differently.

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
