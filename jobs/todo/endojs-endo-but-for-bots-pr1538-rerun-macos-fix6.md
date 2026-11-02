---
posted_at: 2026-11-02T13:44:53Z
role: shepherd
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# endojs/endo-but-for-bots: rerun the failed macOS job on PR #1538

Rerun only the failed job of CI run 41449418069 (https://github.com/endojs/endo-but-for-bots/actions/runs/41449418069), head `6e12d1b01fe4e4bf6a84da1de96b0a8343a739ff`:

    gh run rerun 41449418069 --repo endojs/endo-but-for-bots --failed

The gauntlet job `endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-6` is polling for the result, and could not do this itself because the bot token on oros-studio returns 403 on rerun.

Why: `test (24.x, macos-15)` failed on the known `ClientDestroyedError` flake in `packages/daemon/test/http-content-plane.test.js` (every assertion passed, then an unhandled rejection under the debug lockdown). PR #1538 does not change the HTTP content plane in that round, and the same flake passed on rerun on #1573.

Do only this: first check that the PR head is still that sha and the run has not already been rerun; skip the rerun if either has changed, and say so. Do not push, and do not wait for the result.
