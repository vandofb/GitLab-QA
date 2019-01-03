# Run QA tests against a remote Selenium grid

The QA tests have the ability to be ran against a local or remote grid.

I.e, if you have a Selenium server set up at http://localhost:4444 or if you have a SauceLabs / BrowserStack account.

## Variables

| Variable                  | Description                                                    | Default  | Example(s)                     |
|---------------------------|----------------------------------------------------------------|----------|--------------------------------|
| QA_BROWSER                | Browser to run against                                         | "chrome" | "chrome" "firefox"             |
| QA_REMOTE_GRID_PROTOCOL   | Protocol to use                                                | "http"   | "http" "https"                 |
| QA_REMOTE_GRID            | Remote grid to run tests against                               |          | "localhost:3000" "provider:80" |
| QA_REMOTE_GRID_USERNAME   | Username to specify in the remote grid. "USERNAME@provider:80" |          |                                |
| QA_REMOTE_GRID_ACCESS_KEY | Key/Token paired with `QA_REMOTE_GRID_USERNAME`                |          |                                |

## Examples

*Run QA Smoke Tests against firefox on SauceLabs*

```bash
$ QA_BROWSER=firefox \
  QA_REMOTE_GRID=ondemand.saucelabs.com:80 \
  QA_REMOTE_GRID_USERNAME=user \
  QA_REMOTE_GRID_ACCESS_KEY=privatetoken \
  gitlab-qa Test::Instance::All --tags smoke
```
