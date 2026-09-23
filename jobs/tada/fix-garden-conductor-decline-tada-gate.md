Inbox empty. Work is complete and pushed.

## Completion report

**Job:** fix-garden-conductor-decline-tada-gate — close the gap where a conductor that DECLINES to merge still satisfies a `blocked_on` gate.

**Root cause:** `unblock.sh` keyed a `blocked_on`-a-job edge purely on the blocker reaching `jobs/tada/`. A job can reach tada/ having completed cleanly yet declined the gated outcome (a conductor refusing to merge a red/frozen/ferry-required PR), so the dependent got promoted onto a base that never landed.

**Approach:** chose the least machinery — reuse the failure marker the orchestrate watcher already honors, extend `unblock.sh` to respect it, and document the conductor's obligation to emit it.

**Changed (committed `d14be16bd2` → `origin/main2`):**
- `scripts/jobs/common.sh` — added `tada_failed`, the single source of truth for the `orchestration-failed: true` / `orchestration-status: fail…` marker. Both deterministic serial primitives now read it rather than re-spelling the grep.
- `scripts/jobs/orchestrate.sh` — `child_state` now calls `tada_failed` (behavior identical; de-duplicated).
- `scripts/jobs/unblock.sh` — when a `blocked_on` JOB blocker is `tada_failed`, it no longer promotes. It flips the plan gate `blocked → blocked-failed` (so the watcher stops re-scanning it — notify-once by construction), records `blocked_failed_reason:` on the plan, and surfaces the stalled dependency to the maintainer inbox. The work survives held in `plan/` for a human to override (`promote-plan.sh`) or discard. CAS-retried, `set -e`-safe.
- `roles/conductor/AGENT.md` — new operating norm + "tada-failed contract" section: a declined merge marks its report `orchestration-failed: true`; a genuine merge omits it. Also documents the belt-and-suspenders consumer-side precondition (merge-gated follow-ups verify PR state themselves).
- `scripts/jobs/test/run-test.sh` — subtest 20b case (9): a declined-blocker tada holds its dependent (gate=blocked-failed, never promoted to todo/), surfaces to the maintainer, and is idempotent on re-tick (no re-promote, no re-notify).

**Verification:**
- Focused hermetic driver reproducing subtest 20b: declined-blocker held + maintainer-notified + idempotent, and a *normal* (non-declined) blocker still promotes — all pass.
- `orchestrate-test.sh`: 16/16 pass (the `tada_failed` refactor is behavior-preserving).
- `bash -n` and `shellcheck -S error` clean on all modified scripts.
- Note: the full `run-test.sh` can't run end-to-end in this sandbox (subtest 4's `set-gardeners.sh` needs a journal remote the sandbox blocks, unrelated to this change); the new case was validated via the focused hermetic harness instead.

**Follow-ups:** none required. Both the producer side (conductor emits the marker) and consumer side (unblock + orchestrate honor it) are now covered, with defensive PR-state verification documented for hand-authored/pre-marker reports.
