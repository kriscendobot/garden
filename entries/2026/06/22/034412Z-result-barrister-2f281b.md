---
ts: 2026-06-22T03:44:12Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs: []
---

Barrister first round on PR #500 (kumavis: feat(daemon): compose caplets over un-named powers — by-reference powers + retainUntil).

Panel kind: code-panel
Panel execution: in-band-fallback
Seats run: 26 (all code-panel seats)
External-author calibration: applied (kumavis is not bot identity)

Verdict: CHANGES_REQUESTED (1 must-fix-loop item)

Disposition counts:
- must-fix-loop: 1
- summary-fix: 3
- follow-up: 3
- acknowledge: 7
- drop: 0

Must-fix-loop items:
1. Missing changeset for @endo/daemon. The diff adds MakeCapletOptions.powers and evaluate(..., retainUntil?), both user-facing additive (minor) public APIs. No .changeset/*.md covering @endo/daemon appears in the PR diff. A minor changeset is required before merge.

Summary-fix items:
1. retainUntil silently ignored when resultName is also set — document or guard the ignore-case behavior at the branch site.
2. No test for pre-settled / pre-rejected retainUntil boundary cases.
3. No test for guest-path retainUntil (guest.js path, same makeRetainUnnamed code).

Follow-up items:
1. Self-cycle: can a caller pass the caplet itself as powers, creating a ['powers', id] self-edge? Investigate daemon persistence behavior.
2. M.splitRecord shape does not express powers/powersName mutual exclusion at the guard level (runtime check is the only enforcement).
3. Master-base mirror PR: PR targets llm branch; whether a master-based mirror is planned is not stated.

Proposed-rule messages to gardener: 5 novel rules drafted (mutual-exclusion guard at pattern level; ignore-case documentation; promise-driven pin-lifetime test discipline; llm-branch mirror-PR norm; self-cycle probe norm). See gardener message entry to follow.

Review submitted: gh pr review 500 --request-changes
Copilot reviewer added: gh pr edit 500 --add-reviewer @copilot

Next step: fixer should address the must-fix-loop item (add @endo/daemon minor changeset). After fixer returns, the justice dispatches the re-run panel.

Recommended next stage per dispatch: next: liaison

Self-improvement: nothing this time.
