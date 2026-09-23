Empty inbox. Job complete.

## Completion report

**What the job asked:** `sync_clone()` in `scripts/jobs/common.sh` FATAL'd with rc=1 and empty diagnostic text on the "ambiguous journal-fetch outage" shape (retry-exhausted `journal_fetch`, rc=1, diagnostic matching `journal fetch in .* failed after N attempt`, not auth/corrupt/upstream-gone/local-fs). The cursor path already classified this as transient via `journal_bounded_fetch_is_ambiguous_outage()`; `sync_clone` did not, so every bare `sync_clone`/`ensure_clone` caller (receipt-watcher, comment-watcher, ci-watcher, triager) died loud on a mere connectivity blip that outlived the bounded retries.

**What I changed:**
- `scripts/jobs/common.sh` — in `sync_clone`'s retry-exhaustion branch, before the final `die "fetch failed in $dir after bounded retries"`, added an `elif journal_bounded_fetch_is_ambiguous_outage "$rc" "$GARDEN_FETCH_STDERR"` arm that takes the same clean `log "offline; skipping tick (rc=$GARDEN_OFFLINE_RC)"; exit "$GARDEN_OFFLINE_RC"` path already used by the offline and corrupt-recovered branches. This mirrors the cursor-path classification, so all `sync_clone` callers inherit the weather-vs-real-failure distinction. A positively-identified auth/corrupt/upstream-gone/local-fs failure still dies loud (the ambiguous predicate excludes those via `journal_diagnostic_is_definite_failure`).
- `scripts/jobs/test/cursor-outage-cooldown-test.sh` — added **SUBTEST 1c** exercising `sync_clone` directly as a bare caller: (c1) the ambiguous retry-exhausted shape now exits `GARDEN_OFFLINE_RC` (75) instead of dying; (c2) the same bounded-retry marker line carrying a real auth signature still dies loud, proving the fallback is bounded away from genuine faults.

**Verification:** `bash -n` clean on both files; full test suite green — **57 passed, 0 failed** (was 55; +2 new assertions). Committed and pushed to `main2` (`0144ff77da3..508cebc6764`).

**Note / follow-up:** The Edit/Read tools and Bash/git were operating on divergent filesystem views this session — Edit reported success and Read reflected the changes, but they never reached the git working tree Bash/git see, so the test run and `git status` showed nothing. I worked around it by applying both edits through Bash (`python3` in-place) and confirmed via `git diff`. Worth flagging to the maintainer as a harness/sandbox anomaly if other gardeners report "committed nothing" despite successful Edits.

No further work outstanding.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-garden-sync-clone-ambiguous-outage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2474534 cached reads)
- Output: 20657 tokens
- Cost: $2.5328440000000003
- Wall-clock: 352s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
