The deployed root is clean (change count 0, no stray test file), the change is committed and pushed to `main2`, and my inbox is empty. Work complete.

## Completion report

**Job:** Recognize the repeated provider policy-refusal signature in a failed handler capture and quarantine the job with one concise inbox escalation, instead of leaving it in `doin` for reaper retries.

**Root cause found:** Two Ironhorse fuzz repairs (`ironhorse-fuzz-*-repair`) failed identically after a provider control-plane block — a Codex cyber-content refusal: `{"type":"turn.failed","error":{"message":"This content was flagged for possible cybersecurity risk … Trusted Access for Cyber program: https://chatgpt.com/cyber"}}`. This is a **deterministic** failure (the same prompt re-runs into the same block), yet the gardener's real-failure path escalated an identical capture to the inbox every cycle and left the job in `doin` for the reaper to requeue up to the doom threshold.

**What I changed** (commit `f17873d8e3` on `main2`):
- **`scripts/jobs/common.sh`** — added `is_provider_policy_refusal_text` (narrowly keyed on the provider's structured refusal envelopes, excludes quota caps and benign security-discussing prose), the `<!-- garden-policy-refusal -->` cycle marker, and `stamp_policy_refusal_hint` (marker + reap-now, CAS retry — mirrors `stamp_deadline_overrun_hint`). Wired into `CYCLE_MARKER_RE` and `cycle_marker_summary`.
- **`scripts/jobs/gardener.sh`** — in the real-failure branch, detect the refusal in the capture, stamp the hint, and skip both the per-cycle report-error escalation and the hermit-capability probe.
- **`scripts/jobs/reaper.sh`** — on the hint, doom-park the job held in `plan/` with `doom_signature: policy-refusal` on the **first** evaluation (bypassing requeue/overrun/constancy thresholds and the progress-verdict rescue), and surface **one** maintainer notice naming the block and the rephrase/remove remedy. `clean_body` strips the marker.
- **`scripts/jobs/test/policy-refusal-quarantine-test.sh`** — hermetic test: classifier cases, reaper quarantine (thresholds pinned huge so only the policy path can park it), and single-notice. 3/3 pass.

**Verification:** All three scripts pass `bash -n` and shellcheck (only pre-existing codebase-style notes). New test passes; adjacent regression tests pass (reaper-doom-park 8/8, provider-quota-backoff 7/7, outage-doom-pause 11/11, promote-plan-doom-reset 32/32, claude-session-limit 40/40, elapsed-constancy 50/50).

**Process note / follow-up:** I initially applied edits to the deployed garden root by mistake (absolute `/home/kris/garden2/...` paths). I restored the deployed root to pristine byte-for-byte (using the worktree's unmodified copies of the same base commit) and re-applied the work in the job worktree — using only file operations, never git, in the root. The six live `ironhorse-fuzz-*-repair` claims currently in `doin` were freshly re-claimed (06:08–06:21Z) and will be quarantined on their next failure now that this is deployed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-quarantine-policy-refusals.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 133 tokens (8963976 cached reads)
- Output: 48763 tokens
- Cost: $7.392792999999998
- Wall-clock: 812s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
