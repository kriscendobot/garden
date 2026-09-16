---
title: "Limited transfer of permission does not limit authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-December/
source_snapshot: http://web.archive.org/web/20160729214122id_/http://www.eros-os.org/pipermail/cap-talk/2003-December.txt.gz
source_content_sha256: 81cd626bf08ec752bad5fde52e29efeb1019d34f157cf69d4ce89a90f05f5e22
source_authors: [Netta Ganor, Taral, Jonathan S. Shapiro, Seth Arnold, Ben Laurie, Mark S. Miller]
source_date: 2003-12-09 to 2003-12-19
thread_subject: "Enforcement of limited transfer of capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Asked how A can give B a capability while preventing B from passing it onward, the list separates enforceable token policy from effective authority. A kernel can tag a permission non-transferable, decrement a transfer TTL, or make a proxy accept calls only from B. None prevents hostile B from serving as a proxy for C. Shapiro's verdict is concise: limited transfer can be implemented but is not useful as a security boundary; in computation it is expensive, advisory, and historically provides no security benefit. Miller applies *Paradigm Regained*'s new vocabulary: limited propagation of **permission** is trivial in an object-capability system, while limited propagation of **authority** appears unenforceable in any system once the holder can communicate.

## The proxy defeats token controls

The operating system can observe movement of a c-list entry but cannot distinguish B's own requested effect from an effect B performs for C. Special hardware or attestation does not change this unless it also assumes the application will not collude. That additional assumption is confinement or trusted behavior, not non-copyability.

## Connection to the 2003 papers

The first response points directly to *Capability Myths Demolished* for confinement; Miller points directly to *Paradigm Regained* §2 for permission and authority. The thread is therefore a near-immediate application of both papers: it shows why analyzing representation or graph edges alone can claim a restriction that behavioral composition erases.

Source: [cap-talk 2003-December archive](http://www.eros-os.org/pipermail/cap-talk/2003-December/) (Internet Archive original-bytes snapshot `web/20160729214122id_/.../2003-December.txt.gz`, sha256 `81cd626b`), messages dated 2003-12-09 to 2003-12-19.
