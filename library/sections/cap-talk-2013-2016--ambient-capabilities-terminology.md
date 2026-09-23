---
title: "Why 'ambient capability' obscures the authority source"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-November.txt.gz
source_content_sha256: 16d67afb822d498e7811b211a3d01958152a762f88ec60992542b51948768548
source_authors: [Tony Arcieri, David Barbour, David Nicol, Alan Karp, Bill Frantz]
source_date: 2014-11-03 to 2014-11-24
thread_subject: "Ambient capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The phrase “ambient capability” is contested because it combines a mechanism defined by explicit possession with authority available without an explicit reference. Some participants use it for powers inherited from an execution context; others argue that the useful diagnosis is simply **ambient authority**, regardless of whether an implementation internally represents that authority with capabilities. Calling it an ambient capability risks implying that ambient lookup preserves the designation-authority discipline.

The terminological test is operational: can the caller identify the particular passed reference whose exercise authorizes this action, or can it name a resource and rely on an implicit process, user, or global context? The first is capability use; the second is ambient authority even if a hidden layer eventually invokes a capability.

Source: [cap-talk 2014-November archive](http://www.eros-os.org/pipermail/cap-talk/2014-November/) (Internet Archive original-bytes `id_` snapshot of `2014-November.txt.gz`, sha256 `16d67afb`), thread "Ambient capabilities", 2014-11-03 to 2014-11-24.
