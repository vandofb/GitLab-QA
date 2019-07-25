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
`gitlab-qa` gem), or in the `gitlab-qa` project, with the `exe/gitlab-qa` binary
(useful if you're working on the `gitlab-qa` project itself and want to test
your changes).

These tests spin up Docker containers specifically to run tests against them.  The following images may be used, depending on the test:
* `nightly` image, which is released daily and reflects the master branch at the time of release
* `latest` image, which reflects the latest released stable version
* custom images

Orchestrated tests are usually used for features that involve external services
or complex setup (e.g. LDAP, Geo etc.), or for generic Omnibus checks (ensure
our Omnibus package works, can be updated / upgraded to EE etc.).

For more details on the internals, please read the
[How it works](./how_it_works.md) documentation.

## Supported GitLab environment variables

* `GITLAB_USERNAME` - username to use when signing into GitLab
* `GITLAB_PASSWORD` - password to use when signing into GitLab
* `GITLAB_FORKER_USERNAME` - username to use for forking a project
* `GITLAB_FORKER_PASSWORD` - password to use for forking a project
* `GITLAB_QA_USERNAME_1` - username available in environments where signup is disabled
* `GITLAB_QA_PASSWORD_1` - password for `GITLAB_QA_USERNAME_1` available in environments where signup is disabled (e.g. staging.gitlab.com)
* `GITLAB_QA_USERNAME_2` - another username available in environments where signup is disabled
* `GITLAB_QA_PASSWORD_2` - password for `GITLAB_QA_USERNAME_2` available in environments where signup is disabled (e.g. staging.gitlab.com)
* `GITLAB_LDAP_USERNAME` - LDAP username to use when signing into GitLab
* `GITLAB_LDAP_PASSWORD` - LDAP password to use when signing into GitLab
* `GITLAB_ADMIN_USERNAME` - Admin username to use when adding a license
* `GITLAB_ADMIN_PASSWORD` - Admin password to use when adding a license
* `GITLAB_SANDBOX_NAME` - The sandbox group name the test suite is going to use (default: `gitlab-qa-sandbox`)
* `GITLAB_QA_ACCESS_TOKEN` -  A valid personal access token with the `api` scope.
  This is used for API access during tests, and is used in the
  [`Test::Instance::Staging`](#testinstancestaging) scenario to retrieve the
  version that staging is currently running. An existing token that is valid on
  staging can be found in the shared 1Password vault.
* `GITLAB_QA_ADMIN_ACCESS_TOKEN` - A valid personal access token with the `api` scope
  from a user with admin access. Used for API access as an admin during tests.
* `EE_LICENSE` - Enterprise Edition license
* `QA_ARTIFACTS_DIR` - Path to a directory where artifacts (logs and screenshots)
  for failing tests will be saved (default: `/tmp/gitlab-qa`)
* `DOCKER_HOST` - Docker host to run tests against (default: `http://localhost`)
* `CHROME_HEADLESS` - when running locally, set to `false` to allow Chrome tests to be visible - watch your tests being run
* `QA_COOKIES` - optionally set to "cookie1=value;cookie2=value" in order to add a cookie to every request. This can be used to set the canary cookie by setting it to "gitlab_canary=true"
* `QA_DEBUG` - set to `true` to verbosely log page object actions. Note: if enabled be aware that sensitive data might be logged. If an input element has a QA selector with `password` in the name, data entered into the input element will be masked. If the element doesn't have `password` in its name it won't be masked.
* `QA_LOG_PATH` - path to output debug logging to. If not set logging will be output to STDOUT
* `QA_CAN_TEST_GIT_PROTOCOL_V2` - set to `false` to skip tests that require Git protocol v2 if your environment doesn't support it.
* `QA_SKIP_PULL` - set to `true` to skip pulling docker images (e.g., to use one you built locally).
* `GITHUB_OAUTH_APP_ID` - Client ID for GitHub OAuth app. See https://docs.gitlab.com/ce/integration/github.html for steps to generate this token.
* `GITHUB_OAUTH_APP_SECRET` - Client Secret for GitHub OAuth app. See https://docs.gitlab.com/ce/integration/github.html for steps to generate this token.
* `GITHUB_USERNAME` - Username for authenticating with GitHub.
* `GITHUB_PASSWORD` - Password for authenticating with GitHub.

## [Supported Remote Grid environment variables](./running_against_remote_grid.md)

## Running tests with a feature flag enabled

It is possible to enable a feature flag before running tests. See the [QA
framework documentation](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/README.md#running-tests-with-a-feature-flag-enabled) for details.

## Examples

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

### `Test::Integration::LDAPNoTLS CE|EE|<full image address>`

This tests that a GitLab instance works as expected with an external
LDAP server with TLS not enabled.

The scenario spins up an OpenLDAP server, seeds users, and verifies
that LDAP-related features work as expected.

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Integration::LDAPNoTLS` scenario (located under
[`gitlab-org/gitlab-ce@qa/qa/scenario/test/integration/ldap_no_tls.rb`][test-integration-ldap-no-tls]
in the GitLab CE project).

In EE, both the GitLab standard and LDAP credentials are needed:

1. The first is used to login as an Admin to enter in the EE license.
2. The second is used to conduct LDAP-related tasks

**Required environment variables:**

- [For EE only] `EE_LICENSE`: A valid EE license.

Example:

```
$ gitlab-qa Test::Integration::LDAPNoTLS CE

# For EE
$ export EE_LICENSE=$(cat /path/to/Geo.gitlab_license)

$ gitlab-qa Test::Integration::LDAPNoTLS EE
```

[test-integration-ldap-no-tls]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/integration/ldap_no_tls.rb

### `Test::Integration::LDAPTLS CE|EE|<full image address>`

This tests that a TLS enabled GitLab instance works as expected with an external TLS enabled LDAP server.
The self signed TLS certificate used for the Gitlab instance and the private key is located at: [`gitlab-org/gitlab-qa@tls_certificates/gitlab`][test-integration-ldap-tls-certs]

The certificate was generated with openssl using this command:
```
openssl req -x509 -newkey rsa:4096 -keyout gitlab.test.key -out gitlab.test.crt -days 3650 -nodes -subj "/C=US/ST=CA/L=San Francisco/O=GitLab/OU=Org/CN=gitlab.test"
```

The scenario spins up a TLS enabled OpenLDAP server, seeds users, and verifies
that LDAP-related features work as expected.

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Integration::LDAPTLS` scenario (located under
[`gitlab-org/gitlab-ce@qa/qa/scenario/test/integration/ldap_tls.rb`][test-integration-ldap-tls]
in the GitLab CE project).

In EE, both the GitLab standard and LDAP credentials are needed:

1. The first is used to login as an Admin to enter in the EE license.
2. The second is used to conduct LDAP-related tasks

**Required environment variables:**

- [For EE only] `EE_LICENSE`: A valid EE license.

Example:

```
$ gitlab-qa Test::Integration::LDAPTLS CE

# For EE
$ export EE_LICENSE=$(cat /path/to/Geo.gitlab_license)

$ gitlab-qa Test::Integration::LDAPTLS EE
```

[test-integration-ldap-tls]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/integration/ldap_tls.rb
[test-integration-ldap-tls-certs]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/tls_certificates/gitlab

### `Test::Integration::GroupSAML EE|<full image address>`

This tests that Group SAML login works as expected with an external SAML identity provider (idp).

This scenario spins up a SAML idp provider and verifies that a user is able to login to a group
in GitLab that has SAML SSO enabled.

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Integration::GroupSAML` scenario (located under [`gitlab-org/gitlab-ce@qa/qa/ee/scenario/test/integration/group_saml.rb`][test-integration-group-saml] in the GitLab EE project).

[test-integration-group-saml]: https://gitlab.com/gitlab-org/gitlab-ee/blob/master/qa/qa/ee/scenario/test/integration/group_saml.rb

**Required environment variables:**

- `EE_LICENSE`: A valid EE license.

Example:

```
$ export EE_LICENSE=$(cat /path/to/Geo.gitlab_license)

$ gitlab-qa Test::Integration::GroupSAML EE
```

### `Test::Integration::InstanceSAML CE|EE|<full image address>`

This tests that a GitLab instance works as expected with an external
SAML identity provider (idp).

This scenario spins up a SAML idp provider and verifies that a user is able to login to GitLab instance
using SAML.

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Integration::InstanceSAML` scenario (located under [`gitlab-org/gitlab-ce@qa/qa/scenario/test/integration/instance_saml.rb`][test-integration-instance-saml] in the GitLab CE project).

[test-integration-instance-saml]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/integration/instance_saml.rb

**Required environment variables:**

- [For EE only] `EE_LICENSE`: A valid EE license.

Example:

```
$ gitlab-qa Test::Integration::InstanceSAML CE

# For EE
$ export EE_LICENSE=$(cat /path/to/Geo.gitlab_license)

$ gitlab-qa Test::Integration::InstanceSAML EE
```

### `Test::Integration::OAuth CE|EE|<full image address>`

This tests that users can sign in to GitLab instance using external OAuth services.

The tests currently integrate with the following OAuth service providers:
* GitHub

To run tests against the GitLab containers, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Integration::OAuth` scenario (located under [`gitlab-org/gitlab-ce@qa/qa/scenario/test/integration/oauth.rb`](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/integration/oauth.rb) in the GitLab CE project).

**Required environment variables:**

- [For EE only] `EE_LICENSE`: A valid EE license.
- `GITHUB_OAUTH_APP_ID`: Client ID for GitHub OAuth app. This can be found in the shared 1Password vault.
- `GITHUB_OAUTH_APP_SECRET`: Client Secret for GitHub OAuth app. This can be found in the shared 1Password vault.
- `GITHUB_USERNAME`: Username for authenticating with GitHub. This can be found in the shared 1Password vault.
- `GITHUB_PASSWORD`: Password for authenticating with GitHub. This can be found in the shared 1Password vault.

Example:

```
$ export GITHUB_OAUTH_APP_ID=your_github_oauth_client_id
$ export GITHUB_OAUTH_APP_SECRET=your_github_oauth_client_secret
$ export GITHUB_USERNAME=your_github_username
$ export GITHUB_PASSWORD=your_github_password

$ gitlab-qa Test::Integration::OAuth CE

# For EE
$ export EE_LICENSE=$(cat /path/to/gitlab_license)

$ gitlab-qa Test::Integration::OAuth EE
```

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

### `Test::Instance::Production`

This scenario functions the same as `Test::Instance::Staging`
but will run tests against [`gitlab.com`](https://gitlab.com).

In release 11.6 it is possible to test against the canary stage of production
by setting `QA_COOKIES=gitlab_canary=true`. This adds a cookie
to all web requests which will result in them being routed
to the canary fleet.

### `Test::Instance::Preprod`

This scenario functions the same as `Test::Instance::Staging`
but will run tests against [`pre.gitlab.com`](https://pre.gitlab.com).

Note that [`pre.gitlab.com`](https://pre.gitlab.com) is used as an Interim
Performance Testbed and [will be replaced with the actual testbed in the future](https://gitlab.com/groups/gitlab-com/gl-infra/-/epics/60).

### `Test::Instance::Smoke`

This scenario will run a limited amount of tests selected from the test suite tagged by `:smoke`.
Smoke tests are quick tests that ensure that some basic functionality of GitLab works.

To run tests against the GitLab instance, a GitLab QA (`gitlab/gitlab-qa`)
container is spun up and tests are run from it by running the
`Test::Instance::Smoke` scenario (located under
[`gitlab-org/gitlab-ce@qa/qa/scenario/test/smoke.rb`][smoke-instance] in the
in the GitLab CE project).

Example:

```
$ gitlab-qa Test::Instance::Smoke ee:<tag> https://staging.gitlab.com
```

----

[Back to README.md](../README.md)

[test-instance]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/instance/all.rb
[smoke-instance]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/qa/qa/scenario/test/instance/smoke.rb
