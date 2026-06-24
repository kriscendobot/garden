---
ts: 2026-06-09T14:34:57Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--98efa8`) to **re-ferry the rebuilt bots#75** onto endojs/endo#3232. Shape-2 recompute, force-push. Maintainer-directed "re-ferry as-is" despite content divergence on an approved PR.

State: bots#75 rebuilt to 10 commits (all endolinbot, base `4a04d078b` == current endo master, head `32cc335ba`). #3232 head `cc336d40a` (12 commits), **APPROVED by gibson042** (against cc336d40a), MERGEABLE. The rebuilt bots#75 differs from #3232 by 37 lines of REAL content (fast-check test logic: distinctResults Set + deepEqual assertion, runA.length vs Set size; pure-rand v8 adapter docs + designs/random-fast-check references) - not a pure regroup; #3232's 2 extra tip commits (numeric-sep autofix + SECURITY.md) appear folded/superseded in the rebuild.

**Maintainer decision (explicit):** re-ferry as-is. gibson042's approval persists (endo master unprotected) and will now cover the 37 unreviewed lines; the maintainer accepts this and does NOT want a re-review request routed. Recorded for the record.

Boatman brief (Shape 2): fetch origin (exact refs/heads/master = `4a04d078b`); detach at origin/master; cherry-pick bots#75's 10 commits via `refs/pull/75/head` (base == master, clean; if master moved, regenerate yarn.lock); normalize author+committer of all 10 to `Kris Kowal <kriskowal@kriskowal.com>`; strip (#)/Co-Authored-By/Generated-with/Refs trailers; RUN `interpret-trailers --parse` EMPTY on all (watch for Claude trailers); verify net diff matches bots#75 (the rebuilt content, NOT #3232's); force-with-lease against `cc336d40a` to `kriskowal-random-chacha20`; confirm MERGEABLE and report whether gibson042 APPROVED persists; edit cross-link 4637494705 to new head. Do NOT route any re-review request (maintainer declined). `identity_switch_authorized: true`.

Expected report: new #3232 head, force-with-lease, all-Kris-Kowal + trailers-empty, net-diff-matches-rebuilt-bots#75, mergeable + gibson042-approval-state, CI, edited cross-link.
