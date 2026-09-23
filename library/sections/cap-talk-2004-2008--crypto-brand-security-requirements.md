---
title: "Security requirements for a cryptographic brand"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-March/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2007-March.txt.gz
source_content_sha256: 426bda7d3c76e995403018bfba2637c661473082e8246c6dd1154b3565dfecee
source_authors: [Tyler Close, Kevin Reid, David Wagner, Mark S. Miller, David Hopwood, Pierre-Antoine Champin, Zooko Wilcox-O'Hearn]
source_date: 2007-03-22 to 2007-03-25
thread_subject: "Implementing a crypto brand: What are the security requirements?"
ingested: 2026-09-16
ingested_by: scholar
topics: [patterns, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The crypto-brand thread translates the local sealer/unsealer or trademark pattern into a distributed setting. A verifier should learn that a value was marked by the matching brand without gaining the authority to mint new branded values. Cryptographic signatures are an obvious mechanism, but key ownership, replay, serialization, and what exactly is signed determine whether the result preserves the object-capability separation between marker and verifier.

The participants distinguish an assertion about bytes from an assertion about a live object reference. Serializing an object graph changes identity and may expose authority; a distributed brand therefore needs an explicit representation and threat model. Generic access to the brand-making operation is safe only because each invocation creates a fresh, unforgeable pair.

For Endo the thread is an ancestor of branded passable values and rights amplification. It warns that a cryptographic encoding is not automatically the same abstraction as a local brand: the verifier's observations and the holder's replay powers must be specified.

Source: [cap-talk 2007-March archive](http://www.eros-os.org/pipermail/cap-talk/2007-March/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2007-March.txt.gz`, sha256 `426bda7d`), messages dated 2007-03-22 to 2007-03-25.
