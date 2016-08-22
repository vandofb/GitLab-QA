# GitLab end-to-end tests

End-to-end test suite that verifies GitLab as a whole.

GitLab consists of multiple pieces configured and packaged by
[GitLab Omnibus](https://gitlab.com/gitlab-org/omnibus-gitlab).

The purpose of this test suite is to verify that all pieces do integrate well together.

## How we use it

Currently we trigger test suite against GitLab Docker images created by Omnibus nightly.
