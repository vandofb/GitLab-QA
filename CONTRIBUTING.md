## Developer Certificate of Origin + License

By contributing to GitLab B.V., You accept and agree to the following terms and
conditions for Your present and future Contributions submitted to GitLab B.V.
Except for the license granted herein to GitLab B.V. and recipients of software
distributed by GitLab B.V., You reserve all right, title, and interest in and to
Your Contributions. All Contributions are subject to the following DCO + License
terms.

[DCO + License](https://gitlab.com/gitlab-org/dco/blob/master/README.md)

_This notice should stay as the first item in the CONTRIBUTING.md file._

## Releasing a new version

To release a new version you can follow these steps:

1. Bump the [version](lib/gitlab/qa/version.rb#L3) using [semantic versioning](https://semver.org/).
   * You may find it helpful to fill out the description of the merge request 
     using the same format as for existing [tags](https://gitlab.com/gitlab-org/gitlab-qa), as this will help in
     step 3.
2. Pull the change locally and run `bundle exec rake release` to build, tag,
   and push the new version to [RubyGems](https://rubygems.org/gems/gitlab-qa).
   * Note: you will need an account on [RubyGems.org](https://rubygems.org/)
     and permission to push `gitlab-qa`. Open an issue in this project to
     request access.
3. Update the release notes for the new [tag](https://gitlab.com/gitlab-org/gitlab-qa).
4. If any pipelines are locked to a specific version, update them if required.
