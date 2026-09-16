---
title: "Filesystem redirects as compositional revocation paths"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-November.txt.gz
source_content_sha256: 16d67afb822d498e7811b211a3d01958152a762f88ec60992542b51948768548
source_authors: [David Barbour, Rob Meijer]
source_date: 2014-11-05 to 2014-11-10
thread_subject: "Redirects and Revocation in a Capability Filesystem"
ingested: 2026-09-16
ingested_by: scholar
topics: [revocation, capability-security, distributed-objects]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A revocable filesystem redirect must propagate its cut through every descendant facet derived through that path. Storing a “breadcrumb” at every traversed node makes recursive revocation explicit but becomes expensive under chained or cyclic redirects. Encoding path provenance in the derived capability avoids eagerly materializing a membrane-shaped tree, but makes reference size and normalization part of the design. Two references to the same leaf reached through different redirect chains are operationally distinct because cutting different edges revokes them.

The thread rejects object identity alone as enough to characterize a filesystem capability. A derived reference carries both destination and delegation path. Cycles cannot simply be erased: repeated edges may be redundant, but a path that crosses additional independently revocable redirects has different behavior. This is a direct precursor to provenance-aware, lazy graph revocation.

Source: [cap-talk 2014-November archive](http://www.eros-os.org/pipermail/cap-talk/2014-November/) (Internet Archive original-bytes `id_` snapshot of `2014-November.txt.gz`, sha256 `16d67afb`), thread "Redirects and Revocation in a Capability Filesystem", 2014-11-05 to 2014-11-10.
