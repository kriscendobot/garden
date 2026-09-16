---
title: "Same-key tests and composite identity"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-February/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2007-February.txt.gz
source_content_sha256: eb45a908d56a85900169ab30b1eb82afd2548b07fea7c9453c1154e6aafbf74e
source_authors: [Charles Landau, Jonathan S. Shapiro, Mark S. Miller, Dean Tribble, David Hopwood, Bill Frantz, Jed Donnelley, Norman Hardy, Pierre-Antoine Champin, Sandro Magi, Valerio Bellizzomi, James A. Donald, Toby Murray, Alan H. Karp]
source_date: 2007-02-03 to 2007-02-19
thread_subject: '"Same" key / "Composite"'
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The "same key" discussion asks what an equality test should mean when references may be facets, proxies, forwarders, or composite objects. Pointer identity is too concrete for distributed and mediated references; behavioral equivalence is generally undecidable; and declaring two facets "the same" may reveal that they share an implementation, violating abstraction.

Participants explore protocol-based sameness, trusted comparison services, and composites that present one identity while delegating operations to several components. Every choice exposes a different fact. A same-key test can support maps, deduplication, and rights amplification, but it can also pierce transparent forwarding or disclose relationships the authority graph otherwise hides.

The thread leaves the taxonomy contested. Its durable rule is to specify which identity relation an API promises. Endo's pass-invariant reference identity is one such relation; it is not a universal claim that two objects with the same effects or the same target are interchangeable.

Source: [cap-talk 2007-February archive](http://www.eros-os.org/pipermail/cap-talk/2007-February/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2007-February.txt.gz`, sha256 `eb45a908`), messages dated 2007-02-03 to 2007-02-19.
