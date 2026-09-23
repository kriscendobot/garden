Done. The change is committed and pushed to `origin/main2`; the shared root tree is left clean (it deploys deliberately, not from my working copy).

---

## Completion report

**Job:** `improve-gardener-reap-now-hint-for-signal-killed-jobs`
**Landed:** commit `5dd3cf5b6` on `origin/main2` (built in an isolated worktree off `origin/main2` per garden infra-job discipline; shared `/home/kris` tree left clean).

### What I did
A gardener whose handler dies a transient signal-kill (143/137/130) knows at exit time the claim is dead, but the transient branch only left the job in `doin` to wait out the full `GARDEN_CLAIM_TTL` (3600s). I added a deterministic **reap-now hint** so the reaper requeues it on its next ≤10-min tick instead.

### What changed (4 files)
- **`scripts/jobs/common.sh`** — new shared `REAP_NOW_MARKER` / `REAP_NOW_MARKER_RE` (`<!-- garden-reap-now -->`), `has_reap_now_hint()`, and `stamp_reap_now_hint <clone> <doin-relpath>` (inserts the marker into the claim **body** just above the `---`/`claim:` block, then lands it on the board via the existing `sync_clone`/`commit_and_push` with bounded CAS retry; idempotent; returns success if the claim was already hinted or already moved by a peer).
- **`scripts/jobs/gardener.sh`** — the `transient=1` branch now stamps the hint on its own still-in-doin claim, run in a **subshell** so a `sync_clone` offline-exit can't kill the gardener; best-effort, with the reaper's TTL requeue as the fallback. The non-signal real-failure branch is untouched.
- **`scripts/jobs/reaper.sh`** — stale-set detection honors the hint (checked **before** the `ts==0` guard so it's authoritative even on an unparseable `claimed_at`); a hinted claim is added to the stale set early and flows through the **same** requeue + `<!-- garden-reaped: N -->` poison path, so a job SIGTERM'd every cycle still escalates as poison after `GARDEN_REAP_POISON_THRESHOLD` rather than looping forever. `clean_body` now also strips the reap-now marker so it never persists into a healthy re-claim.
- **`scripts/jobs/test/signal-kill-classifier-test.sh`** — added an assertion that a signal-kill stamps the hint (SUBTEST 2 (f)), plus a new **SUBTEST 3** that runs the real reaper against the hinted claim with `GARDEN_CLAIM_TTL=3600` and asserts it requeues `doin→todo` before TTL, stamps `garden-reaped: 1` (poison cycle still counts), and strips the hint from the requeued job.

### Design invariants honored
- The reaper stays the **single writer** of the requeue and the poison counter; the gardener only hints.
- The hint flows through the poison threshold (no infinite-requeue bypass for a genuinely wedged fetch).
- The deterministic non-signal real-failure branch stays on the unchanged reaper-TTL/escalation path.

### Verification
- `signal-kill-classifier-test.sh`: **17 passed, 0 failed** (in place and re-run in the worktree on the clean `origin/main2` base).
- `empty-output-classifier-test.sh`: **14 passed, 0 failed** (no regression in the sibling classifier).
- `shellcheck -S warning` on the three scripts: no new findings (only the pre-existing SC2261/SC2034/SC2010/SC2009 noise unrelated to this change).

### Follow-ups
- None required. The deliberate deploy will advance the root checkout when `origin/main2` is picked up; live gardeners/reaper will adopt the behavior on their next restart/tick. The live `rc=143` scholar jobs cited in the spec will be reaped on TTL by the currently-running reaper (this fix shortens the *next* such occurrence, after deploy).
