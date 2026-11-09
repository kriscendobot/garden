I made no changes, because this work is already on `main2`. Commit `3bddd993c71` ("fix(self-heal): retain responder failure diagnostics", landed about 12 minutes before I claimed the job) does what the job asks. This job seems to have been posted for the same 2026-11-09T01:22:24 failure while that fix was still in flight.

**What `scripts/jobs/self-heal-run.sh` does now**
- Responder stderr goes to a temporary file (`mktemp`) instead of `/dev/null`. The file is deleted by the existing EXIT trap.
- When the responder fails, it logs one line: `WARN: responder for '<ctx>' failed classification=<exit|timeout|launch-error|interrupted> status=<rrc> failure-blob=<sha> stderr-tail: …`
- The stderr tail is limited by `SELF_HEAL_RESPONDER_STDERR_BYTES` (default 4096) and its newlines are flattened, so it stays on a single journald record.
- Exit codes are classified as: 124/137 under `timeout` → `timeout`; 125/126/127 → `launch-error`; any other non-zero → `exit`; a stop signal during diagnosis → `interrupted`.
- The tail is read only after the process group has been reaped, so nothing a leftover child writes later can be missed.
- The wrapped service's exit code is still passed through unchanged.

**Tests**
That commit also added two cases to `scripts/jobs/test/run-test.sh`: one for a non-zero exit with a bounded tail and a failure-blob SHA you can open, and one for a timeout. I ran the full suite in this worktree and both pass, as do all the existing self-heal cases.

The suite as a whole failed: 390 passed, 28 failed. None of the 28 failures are in self-heal. They are in the scheduler one-shot, inbox cold-clone, mechanic/quarantine, foreman plan-deferred and unit ExecStart tests. I haven't looked into them; at least one comes from this host rather than the code (a host-local `broker.py` unit tripped the ExecStart check), and the rest look environmental too.

**Follow-ups**
- Check how far the deployed root is behind `main2` (deploy lag) before treating any new opaque responder failure as a fresh bug. A root still behind `3bddd993c71` would still drop responder stderr.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-self-heal-responder-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 14 tokens (379401 cached reads)
- Output: 1971 tokens
- Cost: $0.5349722 (1 engagement(s) unpriced)
- Wall-clock: 1228s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
