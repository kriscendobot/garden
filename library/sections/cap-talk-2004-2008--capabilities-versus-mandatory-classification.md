---
title: "Capabilities versus mandatory classification systems"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2006-January/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2006-January.txt.gz
source_content_sha256: 37d1e0a9dbb184307e8c807bcf4b7d09f842f2b55f0de245a519c654d4b173e3
source_authors: [David Wagner, John McCabe-Dansted, Marc Stiegler, Jed Donnelley, Alan H. Karp, Rob Meijer, David Hopwood]
source_date: 2006-01-01 to 2006-01-08
thread_subject: "Capabilities vs. Classifications - MLS systems?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The January 2006 exchange separates discretionary object authority from mandatory information-flow policy. Capabilities answer which operations an object may invoke through its references. A multilevel-security classification answers whether information may flow between security levels, including constraints a holder must not be able to delegate away. Neither mechanism subsumes the other without extra assumptions.

Participants dispute whether one-way IPC is useful, how taint-like labels should propagate, and whether a capability system can implement comprehensive mandatory policy through confined mediators. The capability side points out that mandatory policy can be built as a layer of objects and restricted communication paths. The classification side points out that an overt reference graph does not by itself control every covert channel or encode non-discretionary organizational rules.

The result is a composition rule: use capabilities for designation, least authority, and explicit collaboration; add an information-flow or mandatory-policy mechanism when the threat model requires it. Calling both mechanisms "access control" hides their different subjects and failure modes.

Source: [cap-talk 2006-January archive](http://www.eros-os.org/pipermail/cap-talk/2006-January/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2006-January.txt.gz`, sha256 `37d1e0a9`), messages dated 2006-01-01 to 2006-01-08.
