---
role: shepherd
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# shepherd directive on endojs/endo-but-for-bots PR #475

Map: **shepherd #475** → drive CI to green on the PR head.

Context: the gauntlet on #475 (campaign "land PR #475 immutable byte arrays")
converged with no production must-fix. CI is green except a single flaked leg,
`cover (24.18.0, ubuntu-latest)`, which failed on `@endo/thixotrope`'s
durable-worker-session suite with socket-teardown races
(`ERR_STREAM_WRITE_AFTER_END` / `ECONNRESET`). The identical `test:c8` suite
passes deterministically locally (30 tests, RC 0), and the PR's thixotrope
change is a pure `bytesToImmutable`→`frozenBytes` symbol swap — a known-shape
flake, not a PR regression.

Task: once the current CI run completes, re-run the failed leg(s) and confirm
the PR reaches all-green (only re-run flaked legs; do NOT touch the PR diff).
If a re-run reveals a genuine, reproducible failure attributable to the diff,
report it rather than masking it with further re-runs. Leave the PR non-draft
in the maintainer/@erights review queue.

PR: https://github.com/endojs/endo-but-for-bots/pull/475
