---
ts: 2026-06-05T04:31:50Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - entries/2026/06/05/042958Z-dispatch-liaison-0de86e.md
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo-but-for-bots/pull/411#discussion_r3360364191
  - https://github.com/endojs/endo-but-for-bots/pull/411#discussion_r3360375542
---

# result: fixer — #411 run browser-test on all PRs regardless of base

Addressed kriskowal's CHANGES_REQUESTED review `4433356995` on PR
endojs/endo-but-for-bots#411 (single inline at
`.github/workflows/browser-test.yml:6`, comment `3360364191`).

## Trigger config change

Old:

```yaml
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]
  schedule:
    - cron: '0 0 * * *'
```

New:

```yaml
on:
  push:
    branches: [master]
  pull_request:
  schedule:
    - cron: '0 0 * * *'
```

The `pull_request` trigger's `branches: [master]` filter was the
reason the workflow was not running on PRs against non-master
bases (the `llm` branch, frozen-base snapshots like
`master-07aff33`). Dropping the filter lets the workflow run on
every PR regardless of base. The `push:` trigger keeps its
`branches: [master]` filter so only landed-on-master pushes still
run the headline gate.

## New head SHA

`467b6f1cb9c249351c1deddba47a9caa86cdfef9` (pushed on top of
`56c3e9ddb`; regular append, no force).

## Inline reply ID

`3360375542` on parent comment `3360364191`. Visible at
https://github.com/endojs/endo-but-for-bots/pull/411#discussion_r3360375542.

## Refetch note

Local HEAD on dispatch start was `37440d0e2`; the dispatch brief
flagged refetch and the branch had moved to `56c3e9ddb`. Reset to
the current remote head before editing.

Self-improvement: nothing this time.
