---
hostname: kmkmbp2021
worktree: boatman--ferry-chacha12-75-append--20260515-031908--efb1d3
path: /Users/kris/garden/dispatches/boatman--ferry-chacha12-75-append--20260515-031908--efb1d3
repo: endojs/endo
branch: kriskowal-random-chacha20
role: boatman
status: collected
created_at: 2026-05-15T03:19:08Z
last_heartbeat: 2026-05-15T03:23:18Z
task: "Fast-forward append of two new bot commits onto endojs/endo#3232 from endojs/endo-but-for-bots#75"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
    title: "feat(random,chacha12): factor @endo/random from @endo/chacha12 [resync to actual/kriskowal-random-chacha20]"
  - repo: endojs/endo
    pr: 3232
    role: target
    title: "feat(chacha12): Consolidate PRNG for fuzzing"
---

Per-dispatch worktree triple for the second fast-forward append in this session (after the #109-yarn.lock ferry an hour ago). Two new bot commits (`29979718` and `8eb47912`) to append on top of the upstream tip `f87bf84257`. Upstream is CONFLICTING against master — pre-existing, out of scope for this ferry.

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`). Strip the `(#75)` bot-internal source-PR-number reference from commit `29979718`'s subject during the attribution-rewrite amend.
