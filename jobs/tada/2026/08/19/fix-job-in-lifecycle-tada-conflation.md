The fix is committed and pushed to `main2`. Here is the completion report.

## What I did

Fixed the `job_in_lifecycle()` / directive-identity dedup conflation in the garden job system.

**Root cause confirmed:** `post-job.sh`'s directive-identity dedup called `job_in_lifecycle()`, which counts `tada/` (completed) as "in lifecycle." So a genuinely new directive sharing an identity with an already-completed owner was refused, and the re-point-the-stale-index path its own comment promised was unreachable dead code.

**Checked all three real callers before touching anything** (per the spec's caution):
- `post-job.sh:236` — the dedup site; wants "still ACTIONABLE" = `plan|todo|doin` only. **This was the bug.**
- `complete-job.sh:156` — a handoff successor already in `tada/` is still durable evidence of transfer → genuinely needs tada-inclusive.
- `post-orchestration.sh:202` — a child already in `tada/` is a restart-safe re-post → genuinely needs tada-inclusive.

Because two callers legitimately need the tada-inclusive meaning, I **left `job_in_lifecycle()` untouched** and added a narrower sibling `job_is_active()` (`plan|todo|doin` only), used at the single dedup call site — exactly the spec's item-3 remedy.

## What changed

- `scripts/jobs/common.sh` — added `job_is_active()` next to `job_in_lifecycle()`, with a comment explaining the split and citing the pr475 incident.
- `scripts/jobs/post-job.sh` — dedup now calls `job_is_active`; updated the stale "counts tada via job_in_lifecycle" parenthetical.
- `scripts/jobs/test/directive-identity-dedup-test.sh` — added regression test 9: seeds a completed owner in `tada/` **with a live index entry still pointing at it** (the actual incident shape — distinct from test 6 which deletes the owner entirely, and test 8 which uses a different identity), posts a fresh same-identity directive under a new base, and asserts it mints and re-points the index.

## Verification

- New test 9 **fails against the old code** (reproduces the exact pr475 refusal: `...-reply-humans-resolve-policy` blocked by the completed `...-pr475-e3925eb5` owner) and passes with the fix.
- Full `directive-identity-dedup-test`: 24/24 pass — the live-owner-blocks case (2) and the bare-basename tada-collision WARN (8f) still pass unchanged.
- `orchestrate-test` (49/49) and `auto-gauntlet-handoff-test` pass, confirming the untouched `job_in_lifecycle` callers are unaffected.
- Pushed to `main2` as `f8c053a02b` (rebase CAS, first attempt).

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-job-in-lifecycle-tada-conflation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 35 tokens (1090015 cached reads)
- Output: 10444 tokens
- Cost: $1.3899515 (2 engagement(s) unpriced)
- Wall-clock: 189s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
