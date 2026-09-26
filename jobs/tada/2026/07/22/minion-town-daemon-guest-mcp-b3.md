Implemented B3 and opened https://github.com/kriscendobot/minion.town/pull/16 (commit `6649017`).

- Enabled `ENDO_SOCK` and explicit `endo-daemon` group access for `minion-mcp`.
- Added daemon-before-app continuous deployment ordering; OCapN demo lane remains untouched.
- Corrected deployment to build native `better-sqlite3` on the ARM64 target from the pinned source artifact.
- Validated typecheck, build, 29 targeted daemon-guest tests, shell/Node syntax, and workflow YAML ordering.

Live deployment, PKCE write/read, daemon-owner observation, and restart-persistence evidence were not run: this environment has no AWS CLI or SSM credentials. Also, `mcp/guest` Cognito/role/client grant remains B4 work, so PKCE guest calls cannot succeed under B3 alone.
