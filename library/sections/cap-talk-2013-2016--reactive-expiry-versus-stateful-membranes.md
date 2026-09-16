---
title: "Reactive expiry versus explicit stateful membranes"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2013-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2013-November.txt.gz
source_content_sha256: a68e1852c176ea46ddfdefede9abaf2fa5c4d91ff3add2be8918fad5926b4533
source_authors: [William Leslie, David Barbour, Mark S. Miller, Rob Withers, Bill Frantz, Kevin Reid]
source_date: 2013-11-01 to 2013-11-06
thread_subject: "how to extend a capability on a data source?"
ingested: 2026-09-16
ingested_by: scholar
topics: [revocation, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Barbour contrasts the classic explicit revoker or membrane — mutable forwarding state that must be installed with foresight and recursively wraps capabilities crossing the boundary — with a reactive model in which grants expire and are continuously replaced. Renewal makes visibility, audit, attenuation, and revocation uniform, and limits a temporary leak's useful lifetime. It also makes the security promise depend on renewal timing, clock assumptions, latency overlap, and partition behavior. Miller's repeated request for a concrete example remains unanswered in the thread, leaving the claim that dataflow eliminates explicit membranes unproven.

The exchange usefully separates a policy from its enforcement mechanism. Persisting code that decides future grants is not the same as persisting the granted capability. Expiry can approximate revocation, but it is neither immediate nor free: a recipient retains authority until the current grant expires, and a distributed system must define how renewal behaves under partial failure.

Source: [cap-talk 2013-November archive](http://www.eros-os.org/pipermail/cap-talk/2013-November/) (Internet Archive original-bytes `id_` snapshot of `2013-November.txt.gz`, sha256 `a68e1852`), thread "how to extend a capability on a data source?", 2013-11-01 to 2013-11-06.
