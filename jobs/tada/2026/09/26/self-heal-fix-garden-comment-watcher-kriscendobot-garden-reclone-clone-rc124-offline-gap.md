## Completion report: self-heal-fix-garden-comment-watcher-kriscendobot-garden-reclone-clone-rc124-offline-gap

**Nothing to change: the fix was already on `main2`.** Commit `434d5402956` ("fix(common): treat reclone_clone rc=124/137 timeouts as a transient skip") landed about 5 hours before this job was claimed. It does what the job asked for, and I made no commits.

**What I checked:**
- **The fix itself.** `reclone_clone` (`scripts/jobs/common.sh:4303-4325`) now keeps `bounded_clone`'s exit code. It treats `rc=124` or `rc=137` as offline, the same test the sibling `sync_clone` call sites use, before checking the error text. It logs, then exits with `GARDEN_OFFLINE_RC` (75, EX_TEMPFAIL). The observed failure (a 45s timeout with no error text) now hits the rc check and skips the tick instead of reaching `die`.
- **Other callers.** The only callers are the two inside `ensure_clone` (common.sh:4344 and 4347). The only indirect consumer is `inbox-read.sh`, whose comment at :36 already expects the EX_TEMPFAIL result from its subshell. Nothing depends on `reclone_clone` dying on a timeout.
- **`self-heal-run.sh`.** No parallel update is needed. The wrapper already turns any rc=75 into a clean exit 0 (`is_nonattributable_rc`, around line 122) before it ever runs its fallback grep. The grep at :162 only matters when a command fails with some other code, and this path now exits 75 directly. The grep also reads its patterns from `GARDEN_OFFLINE_SIGNATURES` in common.sh, so the two lists can't drift apart.
- **Tests.** `scripts/jobs/test/fetch-timeout-test.sh` passes 20 of 20. Subtest 10 covers a clone timeout at rc=124 and at rc=137 (both exit 75), an SSH-255 outage (exits 75), and a real repository error, which still exits 1.

**Follow-ups:** none. The duplicate job was probably posted by a crash that happened before the root checkout was redeployed with `434d5402956`. It should stop once the rolling deploy reaches this host.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-garden-reclone-clone-rc124-offline-gap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (152375 cached reads)
- Output: 1486 tokens
- Cost: $0.38923500000000005
- Wall-clock: 39s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
