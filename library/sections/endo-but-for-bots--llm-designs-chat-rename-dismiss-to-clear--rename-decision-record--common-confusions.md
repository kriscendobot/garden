---
title: Common confusions
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

- **"`clear` and `dismiss-all` are different actions."** No — they are the same daemon action (`dismissAll()`) under two user-facing names. The rename changes the user-facing name; the underlying capability is unchanged.
- **"The chat side should have an alias too."** No — chat had not shipped the command pre-rename, so there were no existing chat users with `/dismiss-all` muscle memory. The CLI did have users, so the CLI gets the alias. The *minimal-deprecation-surface* discipline.
- **"The 65-day calendar timeline is a red flag."** It is honest about the *actual* cadence — three brief implementation bursts separated by long unattended gaps. The work was straightforward; the gaps reflect attention being elsewhere. *Calendar time != active-development time* is a common observation in small-feature work.
- **"The hidden alias is dead code."** It is *deprecation-period scaffolding*. Eventually it will be removed; until then, it carries scripts and muscle memory through the rename without breakage. The regression test ensures the alias remains functional.
- **"Tab completion is a separate concern from the rename."** It was — and the §design noted them as separate. The tab-completion shortest-common-prefix advancement *landed alongside* the rename; the §Status note that *a follow-up audit would confirm it on the current chat-bar implementation* signals the tab-completion feature was implemented but its current state should be audited.
- **"Renaming for `clear` collides with other commands."** Not in this corpus — `clear` was unused before this rename. If it had been used, the rename would have needed to *disambiguate*; instead, it simply *appropriated* the previously-unused name.
- **"The §Roadmap calibration is just retrospective navel-gazing."** It is *actionable for future planning*: any future small-rename should expect a similar 1-2-month calendar window with three implementation bursts. The post-merge introspection makes the cadence visible for planning.
