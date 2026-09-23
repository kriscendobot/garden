Pushed to main2. Job complete.

## Completion report

**Problem:** `scripts/jobs/triager.sh:46` had a hard `die "no bare clone at $BARE (clone the repo first)"` when the host held no local bare clone. Because the watch set (`repos/<slug>`) is journal-shared across hosts but bare clones are host-local, any host arming a `garden-triager@<slug>` timer without the corresponding clone would `exit 1` every tick — the live crash-loop of `garden-triager@kriscendobot-finbot` on `endolin-garden2-5bcdff64`.

**Fix:** Changed the missing-`$BARE` check to a graceful skip mirroring the `comment-watcher.sh` precedent: `log "no bare clone at $BARE on this host; skipping triage (a host that holds the clone triages this repo)"` then `exit 0`. Added a comment explaining that the triager genuinely needs the local clone to diff refs against its cursor (unlike the `gh`-polling comment-watcher), so a clone-less host is a benign no-op. Downstream hard-failure cases (fetch failure at line 48, unresolvable ref) are untouched.

**Test:** Added case **H** to `scripts/jobs/test/triager-test.sh`, asserting that a slug with no bare clone in `$GARDEN_REPOS` exits 0, emits the skip log naming the host-local reason, and never invokes the triage handler. Full suite passes: **41 passed, 0 failed**.

**Changed files:** `scripts/jobs/triager.sh`, `scripts/jobs/test/triager-test.sh`. Committed and pushed to `main2` (rebase CAS, clean push).

**Follow-ups:** None. The next `garden-triager@kriscendobot-finbot` tick on the affected host will now skip cleanly instead of restart-looping.
