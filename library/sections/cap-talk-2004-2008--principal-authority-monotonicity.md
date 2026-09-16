---
title: "When can a principal's authority increase?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-September/
source_snapshot: https://web.archive.org/web/20160730002051id_/http://www.eros-os.org/pipermail/cap-talk/2008-September.txt.gz
source_content_sha256: aec8fe517334dd773f25b70d8d5ab9880184c3bc03ec9e35606d1f5746893177
source_authors: [David-Sarah Hopwood, Marcus Brinkmann, Alan H. Karp, David Wagner, Raoul Duke, Toby Murray, Sandro Magi, Bill Frantz, Rob Meijer, Jed Donnelley, Jonathan S. Shapiro]
source_date: 2008-09-23 to 2008-09-26
thread_subject: "Whether principals' authority can increase"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Authority is not generally monotonic in either direction when the analyzed “principal” can receive messages, create objects, exercise stateful protocols, or benefit from another party's changed behavior. A static reachability graph bounds direct references at an instant; it does not prove that the set of effects available to an active principal can never increase.

The discussion separates acquisition of a new reference, amplification through a jointly held brand, changes in object state, and authority obtained because another principal voluntarily delegates. Claims of non-increasing authority require a closed-world model with explicit assumptions about incoming communication and trusted amplifiers.

For Endo authority analysis, the safe statement is conditional: absent inbound reference transfer, ambient channels, and recognized amplification protocols, graph reachability cannot spontaneously grow. Tooling should report those assumptions instead of presenting a snapshot as a temporal theorem.

Source: [cap-talk 2008-September archive](http://www.eros-os.org/pipermail/cap-talk/2008-September/) (Internet Archive original-bytes snapshot `web/20160730002051id_/.../2008-September.txt.gz`, sha256 `aec8fe51`), messages dated 2008-09-23 to 2008-09-26.
