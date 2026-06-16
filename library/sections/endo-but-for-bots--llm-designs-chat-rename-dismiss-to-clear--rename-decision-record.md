---
title: The completed PR #93 merge record for renaming `dismiss-all` to `clear` across CLI + Chat; the tab-completion-collision motivation; the deprecation-period alias retention pattern; the 65-day active-development calendar with three implementation bursts; the chat-vs-CLI alias asymmetry (CLI retains hidden alias; chat had not yet shipped the command pre-rename so needed no deprecation surface)
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record--common-confusions.md)
