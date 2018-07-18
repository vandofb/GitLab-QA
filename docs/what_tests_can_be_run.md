# What tests can be run?

## The two types of QA tests

First of all, the first thing to choose is whether you want to run orchestrated
tests (various Docker containers are spun up and tests are run against them,
also from a specific Docker container) or instance-level tests (tests are run
from your host machine against a live instance: a local GDK installation or a staging/production instance).

Ultimately, orchestrated tests run instance-level tests, the difference being
that these tests are run from a specific Docker container instead of from your
host machine.

## Orchestrated tests

Orchestrated tests are run with the `gitlab-qa` binary (from the
`gitlab-qa` gem), or in the `gitlab-qa` project, with the `bin/qa` binary
(useful if you're working on the `gitlab-qa` project itself and want to test
your changes).

These tests spin up Docker containers specifically to run tests against them.
Orchestrated tests are usually used for features that involve external services
or complex setup (e.g. LDAP, Geo etc.), or for generic Omnibus checks (ensure
our Omnibus package works, can be updated / upgraded to EE etc.).

For more details on the internals, please read the
[How it works](./how_it_works.md) documentation.

## Supported environment variables

* `GITLAB_USERNAME` - username to use when signing into GitLab
* `GITLAB_PASSWORD` - password to use when signing into GitLab
* `GITLAB_USER_TYPE` - type of user to use when signing into GitLab: standard (default), ldap
* `GITLAB_LDAP_USERNAME` - LDAP username to use when signing into GitLab
* `GITLAB_LDAP_PASSWORD` - LDAP password to use when signing into GitLab
* `GITLAB_SANDBOX_NAME` - The sandbox group name the test suite is going to use (default: `gitlab-qa-sandbox`)
* `EE_LICENSE` - Enterprise Edition license
* `QA_ARTIFACTS_DIR` - Path to a directory where artifacts (logs and screenshots)
  for failing tests will be saved (default: `/tmp/gitlab-qa`)
* `DOCKER_HOST` - Docker host to run tests against (default: `http://localhost`)
* `CHROME_HEADLESS` - when running locally, set to `false` to allow Chrome tests to be visible - watch your tests being run

### `Test::Instance::Image CE|EE|<full image address>`

This tests that a GitLab Docker container works as expected by running
instance-level tests against it.

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the `Test::Instance`
scenario (located under
[`gitlab-org/gitlab-ce@qa/qa/scenario/test/instance.rb`][test-instance] in the
GitLab CE project).

Example:

```
$ gitlab-qa Test::Instance::Image CE
```

### `Test::Omnibus::Image CE|EE|<full image address>`

This tests that a GitLab Docker container can start without any error.

This spins up a GitLab Docker container based on the given edition or image:

- `gitlab/gitlab-ce:nightly` for `CE`
- `gitlab/gitlab-ee:nightly` for `EE`
- the given custom image for `<full image address>`

Example:

```
$ gitlab-qa Test::Omnibus::Image CE
```

### `Test::Omnibus::Update CE|EE|<full image address>`

This tests that:

- the GitLab Docker `latest` container works as expected by running
  instance-level tests against it (see `Test::Instance::Image` above)
- it can be updated to a new (`nightly` or `<full image address>`) container
- the new GitLab container still works as expected by running
  `Test::Instance::Image` against it

Example:

```
# Update from gitlab/gitlab-ce:latest to gitlab/gitlab-ce:nightly
$ gitlab-qa Test::Omnibus::Update CE

# Update from gitlab/gitlab-ee:latest to gitlab/gitlab-ee:nightly
$ gitlab-qa Test::Omnibus::Update EE

# Update from gitlab/gitlab-ce:latest to gitlab/gitlab-ce:my-custom-tag
$ gitlab-qa Test::Omnibus::Update gitlab/gitlab-ce:my-custom-tag
```

### `Test::Omnibus::Upgrade CE|<full image address>`

This tests that:

- the GitLab Docker container works as expected by running instance-level tests
  against it (see `Test::Instance::Image` above)
- it can be upgraded to a corresponding EE container
- the new GitLab container still works as expected by running
  `Test::Instance::Image` against it

Example:

```
# Ugrade from gitlab/gitlab-ce:nightly to gitlab/gitlab-ee:nightly
$ gitlab-qa Test::Omnibus::Upgrade CE

# Ugrade from gitlab/gitlab-ce:my-custom-tag to gitlab/gitlab-ee:my-custom-tag
$ gitlab-qa Test::Omnibus::Upgrade gitlab/gitlab-ce:my-custom-tag
```

### `Test::Integration::Geo EE|<full image address>`

This tests that two GitLab Geo instances work as expected.

The scenario spins up a primary and secondary GitLab Geo nodes, and verifies
that the replications (repository, attachments, project rename etc.) work as
expected.

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`QA::EE::Scenario::Test::Geo` scenario (located under
[`gitlab-org/gitlab-ee@qa/qa/ee/scenario/test/geo.rb`][test-geo] in the GitLab
EE project).

