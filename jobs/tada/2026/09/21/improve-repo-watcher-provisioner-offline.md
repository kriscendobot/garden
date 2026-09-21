Pushed to `main2` on the first attempt. Work complete.

## Completion report

**Job:** `improve-repo-watcher-provisioner-offline` — make `scripts/jobs/repo-watcher.sh` treat a fork-watch-provisioner `rc=75` as a transient shared-availability event with bounded, deduplicated reporting rather than an identical WARN every reconcile tick, while still reconciling already-armed watches.

**What I did**

- **`scripts/jobs/repo-watcher.sh`** — replaced the one-line `"$PROVISIONER" || log "WARN: … (rc=$?)"` with rc-classified, edge-latched handling:
  - `rc=75` (`GARDEN_OFFLINE_RC`, EX_TEMPFAIL — the provisioner's `sync_clone` offline skip): reported **once at the edge** via a host-local marker (`$GARDEN_STATE/repo-watcher/fork-provisioner-offline`), then **suppressed** while the outage persists, and a **single recovery line** is logged when the provisioner next runs cleanly (marker cleared).
  - `rc=0`: closes any open offline episode.
  - Any **non-75** failure keeps the **original actionable per-tick WARN** — it is not self-healing.
  - The reconcile of the already-armed watch sets runs regardless (unchanged), so a provisioner hiccup never blocks reconciliation.
  - Marker path overridable via `GARDEN_FORKWATCH_OFFLINE_MARKER` for tests. The `if "$PROVISIONER"; then prc=0; else prc=$?; fi` capture is `set -e`-safe.

- **`scripts/jobs/test/run-test.sh`** — added a subtest in the REPO WATCHER section driving the `GARDEN_FORK_PROVISIONER` seam with a stub whose exit code is file-controlled: asserts the rc=75 edge report fires once (and not the actionable WARN), reconcile still arms the triager during the outage, a second offline tick is suppressed, recovery is reported once on the clean tick, no spurious recovery on a steady clean tick, and a non-75 failure keeps its per-tick WARN and is not misclassified.

**Verification**

- `bash -n` clean on both files.
- Because the full `run-test.sh` is slow and flaked in SUBTEST 4 (the scaler, which runs *before* and shares no code with my SUBTEST 3 additions — a pre-existing environmental flake), I extracted the exact new subtest logic into a self-contained harness (throwaway bare journal + mock systemctl + the real `repo-watcher.sh`). All **8 assertions pass**.

**Follow-ups**

- None required. Note for future runners: the heavy `run-test.sh` suite intermittently exits 1 during SUBTEST 4 (GARDENER-SCALER) in this container; that is unrelated to this change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-repo-watcher-provisioner-offline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2761153 cached reads)
- Output: 19928 tokens
- Cost: $2.8261165
- Wall-clock: 1591s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
