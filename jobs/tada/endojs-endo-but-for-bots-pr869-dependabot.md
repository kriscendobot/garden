Botany review of `endojs/endo-but-for-bots` PR #869 complete.

## Verdict: MERGE-NOW — executed, correctly blocked at the maintainer-approval gate

**Step 1 supersession check:** #869 is the live happy-dom PR and the only open one (its predecessor #562 was closed as superseded by a peer, who handed me the diligence via the bus). Full review warranted.

**Pre-flight clean:** diff touches only three `package.json` files and `yarn.lock`, no source.

**Why MERGE-NOW rather than embargo** — this is a vulnerability repair. The version *in the tree* (15.11.7) is affected by three advisories, all fixed at or below 20.11.0: GHSA-37j7-fg3j-429f / CVE-2025-61927 (**CRITICAL**, VM context escape to RCE), GHSA-6q6h-j7hj-3r64 (HIGH), GHSA-w4gp-fjgq-3q4g (HIGH). OSV returns nothing for 20.11.0. It also independently satisfies the 7-day window (published 2026-07-18, 10 days).

**Regression evidence, executed not inferred.** I ran the advisory's own reproducer against both versions in isolated `npm i --ignore-scripts` installs with the payload reduced to reading `process.pid`:
- 15.11.7 → `ESCAPED pid=1264947`
- 20.11.0 → `(script never ran -- JS evaluation disabled)`

That also surfaced a **downstream behavior change** no version comparison would have caught: 20.x disables JavaScript evaluation by default, so a test relying on happy-dom running an inline `<script>` now gets a silent no-op. Nothing in the repo depends on it today.

**Transitive set (8 entries) all clean.** New runtime packages `buffer-image-size` 0.6.4 (dormant since 2018, single maintainer) read in full: 500 lines of pure magic-byte parsing, no fs/net/exec. No install hooks or `bin` on any package. The one `child_process` use (`SyncFetch`) is **pre-existing in 15.11.7**, not introduced. Install verified with scripts disabled and `--immutable`.

**CI + local:** 22/22 check-runs green at `3b4c181`. The legacy `/status` endpoint returned the vacuous `pending, total_count=0` the role file warns about. Because it's a five-major jump I also ran all three consumer suites locally — **895 tests passing** (chat 800, space-file-explorer 80, markmdown 15).

**Disposition executed** through `ci-wait-merge.sh --merge`: it re-confirmed CI green, then refused with `merge blocked: no maintainer approval (reviewDecision=none)`. The PR has no review at all. Not merged, and not merged over the gate.

## Scope caveat I want to state plainly
happy-dom is a **devDependency** (test-time DOM emulation). The advisories are real and the in-tree version is affected, but this is not a live production RCE exposure. The repair is free and fully green, so there's no reason to keep carrying it — I just didn't want the CRITICAL label to oversell it.

## Artifacts
- Verdict comment: `endojs/endo-but-for-bots#869` [issuecomment-5101396827](https://github.com/endojs/endo-but-for-bots/pull/869#issuecomment-5101396827)
- Ledger: `entries/2026/07/28/074848Z-message-gardener-e0f446.md`
- Maintainer inbox: `20260728T074750Z-a00ff0`
- `main2` `de900ff1ad` — botanist field note: run the advisory reproducer against both versions on a CVE repair (the `regression-evidence` skill is shaped for a test-in-a-diff and doesn't map onto a dependency bump, so the botany form was unwritten)

## Follow-ups for you
1. **#869 needs one approval and nothing else.** That is the entire remaining distance.
2. **Unrelated host-health finding** (inbox `20260728T075054Z-2de24d`): auto-gc is wedged on the shared garden repo — object `9ad05cc3...` is referenced but genuinely missing, so `repack` aborts on every git command. Refs, fetch, push and journal sync all work normally, so it's slow-burn rather than urgent. I deliberately did **not** attempt a repair, since `gc`/`fsck`/reflog-expiry on the root repo is the reserved class; it wants a deliberate hand with the fleet drained. `garden-root-repo-guard` checks origin/HEAD invariants, not object-store health, so it likely won't catch this.
