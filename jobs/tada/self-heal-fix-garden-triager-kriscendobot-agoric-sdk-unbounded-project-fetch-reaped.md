Inbox empty. The job is complete.

## Completion report

**Job:** Bound the triager's project bare-clone fetch so a large monorepo (kriscendobot-agoric-sdk) self-limits under its own `timeout` instead of being externally reaped and crash-looping the unit via self-heal.

**Landed:** commit `74704e47a8` on `main2`, on top of a peer's just-landed `d539ac5235` ("classify transient fetch exits").

**What I found on arrival:** The job spec was written against an older tree. Two things had already shifted:
- Prior peer commits had already added a `timeout`-bounded fetch with transient classification, and a *third* peer commit (`d539ac5235`) landed **mid-job** while I was working — it reverted the retry-loop/never-die block back to a simpler form (`GARDEN_FETCH_TIMEOUT` + `--all`, transient → `exit $GARDEN_OFFLINE_RC`, genuine → `die`). This caused a rebase conflict on my first push; I aborted, hard-reset onto the new `origin/main2`, and re-applied atop the peer's structure.

**What was still missing (my actual contribution), applied on the peer's version:**
1. **`scripts/jobs/common.sh`** — added a dedicated `GARDEN_TRIAGE_FETCH_TIMEOUT` knob (default **90s**), documented as needing to stay under the reaper's `GARDEN_FETCH_REAP_AGE` (120s). The journal-scoped `GARDEN_FETCH_TIMEOUT` (~45s) was too tight for agoric-sdk: it would be killed every tick, classified transient, skipped, and the repo would never triage.
2. **`scripts/jobs/triager.sh`** — the steady-state fetch now uses `GARDEN_TRIAGE_FETCH_TIMEOUT` (so triager's own `timeout` bounds it, keeping the reaper a pure backstop), fetches **`origin`** by name instead of `--all` (a bare project clone has one remote), and adds **rc 143** to the transient skip set alongside 124/137. Transient/reap kills skip via `GARDEN_OFFLINE_RC` (which `self-heal-run.sh` normalizes to a clean exit 0 — no Failed unit, no self-heal); a genuine fetch error still `die`s and surfaces loudly.

**Verification:**
- `shellcheck` on both files: no new findings (the sole error, SC2261 at `common.sh:1471`, is pre-existing and unrelated to my hunks).
- Behavioral test of the classifier: rc **124/137/143 → WARN + exit 75** (clean via self-heal), rc **128/1 → die → exit 1** (Failed, loud) — matching the job's verify criteria.
- Confirmed the 90s bound resolves and sits under the 120s reaper age.

**Note on a spec/tree divergence:** The job's step-2 wording ("reserving die/exit 1 for a genuine error") predates the peer's `die`-on-genuine-error structure, which I kept — it already aligns with the job's verify criterion "a real fetch failure still exits non-zero." I did not reintroduce the older never-die retry loop, since the current tree deliberately supersedes it.

**Follow-ups:** none required. (Pre-existing SC2261 in `common.sh` line ~1471 is out of scope for this job but could be cleaned up separately.)
