The work is fully landed on `origin/main2` and verified. Writing the completion report.

The change requested by this job — teaching `sync_clone` to self-heal a *corrupted* (not just partial) journal clone — is fully implemented, tested, and already committed to `origin/main2` (HEAD `a31a27558b`). I verified every deliverable against the spec and confirmed the tests pass in isolation.

**What's in place (verified against the spec):**

1. **Classifier** — `_fetch_stderr_is_corrupt` (common.sh:1780) sits next to `_fetch_stderr_is_offline`, backed by a single-source-of-truth regex `GARDEN_CORRUPT_CLONE_SIGNATURES` (common.sh:1778) covering the full corruption set: `bad object`, `did not send all necessary objects`, `failed to run repack`, `invalid sha1 pointer`, `broken ref`/`bad ref for`, `unable to read`, `loose object … is corrupt`, `object file … is empty`, plus `gc.log`/`fsck`. It's case-insensitive and kept disjoint from the offline set (a companion `_fetch_stderr_corrupt_signature` prints the matched token for operator logs).

2. **`sync_clone` heal** (common.sh:2605) — in the `rc != 0` branch, *after* the offline check and *before* the terminal `die`: on a corrupt signature (or a lingering `.git/gc.log`) it WARN-logs, removes `gc.log`, `rm -rf`s the clone, atomically re-clones via `ensure_clone` (under the still-held `clone_lock`), and retries `journal_fetch` **once**. Success falls through to `reset --hard`; a repeat failure `die`s (offline blip re-routes to EX_TEMPFAIL). The heal is a single linear block — bounded to at most once per call, no re-clone loop.

3. **Regression tests** (`scripts/jobs/test/run-test.sh`, SUBTEST 23+24):
   - SUBTEST 23 — classifier assertions for every corruption signature plus disjointness (offline shapes are *not* flagged corrupt, and vice-versa).
   - SUBTEST 24 corrupt blocks A–D — (A) real zeroed `refs/remotes/origin/journal2` + stale `gc.log`; (B) injected corrupt-then-ok fetch proving atomic replacement; (C) always-corrupt fetch proving heal-at-most-once then loud `die` (no loop); (D) the real garden-repo-watcher shape (zeroed `refs/heads/journal2` loose ref + bad reflog + stale `gc.log.lock`).

**Verification I ran:** The full `run-test.sh` hangs at an unrelated SUBTEST 4 (gardener-scaler) in this sandbox, so I ran the relevant subtests in isolation against a throwaway bare journal repo. SUBTEST 23 passed all classifier assertions; SUBTEST 24 corrupt A/B/C/D all passed (`PASS=4 FAIL=0`). (An earlier isolated run showed B/C "failing" — that was purely a `/tmp` noexec artifact on the stub fetch scripts; rerun on an exec-capable path they pass.)

**One-shot unblock:** The local `.garden-state/clerics/7/journal` clone on *this* instance (garden2) is healthy — dry-run fetch rc=0, no `gc.log`, ref resolves — so no manual `rm -rf` is warranted here. The `/home/kris/garden` path named in the spec belongs to a different production instance not present in this environment; with the code fix now on `main2`, that clone will auto-heal on its next `sync_clone` tick after deploy.

**Follow-ups:** None for this job. Optionally, the SUBTEST 4 hang under the sandboxed test-runner is a separate, pre-existing issue worth a look but out of scope here.
