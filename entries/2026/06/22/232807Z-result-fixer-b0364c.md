---
ts: 2026-06-22T23:35:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/22/232100Z-dispatch-liaison-b0364c.md
---

Retcon of PR #290 (feat/lal-pi-harness) complete.

Responding to kriskowal comment https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4774038049 ("Please retcon.").

Reset to origin/llm-0458d1f, restaged in three commits:

- `139270131` refactor(daemon): export pet-name shapes from @endo/daemon/type-guards.js
- `e9a9afd96` refactor(lal): adopt @endo/genie pi-based harness; default ollama model qwen3.6; swap pi-agent-core/pi-ai to @earendil-works per llm convention
- `e068baf80` chore: Update yarn.lock

The earendil-swap commit (formerly a2a52c4b6) was folded into the lal pi-based-harness commit. Two yarn.lock commits consolidated into one.

New HEAD: e068baf80
Lease anchor (prior tip): a57e6a3f5
Net diff (a57e6a3f5..HEAD): empty — confirmed by git diff.
Tests: 17 passed, 1 skipped (simulator test requires LAL_HOST env).
Pre-push gates: yarn format — no changes; TypeScript errors in external deps are pre-existing, not introduced by this PR.
Force-push: succeeded with --force-with-lease=feat/lal-pi-harness:a57e6a3f5.
PR comment: https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4774071118

Self-improvement: nothing this time.
