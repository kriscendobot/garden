---
title: "Storage garbage collection and covert channels"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-July/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-July.txt.gz
source_content_sha256: 3262da95439fd9dab4a1736482fa651abb9f59818a159ea2bb168092e6137a45
source_authors: [Jonathan S. Shapiro, Mark S. Miller, Bill Frantz]
source_date: 1999-07-15
thread_subject: "GC'd capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [persistence, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Shapiro records a Miller-originated design question about garbage-collecting persistent capability objects: should reclaimed storage return to the prime bank or to the bank that allocated it? Returning it to the allocator makes loss of the last reference observable, creating a storage covert channel. Frantz sharpens the result: either destination leaks if another party can observe capacity changing, whether by a query or a failed allocation. His only clean partition is fixed, non-overcommitted storage pools per security compartment.

## Reclamation changes an authority boundary

Reference-driven reclamation is not merely a storage optimization. When the allocator regains quota after the last capability disappears, it can infer an event in another holder's reference graph. Sending storage to a global bank changes the observer but not the information-flow problem.

## Checkpoints as collection boundaries

Miller also observes that a checkpoint is a natural generational boundary for collecting in-memory objects created since the prior snapshot. That optimization composes with persistence, but it does not erase the covert-channel question for quota accounting.

The open issue remains directly relevant to Endo's retention graph: "no longer retained" is potentially sensitive state, and any visible quota refund can become a signaling channel.

Source: [cap-talk 1999-July archive](http://www.eros-os.org/pipermail/cap-talk/1999-July/) (Internet Archive original-bytes snapshot, sha256 `3262da95`), discussion attributed to Jonathan S. Shapiro, Mark S. Miller, and Bill Frantz, 1999-07-15 to 1999-07-21.
