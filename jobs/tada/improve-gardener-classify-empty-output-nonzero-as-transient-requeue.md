Done. The peer had already completed (inbox gone), so the ack was dead-lettered — intent preserved, no action needed. Worktree cleaned up.

---

**Completion report — `improve-gardener-classify-empty-output-nonzero-as-transient-requeue`**

**What I did:** Added a transient-outage classifier to the handler-failure branch of `scripts/jobs/gardener.sh`, mirroring the offline→tempfail short-circuit in `self-heal-run.sh`. When a handler exits non-zero AND its capture is either empty (the bare empty-output-nonzero signature of `gardener-claude.sh` killed mid-call) or matches a transient `claude -p` signature (`overloaded`, `rate limit`, `connection error`, `429`/`5xx`, `api error`, `econnreset`/`etimedout`), the gardener now emits a single `kind: progress` *"transient handler outage; left in doin for TTL requeue"* note and **skips** the `report-error.sh` inbox escalation. The loud `kind: error` + inbox-SHA-escalation path is reserved for handlers that failed with real diagnostic output. Either way the job stays in `doin` for the reaper's `GARDEN_CLAIM_TTL` requeue (unchanged).

**Dependency handling:** This depended on `improve-gardener-fold-report-and-rc-into-failure-capture` (gardener-38), which was in-flight on the same lines when I claimed. I messaged the peer to coordinate, waited for it to land (`9f5642360` on `main2`), then built on its `rc=$?` + report-tail-folded capture. The capture-empty test is placed **before** the synthetic-line block, so emptiness stays observable and the empty-case vs transient-signature classifications are disjoint.

**Changed:** `scripts/jobs/gardener.sh` (+55/−22) — committed `a4169d86c`, pushed to `origin/main2` (fast-forward from `9f5642360`).

**Verification:** `bash -n` clean; shellcheck clean (only the pre-existing unrelated SC2034 on `GARDEN_TAG`); a focused 14-case harness over representative captures passed all (9 transient incl. empty, 5 real-failure incl. the `1500ms` false-positive guard which the `\b5[0-9][0-9]\b` word boundary correctly rejects). Done in an isolated worktree off `origin/main2` per garden infra discipline; worktree torn down.

**Follow-ups:** None required. The pre-existing `OPEN — failed-job lane` design question (doin-reaper vs a dedicated `jobs/failed/` lane) remains untouched and out of scope. Note both root-cause jobs (`improve-classify-offline-as-tempfail-in-journal-fetch`, `improve-self-heal-treat-offline-as-clean-exit`) are still sitting in `doin` from their transient failures — they'll requeue on TTL and should now run quietly.