**Required environment variables:**

- `EE_LICENSE`: A valid EE license.

Example:

```
$ export EE_LICENSE=$(cat /path/to/Geo.gitlab_license)
$ gitlab-qa Test::Integration::Geo EE
```

[test-geo]: https://gitlab.com/gitlab-org/gitlab-ee/blob/master/qa/qa/ee/scenario/test/geo.rb

### `Test::Integration::LDAP CE|EE|<full image address>`

This tests that a GitLab instance works as expected with an external
LDAP server.

The scenario spins up an OpenLDAP server, seeds users, and verifies
that LDAP-related features work as expected.

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Integration::LDAP` scenario (located under
[`gitlab-org/gitlab-ce@qa/qa/scenario/test/integration/ldap.rb`][test-integration-ldap]
in the GitLab CE project).

In EE, both the GitLab standard and LDAP credentials are needed:

1. The first is used to login as an Admin to enter in the EE license.
2. The second is used to conduct LDAP-related tasks

**Required environment variables:**

- [For EE only] `EE_LICENSE`: A valid EE license.

Example:

```
$ gitlab-qa Test::Integration::LDAP CE

# For EE
$ export EE_LICENSE=$(cat /path/to/Geo.gitlab_license)

$ gitlab-qa Test::Integration::LDAP EE
```

[test-integration-ldap]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/integration/ldap.rb

### `Test::Integration::Mattermost CE|EE|<full image address>`

This tests that a GitLab instance works as expected when enabling the embedded
Mattermost server (see `Test::Instance::Image` above).

To run tests against the GitLab container, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Integration::Mattermost` scenario (located under
[`gitlab-org/gitlab-ce@qa/qa/scenario/test/integration/mattermost.rb`][test-integration-mattermost]
in the GitLab CE project).

**Required environment variables:**

- [For EE only] `EE_LICENSE`: A valid EE license.

Example:

```
$ gitlab-qa Test::Integration::Mattermost CE

# For EE
$ export EE_LICENSE=$(cat /path/to/Geo.gitlab_license)

$ gitlab-qa Test::Integration::Mattermost EE
```

[test-integration-mattermost]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/integration/mattermost.rb

### `Test::Instance::Any CE|EE|<full image address>:nightly|latest|any_tag http://your.instance.gitlab`

This tests that a live GitLab instance works as expected by running tests
against it.

To run tests against the GitLab instance, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Instance` scenario (located under
[`gitlab-org/gitlab-ce@qa/qa/scenario/test/instance.rb`][test-instance] in the
in the GitLab CE project).

Example:

```
$ export GITLAB_USERNAME=your_username
$ export GITLAB_PASSWORD=your_password

# Runs the QA suite for an instance running GitLab CE 10.8.1
$ gitlab-qa Test::Instance::Any CE:10.8.1-ce https://your.instance.gitlab

# Runs the QA suite for an instance running GitLab EE 10.7.3
$ gitlab-qa Test::Instance::Any EE:10.7.3-ee https://your.instance.gitlab

# You can even pass a gitlab-{ce,ee}-qa image directly
$ gitlab-qa Test::Instance::Any registry.gitlab.com:5000/gitlab/gitlab-ce-qa:v11.1.0-rc12 https://your.instance.gitlab
```

### `Test::Instance::Staging`

This scenario tests that the [`staging.gitlab.com`](https://staging.gitlab.com)
works as expected by running tests against it.

To run tests against the GitLab instance, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Instance` scenario (located under
[`gitlab-org/gitlab-ce@qa/qa/scenario/test/instance.rb`][test-instance] in the
in the GitLab CE project).

**Required environment variables:**

- `GITLAB_QA_ACCESS_TOKEN`: A valid personal access token with the `api` scope.
  This is used to retrieve the version that staging is currently running.
  This can be found in the shared 1Password vault.

**Optional environment variables:**

- `GITLAB_QA_DEV_ACCESS_TOKEN`: A valid personal access token for the
  `gitlab-qa-bot` on `dev.gitlab.org` with the `registry` scope.
  This is used to pull the QA Docker from the Omnibus GitLab `dev` Container Registry.
  If the variable isn't present, the QA image from Docker Hub will be used.
  This can be found in the shared 1Password vault.

Example:

```
$ export GITLAB_QA_ACCESS_TOKEN=your_api_access_token
$ export GITLAB_QA_DEV_ACCESS_TOKEN=your_dev_registry_access_token
$ export GITLAB_USERNAME="gitlab-qa"
$ export GITLAB_PASSWORD="$GITLAB_QA_PASSWORD"

$ gitlab-qa Test::Instance::Staging
```

[test-instance]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/instance.rb

----

[Back to README.md](../README.md)
