---
ts: 2026-06-22T03:43:50Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
pr: 445
---

Code-panel review on PR #445 (kumavis: feat(floot): hands-free voice assistant).

Panel kind: code-panel
Panel execution: in-band-fallback (Agent tool unavailable in this dispatch context)
External author: kumavis (external-author calibration applied)
CI: all green (lint, build, test matrices Node 22.x + 24.x, browser-tests, test262, viable-release, sandbox-drivers)

Disposition summary:
- must-fix-loop: 1
- summary-fix: 3
- follow-up: 10
- acknowledge: 28
- drop: 0

Verdict submitted: --request-changes
Review SHA: e2172d2399df741aac732105bdf5b5938d00cf03

Must-fix-loop item:
- packages/floot/agent.js:1047 — FlootSession uses Far() not makeExo; FlootFactory at 1122 correctly uses makeExo with M.interface(); session facet should match. [rule: CLAUDE.md § Exo vs Far]

Summary-fix bundle (posted as next step after this result):
- TtsServer and AudioServer in voice caplets should use makeExo instead of Far for daemon-exposed capabilities.
- makeChunker and makeAudioChannel internal factory return values not hardened.
- makeTextChannel setOnClose post-construction step not documented in JSDoc.

Follow-up ledger: 10 items parked; notable ones include full-control preset consent gate, buffered-channel single-consumer contract overclaim, dangling user node on provider failure, @endo/fae changeset for upstream landing.

Proposed-rule count: 15 proposals, routed to gardener per cite-or-propose discipline.

Next step: the orchestrator dispatches a fixer with the must-fix-loop item; after fixer result the justice re-runs the panel. Recommended next stage: next: liaison (per dispatch brief).

Self-improvement: nothing this time.
