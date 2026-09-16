---
title: "Overt and covert causality are relative to semantics"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-August/
source_snapshot: http://web.archive.org/web/20160730011654id_/http://www.eros-os.org/pipermail/cap-talk/2003-August.txt.gz
source_content_sha256: 5e810c0e660634ab1962bd7d813b20c4da59541075e6bb837e2f00c6e54d9614
source_authors: [Mark S. Miller, David Hopwood, Alan Karp]
source_date: 2003-08-26 to 2003-08-27
thread_subject: "Overt vs Covert (was: Paradigm Regained)"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The *Paradigm Regained* review produces a precise candidate boundary between overt and covert causality. The boundary is not an intrinsic property of hardware; it is relative to the platform semantics being modeled. A correct program depends only on specified semantics. Karp's test: a channel is covert if some possible implementation satisfying the same specification makes the channel fail; if every conforming implementation preserves it, the channel is overt in that model. Miller further proposes treating a channel as covert when its bandwidth per semantic operation can approach zero across conforming implementations. Timing, identity hashes, garbage collection, and analog coupling in digital circuits illustrate how changing the specified model moves the boundary.

## Why this matters to capability claims

Object-capability reachability constrains overt causality in the language model. That claim neither denies physical side channels nor grants an adversary an obligation to remain a correct program. Security evaluation must separately inspect out-of-model causality. Conversely, the existence of covert channels is not a reason to ignore the strong and analyzable restriction on overt channels.

## Open terminology

The participants distinguish intentional covert channels from accidental side channels but do not settle the vocabulary. Miller considers "in-model" versus "out-of-model" causality more accurate but cumbersome. The semantic relativity and conforming-implementation test are the durable contribution.

Source: [cap-talk 2003-August archive](http://www.eros-os.org/pipermail/cap-talk/2003-August/) (Internet Archive original-bytes snapshot `web/20160730011654id_/.../2003-August.txt.gz`, sha256 `5e810c0e`), messages dated 2003-08-26 to 2003-08-27.
