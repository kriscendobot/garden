Pushed to `main2`. Job complete.

## Completion report

**Problem:** `scripts/jobs/gardener-scaler.sh`'s reconcile loop conflated a *structurally-absent* count line for a worker kind with a *present-but-unparsable* value — both fell into the empty-`want` branch and emitted a `WARN … undeterminable` on every ~60s tick. A host legitimately running one kind but not another (`hosts/<host>` has `gardeners: N` but no `clerics:` line) spammed that WARN indefinitely, burying real scaler signal.

**What I did:**
- Added `read_desired_count <hosts-file> <count_key>` to `scripts/jobs/common.sh`, a single-responsibility helper whose exit status encodes the three outcomes: `0` = line present & parses (stdout carries the count; explicit `0` still legitimately scales-to-zero), `2` = file present but key line absent (normal — this host doesn't declare the kind), `1` = file missing entirely OR value unparsable (genuine misconfig).
- Rewrote the scaler loop to branch on that status: status 0 → scale; status 2 → quiet `DEBUG` no-op; status 1 → `WARN` no-op. Preserved the invariant that only an explicit `<count_key>: 0` scales a kind to zero (missing is never treated as 0).
- Updated the scaler's header comment to document the three-case read.

**Tests:**
- New `scripts/jobs/test/scaler-desired-count-test.sh` — pins the helper's status/stdout contract across all cases (parse, explicit-0, absent-key, missing-file, unparsable, whitespace, prefix-anchoring) and drives the scaler's DEBUG-vs-WARN branch. **12/12 pass.**
- `scripts/jobs/test/run-test.sh` SUBTEST 4 — added an assertion that a declared-gardeners/absent-clerics host emits `DEBUG` (not `WARN`) for clerics while a wholly-absent hosts file still `WARN`s. Verified these new assertions pass when run directly against the real scaler.
- `worker-spine-kinds-test.sh` still **45/45** (no regression); `bash -n` clean on all touched files.

**Verification of behavior:** direct scaler run with `hosts/testhost` = `gardeners: 1` (no clerics line) logs `DEBUG … declares no clerics line` and exits 0; a missing hosts file logs `WARN … undeterminable`.

**Follow-up (pre-existing, not caused by this change):** the full `run-test.sh` aborts partway through SUBTEST 4 in this live-host sandbox because `set-gardeners.sh` returns rc=2 there (reproduces identically on pristine `origin/main2`, before any scaler assertion is reached). It appears tied to running the integration suite with `GARDEN=testhost` mismatched against the real hostname on a live gardener host. My additions sit after that abort point and were validated independently; they'll exercise normally in a clean CI environment. Worth a separate look but out of scope here.
