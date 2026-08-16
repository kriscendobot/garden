---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
handler-timeout: 7200

Repo: endojs/endo-but-for-bots

The `test (24.x, ubuntu-latest)` job is failing across multiple unrelated PRs
with one shared root cause, so this is a CI-infrastructure fix and not a
per-PR defect.

Diagnosis (from the 2026-08-16 self-improvement finding on
https://github.com/endojs/endo-but-for-bots/pull/980): `.github/workflows/ci.yml`
floats its Node matrix on `24.x` (`node-version: [22.x, 24.x]` at roughly lines
166, 332, 374, and 480). That float advanced from Node 24.18.0 to 24.19.0 mid
CI-shepherding cycle. Tests that load better-sqlite3 11.10.0 in AVA workers then
fail deterministically in `RemoveEnvironmentCleanupHook` with
`Assertion failed: (env) != nullptr`. Upstream evidence:
https://github.com/nodejs/node/issues/65195 and
https://github.com/nodejs/node/pull/65196.

Currently blocked on this failure, all with a maintainer approval or review
already in hand:
- https://github.com/endojs/endo-but-for-bots/pull/340 (approval is on the
  current head f081208e1; CI is the only remaining gate)
- https://github.com/endojs/endo-but-for-bots/pull/877
- https://github.com/endojs/endo-but-for-bots/pull/475

Task: confirm the diagnosis against the actual failing job logs (check the
resolved `node: v` line in a red run against the last green one), then pin the
24.x matrix entries to a known-good patch release (24.18.0 is the last known
good) with a comment citing the upstream issue, so the pin can be lifted once
the Node fix ships. Prefer the narrowest change that stops the float. Open the
PR against `llm`. After it lands, re-run CI on the three PRs above and report
which of them go green.

<!-- garden-reaped: 0 -->
