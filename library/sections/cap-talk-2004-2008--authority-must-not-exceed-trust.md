---
title: "Should authority be bounded by function or by trust?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-September/
source_snapshot: https://web.archive.org/web/20160729221706id_/http://www.eros-os.org/pipermail/cap-talk/2007-September.txt.gz
source_content_sha256: 5c996ecc049b8af06a89ece06c4c4e277929846188113332eb22d4af278e503d
source_authors: [Toby Murray, David Hopwood, Jonathan S. Shapiro, Jed Donnelley, David Wagner, Ihab Awad, James A. Donald, Ka-Ping Yee, Valerio Bellizzomi, Dean Tribble, Matej Kosik, Sandro Magi]
source_date: 2007-09-17 to 2007-09-20
thread_subject: "Reinterpreting POLA - Authority Must Not Exceed Trust"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Toby Murray proposes replacing “no more authority than required for intended function” with “no more authority than we trust the component to wield.” The list does not accept this as a replacement for POLA: trust is observer-relative and often ill-informed, while least authority is valuable precisely because a trusted component should still receive only what it needs.

The purchase-order example motivates separation of duties: one instance may draft but not approve. Hopwood argues that distrust can remain even when a component satisfies POLA, so the notions are distinct. Shapiro adds that granting extra authority because a component is trusted reverses the security logic: limiting authority is part of why greater trust may be warranted.

The thread leaves a useful two-axis model. Functional necessity constrains the authority envelope; a user's trust judgment decides whether to run the component inside that envelope. Treating either axis as the other makes trojan authors define their own “intended function” or makes subjective confidence justify ambient authority.

Source: [cap-talk 2007-September archive](http://www.eros-os.org/pipermail/cap-talk/2007-September/) (Internet Archive original-bytes snapshot `web/20160729221706id_/.../2007-September.txt.gz`, sha256 `5c996ecc`), messages dated 2007-09-17 to 2007-09-20.
