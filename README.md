# GitLab end-to-end tests

End-to-end test suite that verifies GitLab as a whole.

## The purpose

GitLab consists of multiple pieces, all configured and packaged by [GitLab Omnibus](gitlab-omnibus).

The purpose of this test suite is to verify that all pieces do integrate well together.

## How we use that

Currently we trigger test suite against GitLab Docker images created by Omnibus nightly.

[gitlab-omnibus]: https://gitlab.com/gitlab-org/omnibus-gitlab
