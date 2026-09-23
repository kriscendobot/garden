---
title: "What persistence should an object-capability language provide?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-July/
source_snapshot: https://web.archive.org/web/20160730003425id_/http://www.eros-os.org/pipermail/cap-talk/2008-July.txt.gz
source_content_sha256: 8951e6620a5f940b5df1e678f9cc1d8607a32aaceae8eb6afe9f72d3b01fc942
source_authors: [Rob Meijer, Toby Murray, Jonathan S. Shapiro, Mark S. Miller, Marc Stiegler, Ihab Awad, Baldur Johannsson, Mike Samuel, James A. Donald, Ivan Krstic, Sandro Magi, David Wagner, Valerio Bellizzomi, Bill Frantz, Alan H. Karp]
source_date: 2008-07-17 to 2008-07-29
thread_subject: "How desirable / feasible is a persistent OCAP language?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, persistence, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Orthogonal persistence makes an in-memory capability graph survive restart, but it does not by itself define upgrade, external-resource restoration, transaction, revocation, or partial-failure semantics. The thread values persistence while resisting the claim that one transparent mechanism can safely hide all lifecycle boundaries.

Participants compare E vats, persistent operating systems, databases, checkpointing, and explicit serialization. Transparent graph preservation retains identity and authority naturally, yet sockets, clocks, files, and remote peers require trusted reconnection policy. Schema and code upgrades can also invalidate assumptions embedded in old object state. Explicit persistence is more work but makes those boundaries visible.

Endo's durable formulas and vats sit on this exact line: preserve reference identity where the platform can, represent external reconnection through explicit powers, and make upgrade/retry semantics part of the application contract. The archive leaves the ideal division of responsibility open.

Source: [cap-talk 2008-July archive](http://www.eros-os.org/pipermail/cap-talk/2008-July/) (Internet Archive original-bytes snapshot `web/20160730003425id_/.../2008-July.txt.gz`, sha256 `8951e662`), messages dated 2008-07-17 to 2008-07-29.
