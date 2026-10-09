---
role: gardener
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-09T08:23:15Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gauntlet must-fix summary: wire into the PR comment, notice, and journal record

Parent: gauntlet-early-termination-unaddressed-must-fix-summary (maintainer request 2026-10-09; full spec in its jobs/tada report or the journal job history). Goal: when scripts/jobs/gauntlet.sh ends early (review-budget-reached / halted / parked-ci-billing; held-draft owes none), summarize the UNADDRESSED must-fix requests so the maintainer can decide whether to add budget and resume. Today only a count is shown (gauntlet.sh:333, scraped from "must-fix items (N):"). See designs/gauntlet-panel-fix-nonconvergence.md (the findings set moves round to round). Land directly on main2.

## This slice
Wire the renderer (from gauntlet-mustfix-summary-renderer) into every early termination. (a) gauntlet_terminal_comment: keep the one-line receipt and append the summary in a collapsed, size-bounded <details> block under the same idempotency marker. (b) The gauntlet_notify coalesced notice: include the summary and the exact resume command, using --add-rounds from gauntlet-mustfix-summary-add-rounds, and say what budget it adds. (c) A journal record next to the gauntlet record. Say in roles/ or context/ that the minion.town arc supervisors act on this record, since the maintainer does not review individual minion.town PRs (journal entries/2026/10/07/203746Z-message-gardener-a253b1.md). Add tests for each terminal state, and confirm a parse failure never wedges a tick or drops the terminal state. Then post a journal message summarizing the change, with one worked example rendered from a real past halt (for example endojs-endo-but-for-bots-pr995-gauntlet).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-09T08:28:27Z
