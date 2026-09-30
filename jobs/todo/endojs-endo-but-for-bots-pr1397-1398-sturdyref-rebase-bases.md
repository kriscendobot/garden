---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
pr: https://github.com/endojs/endo-but-for-bots/pull/1397
---

# Move #1397/#1398 PR bases onto the restacked frozen bases, confirm #1398 lint

Handoff from fix-endojs-endo-but-for-bots-pr1396-captp-locate-ts2339. Host
oros-studio-garden-ce242c49's bot PAT gets a 403 on updatePullRequest for endojs, so
this job is pinned to endolin. The branches are ALREADY restacked and pushed; only
the PR `base` fields need to move:

    gh pr edit 1397 -R endojs/endo-but-for-bots --base build/sturdyref-captp-construct-4330ae6
    gh pr edit 1398 -R endojs/endo-but-for-bots --base build/sturdyref-ocapn-enliven-b072952

State: #1396 head build/sturdyref-captp-construct = 4330ae6f0 (TS2339 fix on
packages/captp/test/sturdyref.test.js). #1397 head build/sturdyref-ocapn-enliven =
b0729525d (frozen base build/sturdyref-captp-construct-4330ae6 = 4330ae6f0).
#1398 head build/sturdyref-daemon-formula = a79dcfc20 (frozen base
build/sturdyref-ocapn-enliven-b072952 = b0729525d). If a head moved since, re-freeze
the base at the lower layer's current tip instead.

Then watch #1398's CI (poll the Actions runs API if statusCheckRollup is unreadable)
and confirm the lint job (root `tsc -p tsconfig.json --noEmit`, workspace
lint:types, build API docs) goes green. If it fails, fix on the lowest affected
layer and restack upward.
