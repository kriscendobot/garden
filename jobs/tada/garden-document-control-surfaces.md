Landed commit `670762963c` on `main2`.

- Added the README lever-semantics reference table, leading with the non-automatic `go-ahead` gate.
- Added plan-promotion and cross-host sysop procedures.
- Documented drain boundaries, foreman-only control, remote scaling, issuer replacement, sysop trust tiers, deploy pre-draining/recovery, capacity-zero semantics, and schedule pause/restore.
- Added worked SIWE and budget-attribution examples to the gallery.
- Corrected the supplied claims:
  - `gate: go-ahead` means awaiting authorization, not already authorized.
  - `repo-watcher.sh` reconciles units but does not itself mint jobs; scheduler and self-heal can.
  - Drain does not silence the scheduler.
  - The current foreman-specific brake is `GARDEN_FOREMAN_ACTIVE_TARGET=0`; the concurrent independent-brake job had not landed, so it is recorded as pending.
  - `maintain` is also in the attested sysop tier.
  - Current deploy code lifts a self-engaged drain on timeout; stranded markers now require an inherited operator drain or interrupted process.
  - `gardeners=0` has a narrow quota-route/non-Claude exception rather than an unconditional refusal.
- Found and corrected an additional gap: host-operation levers mutate bounded fleet state directly; not every control surface becomes a board job.
- Confirmed 29 paused schedules.

Verification: deploy tests 85/85, sysop tests 56/56, scheduler tests 8/8, backend/autotune tests 36/36; changed-document links resolve; `git diff --check` clean; remote `main2` matches `670762963c`.

Follow-up: the independent-brake worker was notified to reconcile the pending-status wording when its new control lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-document-control-surfaces.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 540s

<!-- garden-usage-end -->
