---
ts: 2026-06-02T22:40:16Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/204834Z-result-liaison-444522.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--bae5e2`) to **amend** the single `Feedback responses` commit on endojs/endo#3294 so the `packages/benchmark` subtree byte-matches the LIVE bot mirror.

Why: the prior feedback append (dispatch `f9441a`) copied the 3 benchmark files from a STALE mirror head (`a66f3c344`). The mirror has since advanced to `e22369065`, which renamed the engine cache `.bench-engines` -> `.engines` (and related tweaks). So #3294's benchmark content lags the live mirror. The maintainer caught this ("these should differ due to .bench-engines being reverted to .engines").

Scope (verified against live mirror `e22369065` vs #3294 `811f1ffd4`): exactly 3 PR-scope files differ — `packages/benchmark/{README.md, install-engines.sh, run-tests.sh}`. `benchmark/package.json` and `hex/test/run-benches.sh` already match. The other 27 differing files are legitimate endo-master vs bots-master BASE divergence (ses/permits/temporal, #3292 changesets, ci.yml, yarn.lock, etc.) and MUST NOT be touched (reverting them would undo endo history in the PR). Target benchmark subtree hash: `40192d94edb5ec3934d717dbebc450e8ce3bbf06`.

Boatman brief: detach at #3294 head `811f1ffd4`; `git checkout e22369065 -- packages/benchmark/README.md packages/benchmark/install-engines.sh packages/benchmark/run-tests.sh`; confirm ONLY those 3 files changed and `HEAD:packages/benchmark` == `40192d94...`; `git commit --amend` keeping author+committer `Kris Kowal <kriskowal@kriskowal.com>` and the `Feedback responses` subject (note .engines cache in body if natural); verify parents unchanged (`HEAD~1`==`d6dc75964`, `HEAD~2`==`4afa6af31`) so ONLY the tip Feedback commit's SHA changes; trailers empty; force-push WITH LEASE against `811f1ffd4`. gibson042's COMMENTED review is anchored to `d6dc75964` (unchanged, still reachable) so it survives. Update cross-link comment 4599031642 to the new head. `identity_switch_authorized: true`.

Note the root tree will still differ from the mirror by the 27 base files; that is expected and correct (the mirror is on a divergent bots base). Only the benchmark subtree is brought into parity.

Expected report: new #3294 head SHA, confirmation only the tip commit changed (parents intact), benchmark subtree hash == 40192d94, force-with-lease push confirmation, mergeable + gibson042-review-survives check, CI status, edited cross-link.
