Done. Work committed and pushed to `main2` (`58c9c6c2d8a`).

## Completion report

**Task:** After a soft pacing-clone lock failure, arm a host-shared longer contention cooldown so subsequent triager ticks skip the optional pace refresh quietly until it expires. The existing 30s refresh gate does not suppress a *persistently* busy clone.

**What I did (`scripts/jobs/triager.sh`):**
- Added a second, longer **host-shared contention backoff** on top of the existing 30s refresh gate, controlled by a new `GARDEN_TRIAGE_PACE_CONTENTION_COOLDOWN` (default 300s; 0/unparseable disables it).
- New host-shared state stamp + flock (`contention-gate` / `contention-gate.lock`) alongside the existing refresh gate.
- `triager_pace_contention_active()` — read-only check, fails toward *proceeding* on any disabled/unparseable/garbage state so a stray file never wedges pacing off.
- `triager_pace_arm_contention()` — flock'd write/extend of the expiry stamp, no-op when disabled/unwritable.
- In `triager_pace_schedule()`: check the backoff **before** the refresh gate — while active, every tick skips the optional refresh quietly (no lock, no journal round-trip, no warning). The refresh subshell's exit code is now captured; when it fails with the soft-lock/journal-input `EX_TEMPFAIL` rc (`GARDEN_OFFLINE_RC`), the backoff is armed. Any other nonzero rc warns (latched) without arming, preserving prior behavior.
- Extended the header comment block explaining why the 30s gate can't suppress a persistently busy clone (the 13 repeated warnings) and how the backoff collapses it to one warning → clean silence → recovery.

**Coverage (`scripts/jobs/test/triager-pacing-test.sh`):** added two assertions — (1) a soft lock failure warns once then subsequent ticks skip quietly under backoff (no repeated warnings, no clone touch, no projector call), and (2) a tick past the window retries and recovers (projector runs, "inputs recovered", marker written). Full suite: **10 passed, 0 failed.** Existing 8 tests unaffected.

**Incident note (self-corrected, no lasting damage):** I initially applied edits via absolute paths into the *deployed garden root* (`/home/kris/garden2/...`) rather than my worktree. I caught it, restored the two root files by copying the pristine worktree originals over them (a plain `cp`, **no git run in the root**), and verified both root files are byte-identical to `HEAD` again. All real work was then done and committed in the per-job worktree.

**Follow-ups:** none. `shellcheck` is not installed on this host, so lint was not run; `bash -n` syntax checks passed for both files.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-pace-contention-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4618089 cached reads)
- Output: 43530 tokens
- Cost: $4.573939499999998
- Wall-clock: 655s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
