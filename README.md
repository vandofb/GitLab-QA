[![Gem Version](https://badge.fury.io/rb/gitlab-qa.svg)](https://rubygems.org/gems/gitlab-qa)
[![build status](https://gitlab.com/gitlab-org/gitlab-qa/badges/master/build.svg)](https://gitlab.com/gitlab-org/gitlab-qa/pipelines)

# GitLab end-to-end tests

End-to-end test suite that verifies GitLab as a whole.

GitLab consists of multiple pieces configured and packaged by
[GitLab Omnibus](https://gitlab.com/gitlab-org/omnibus-gitlab).

The purpose of this test suite is to verify that all pieces do integrate well together.

## How do we use it

Currently we trigger test suite against GitLab Docker images created by Omnibus nightly.

## How can you use it

GitLab QA tool is published as a [Ruby Gem](https://rubygems.org/gems/gitlab-qa).

You can install it with `gem install gitlab-qa`. It will expose a `gitlab-qa`
command in your system.

1. Run tests against a Docker image with GitLab:

    `gitlab-qa Test::Instance::Image CE|EE`

1. Test upgrade process:

    `gitlab-qa Test::Omnibus::Upgrade CE|EE

1. Run tests against any existing instance:

    `gitlab-qa Test::Instance::Any nightly|latest CE|EE http://your.instance.gitlab`

## Supported environment variables

* `GITLAB_USERNAME` Username to use when signing in to GitLab
* `GITLAB_PASSWORD` Password to use when signing in to GitLab
* `EE_LICENSE` Enterprise Edition license
