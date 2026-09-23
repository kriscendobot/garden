---
title: Connection to the wider library
source: designs/chat-rename-dismiss-to-clear.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8e5058304b08a4ec590a8bdcc799f78b321d5726
source_date: 2026-05-20
source_authors: [Kris Kowal]
topics: [chat-ui, repository-governance]
status: current
notes: |
  **Status: Complete** upstream (PR #93, merged 2026-05-06). A bounded
  PR-merge decision record + post-implementation retrospective. The
  document's small size (75 lines, four subsections) is honestly
  captured as a single library section rather than padded to a
  three-section ingest. The retrospective is structurally interesting
  for three reasons: (1) explicit *deprecation-period alias* retention
  pattern on the CLI side; (2) chat-vs-CLI alias asymmetry (chat had
  not shipped the command pre-rename, so no deprecation surface
  needed there); (3) *roadmap calibration* — explicit git-blame
  analysis of active-development calendar with three implementation
  bursts separated by long unattended gaps (2026-03-17 / 2026-03-20 /
  2026-05-06).
parent: endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record
---

This section is the **canonical worked example of a *PR-merge decision record + post-implementation retrospective*** at the chat-UI level. Three threads:

1. **The deprecation-period-alias retention pattern.** Rename a command, keep the old name as a hidden alias. Reusable for any user-facing command-rename in the corpus.

2. **The chat-vs-CLI alias asymmetry.** Only add deprecation surface where there are existing users to migrate. *Minimal-deprecation-surface* discipline.

3. **The roadmap-calibration introspection.** Git-blame post-merge to document actual cycle-time across design / implementation / merge phases. Lets future planning calibrate against historical baselines.
