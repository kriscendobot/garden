---
ts: 2026-06-06T05:11:50Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--a1ec64`) to re-ferry bots#75 onto endojs/endo#3232 (@endo/random + @endo/chacha12 PRNG consolidation). Shape-2 recompute to clear #3232's CONFLICTING via a base-drift refresh.

State: bots#75 (head `cbab24e77`, 10 commits, branch `kriskowal-random-chacha12`, MERGEABLE, base sha `5865ff102`) is the "resync to actual" mirror. #3232 (head `71055ef17`, 11 commits, branch `kriskowal-random-chacha20`, CONFLICTING, REVIEW_REQUIRED - gibson042 + kriskowal COMMENTED, NO approval). endo master `4a04d078b`.

Divergence diagnosis (NOT content loss): the 48-line / 1-commit difference is BASE DRIFT. #3232 is on a stale base; bots#75 is on a much newer master where the numeric-separators migration (`0xffff_ffff` vs `0xffffffff`), a fast-check 4 / pure-rand bump, and the evasive-transform JSDoc indent fix have all landed. #3232's extra `style(evasive-transform)` commit is already in current master (verified: master blob == bots#75 blob `337ae9166`), so re-ferrying drops nothing real. The re-ferry brings #3232 current.

Boatman brief (Shape 2): fetch origin (exact refs/heads/master = `4a04d078b`); detach at origin/master; cherry-pick bots#75's 10 commits (`208e4f725`..`cbab24e77`) in order via `refs/pull/75/head`; bots#75 base `5865ff102` lags current master `4a04d078b` by a few commits, so expect minor conflicts (regenerate yarn.lock via `corepack yarn install` rather than carrying bots#75's lockfile commit; resolve any code conflict per conflict-resolution, STOP if non-mechanical); normalize author+committer of all 10 to `Kris Kowal <kriskowal@kriskowal.com>` (9 already Kris Kowal, 1 endolinbot yarn.lock); strip any `(#75)`/Refs/Co-Authored trailers; RUN `interpret-trailers --parse` EMPTY on all; verify net diff matches bots#75 (NOT #3232's stale content); force-with-lease against `71055ef17` to `kriskowal-random-chacha20`; confirm CONFLICTING -> MERGEABLE; create the garden-side cross-link on bots#75 (none exists). `identity_switch_authorized: true`.

Expected report: new #3232 head, force-with-lease, CONFLICTING->MERGEABLE, all-Kris-Kowal + trailers-empty, net-diff-matches-bots#75, conflict-handling outcome, CI, created cross-link.
