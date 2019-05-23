# How it works

## Architecture

For a visual architecture explanation, please read the
[GitLab QA architecture](./architecture.md) documentation.

## What happens when you run `gitlab-qa Test::Instance::Image CE`

1. `exe/gitlab-qa` calls [`.perform`][instance-image] on the fully qualified constant
  `Gitlab::QA::Scenario::` + the scenario name, e.g. `QA::Scenario::Test::Instance::Image`
1. A new `gitlab-ce` container is started with `Component::Gitlab.perform`
1. Then `Component::Specs.perform` is called, which starts a `gitlab/gitlab-qa`
  container (from [`gitlab-org/gitlab-ce@qa/Dockerfile`][gitlab-dockerfile])
  and pass it the instance-level scenario to run (e.g. `Test::Instance` for
  [`gitlab-org/gitlab-qa@lib/gitlab/qa/scenario/test/instance/image.rb`][instance-image]),
  then the address of the live instance to be tested, and optional extra arguments.
1. Within the `gitlab/gitlab-qa` container, these arguments are passed to `bin/test` (since it's
  the
  [`ENTRYPOINT` defined at `gitlab-org/gitlab-ce@qa/Dockerfile`][gitlab-dockerfile]),
  and then to `bin/qa`.
1. `bin/qa` then calls `.launch!` on the fully qualified constant `QA::Scenario::` +
  the scenario name, e.g. `QA::Scenario::Test::Instance`, and ultimately calls
  [`.perform`][instance]
1. The `.perform` method [saves the instance address for later][instance], then sets up an
  `RSpec::Core::Runner`, pass it the extra arguments,
  [configure the `Capybara` browser environment][runner],
  and [starts the actual `RSpec` run][runner].

[instance-image]: https://gitlab.com/gitlab-org/gitlab-qa/blob/master/lib/gitlab/qa/scenario/test/instance/image.rb
[gitlab-dockerfile]: https://gitlab.com/gitlab-org/gitlab-ce/blob/60f51cd20af5db8759c31c32a9c45db5b5be2199/qa/Dockerfile
[instance]: https://gitlab.com/gitlab-org/gitlab-ce/blob/60f51cd20af5db8759c31c32a9c45db5b5be2199/qa/qa/scenario/test/instance.rb
[runner]: https://gitlab.com/gitlab-org/gitlab-ce/blob/60f51cd20af5db8759c31c32a9c45db5b5be2199/qa/qa/specs/runner.rb

----

[Back to README.md](../README.md)
