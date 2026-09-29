The job is complete. Here is my report.

## Completion report

**Job:** Fix the endo-daemon restart orphan that wedges minion.town CD.

**Re-derived state (clean requeue):** No PR existed for this job's marker; my worktree was fresh off `main`. PR #130 ("avoid daemon health-probe spawn race") is a *separate*, still-open fix on the same script taking the graceful `endo stop` approach — not this job's work.

**Diagnosis (confirmed against source at pin `f9cbcfc`):** the daemon's TCP network device runs inside a `manager-node.js` worker that binds the *persisted* loopback CapTP listener `127.0.0.1:8920` (`tcp-listen-addr`). On stop/restart, systemd's cgroup teardown can leave that worker reparented to PID 1 still holding the port, so a fresh start dies `EADDRINUSE` and crash-loops under `Restart=on-failure`; the deploy rollback hits the same live orphan. A shutdown-ordering defect, not a pin problem.

**Changes (PR #137, draft, against frozen base `main-e922c49`):**
- **`deploy/aws/systemd/endo-daemon-reap-port-orphans.sh`** (new, +x): reaps whatever holds `:8920` (`ss` → SIGTERM → SIGKILL), always exits 0, no-op when free.
- **`endo-daemon.service`**: wired as `ExecStartPre=+…` (root), so it runs before **every** start — CD restart, manual restart, and each automatic `Restart=on-failure` recovery — making the crash-loop **self-heal**.
- **`deploy-endo-daemon.sh`**: installs the reaper before the unit; replaces the bare `systemctl restart` with **stop + reap + start**; the rollback start reaps too.
- **`test/endo-pin-drift.test.ts`**: regression-guards the reaper, the `ExecStartPre` wiring, and the "no bare restart" invariant.
- **Rider — `minion-git-remote.service`**: `HOME=/var/lib/minion-git` silences the per-request `git/attributes: Permission denied` warning (ProtectHome masks its passwd home; git derives global config/attributes paths from HOME).

**Verification:** `bash -n` + `sh -n` OK; `vitest run test/endo-pin-drift.test.ts` → 7 passed; `tsc --noEmit` clean; **CI on PR #137 all green** (`test`, Claude harness amd64 + arm64).

**PR:** https://github.com/kriscendobot/minion.town/pull/137 — stops at an open draft per the manual-gauntlet regime; promote with **run the gauntlet #137**.

**Follow-up:** #137 and #130 both touch step 4g and this test file; whichever lands second needs a trivial rebase. Memory updated.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-cd-endo-daemon-restart-orphan-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 88 tokens (3993011 cached reads)
- Output: 43683 tokens
- Cost: $4.1471605 (1 engagement(s) unpriced)
- Wall-clock: 1088s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
