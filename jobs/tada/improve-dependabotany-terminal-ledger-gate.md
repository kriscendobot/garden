Pushed to `main2` on the first attempt. Job complete.

---

**Completion report**

**What the job asked:** Broaden the deterministic daily-backstop preflight gate (`scripts/jobs/dependabotany-preflight.sh`) so it recognizes explicit terminal-ledger declarations — e.g. "all rows terminal" and "no prior EMBARGO remains open" — as a drained set, with regression fixtures. The prior conservative maturity-date scan re-dispatched a no-op sweep every day after every tracked PR had merged/closed, spamming the journal with routine "nothing due" entries.

**What I changed:**
- `scripts/jobs/dependabotany-preflight.sh`: extended `DRAIN_RE` (the prose "off"-signal matcher used by `ledger_declares_drained`) with two alternatives — `(all|every)[^.]*rows?[^.]*terminal` and `no[^.]*embargo[^.]*remain` — covering "all rows terminal" / "every ledger row is now terminal" and "no prior EMBARGO remains open" / "no embargo remains". Added an explanatory comment tying the change to the SOUNDNESS argument: skipping still requires (A) zero open dependabot PRs, and an active embargo is by construction an open PR, so a generous drain match can only quiet a genuinely idle set — it can never unsafely skip live work.
- `scripts/jobs/test/dependabotany-preflight-test.sh`: added two body helpers (`all_rows_terminal_body`, `no_embargo_remains_body`) and two regression cases. Each seeds a *matured* `EMBARGO-2026-08-05` row (which the bare due-row scan would treat as work) plus a later prose terminal declaration, and asserts exit 2 (no dispatch). One also asserts the drain-recognition log line.

**Verification (ran it, observed the result):** `bash scripts/jobs/test/dependabotany-preflight-test.sh` → **26 passed, 0 failed**, including the two new cases. The pre-existing "due embargo row, set not drained → exit 0" case still passes, confirming the broadened regex does not falsely match a live embargo body.

**Follow-ups:** None. The change is confined to the gate's prose recognition and its hermetic test; no schedule, role, or journal state was touched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-terminal-ledger-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (688003 cached reads)
- Output: 7424 tokens
- Cost: $1.1034685000000002
- Wall-clock: 112s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
