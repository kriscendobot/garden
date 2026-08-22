---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-c85b88c9
verdict: miss
category: naming
pr: 475
cluster: incomplete-rename-old-name-sweep
cluster_pattern: A rename lands the new identifiers but review does not sweep the whole PR for the old names, so stale references to the pre-rename byte API survive in code.
review_at: 2026-08-18T20:44:02Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4965591929
identity: endojs/endo-but-for-bots#475:review:4965591929
producing_role: builder/fixer campaign
producing_job: endojs-endo-but-for-bots-pr475 campaign
missed_by: stylist rename-discipline backstop and ergonomist naming seat; the gauntlet did not sweep the whole PR for the old byte-API names after the frozenBytes/thawedBytes rename
severity: minor
grounds: |
  PR #475 renamed the byte-immutability API from toBytes/fromBytes to
  frozenBytes/thawedBytes (itself a rename of the earlier thawnBytes). The
  maintainer asked for another whole-PR pass to confirm no stale references to
  the old names survived. The rename TARGET was already decided before this
  comment ("they should have already been replaced"), so completeness of an
  already-directed rename is mechanically checkable from the diff alone: grep the
  PR for the old identifiers and expect zero. The stylist seat cites the
  rename-discipline skill as its backstop, so the panel demonstrably owns this
  check. The maintainer performing the sweep is doing review labor the gauntlet
  should have done. It is minor because a missed call site to a removed export
  would surface as a ReferenceError caught pre-merge, and the cited file
  (packages/ocapn/src/netlayers/websocket.js) plus a PR-wide sweep of changed .js
  on head (affe74453) are now clean of the byte-immutability toBytes/fromBytes
  (the lone BufferReader.fromBytes in syrup/decode.js is an unrelated pre-existing
  API, correctly untouched). This is the code-identifier sibling of the docs-side
  stale-identifier-reference-sweep cluster (member pr475-review-2c700561): the same
  review-capability gap — no systematic old-name/deleted-path sweep against the
  PR's rename map — expressed over code rather than prose. Kept as a distinct
  naming-category cluster because the store binds one category per cluster and the
  taxonomy routes naming to rename-discipline/ergonomist while docs-drift routes to
  archivist; the eventual sensing fix (a whole-PR old-name grep) would unify both.
---

The maintainer asked for another whole-PR pass to make sure no references to the
former byte-immutability functions toBytes/fromBytes remained after they were
renamed to frozenBytes/thawedBytes (earlier thawnBytes). See `comment_url` to
re-fetch the untrusted review text.

The review miss is that a directed rename shipped without the panel sweeping the
whole PR for the old identifiers, leaving the maintainer to request the
completeness check. This is the code-level twin of the docs-side
`stale-identifier-reference-sweep` gap: review samples individual defects instead
of reconciling every changed line against the PR's rename map.
