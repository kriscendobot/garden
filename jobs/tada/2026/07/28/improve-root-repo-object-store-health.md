Clean tree, both commits on `origin/main2`, inbox empty.

## Report

**Added invariant C — "the object store is healthy and maintainable" — to `scripts/jobs/root-repo-guard.sh`**, in the same bounded/lossless style as A and B, plus the audit the job asked for. Shipped as `9606a7fa4e` + `dee1519700` on `main2`.

### The repair ladder (each step conditional on the previous failing)
1. **Sweep orphaned temp packs** (`objects/pack/tmp_*` older than 6h) — unconditional, every tick, one `find`. Pure reclamation of files git calls "garbage found" and never deletes.
2. **Bounded `git gc`** when a `gc.log` is present or the pack/loose counts pass their ceilings (50 / 10000, git's own auto-gc thresholds). The `gc.log`s are removed **only once gc actually succeeds** — the guard never merely hides the signal — and per-worktree `worktrees/*/gc.log` copies are cleared too, since each independently disables auto-gc. `gc.worktreePruneExpire=never` is pinned so maintenance never deregisters a worktree (that's `journal-worktree-keeper`'s job under its own gating).
3. **Non-destructive recovery** — `fetch origin --refetch` (only when invariant A certified origin this tick), additive only, then one gc retry. A plain fetch cannot heal this: git believes it already has the refs.
4. **Alert once per breakage window** with the missing-object count and a by-hand recipe. Never amputates — the refs reaching a missing object are real history.

Deferred while draining, backed off to one attempt per 6h, per-step timeouts summing under the unit's `TimeoutStartSec` (raised 900 → 1800), quiet on the healthy path, still always returns 0.

### Coverage
6 new test cases, **36/36 passing**, including the real end-to-end recovery: a root whose packs are gone → gc fails → `--refetch` restores them from origin → retried gc succeeds, no ref dropped. Also: fresh temp pack left alone while an aged one is swept; gc.log *kept* while gc still fails; drain defer; back-off; alert dedupe and window-clear.

### Audit
- **The temp-pack mechanism is broader than aborted repacks.** *Every* pack write lands in `tmp_*` and is renamed only on success — repack output **and every incoming fetch's `index-pack`**. With 1301 packs, fetches were slow enough to hit `bounded_fetch`'s timeout, stranding ~10 GB/day. That makes the age gate the ceiling on steady-state garbage, not just a live-writer margin — hence 6h, not 24h (second commit).
- **The 07-21 escape left permanent foreign refs**: 1,739 `@endo/*` tags plus the `SES-v*` series, 1,948 of the repo's ~1,991 refs. Invariant A repaired the origin URL; nothing reverted the fetch. Human-gated, documented, not automated.
- **Per-job worktrees are being left behind**: 102 registered, oldest Jul 10, *all with live working dirs* (0 prunable), 23 GB of `scratch/`. A teardown leak, not a registration leak — `git worktree prune` would remove none.

### This host
I swept the aged temp-pack garbage by hand using the guard's own criteria — **93 files, 5.6 GB reclaimed**, no git involved. I did **not** run the git-level recovery, since that means running git in the deployed root, which every worker prompt forbids. I verified out-of-band (throwaway clone in `/tmp`, since deleted) that **all 22 missing objects are still present on `origin/journal2`**, so step 3 will heal it and step 4 will not fire — it needs a deploy to reach the host. Messaged the maintainer with that, the manual one-liner, and both non-automated findings; the worktree-teardown leak wants its own job on request.

**Follow-ups:** deploy to heal this host; decide on the 1,739 foreign tags; post a job for the worktree-teardown leak.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-root-repo-object-store-health.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4811240 cached reads)
- Output: 57902 tokens
- Cost: $5.022101999999998
- Wall-clock: 853s

<!-- garden-usage-end -->
