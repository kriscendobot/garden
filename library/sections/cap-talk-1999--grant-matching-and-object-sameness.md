---
title: "Grant matching and object sameness"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-April.txt.gz
source_content_sha256: 9303164e97395ed5fbf794f7ffaef257609bbb0d72c28e12e29457ac8ed375b6
source_authors: [Charles Landau, Mark S. Miller]
source_date: 1999-04-18
thread_subject: "US Patent 5,301,316"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Landau describes a protocol for testing a relationship between objects A and B without handing either object unrestricted authority over the other: A nominates a comparison object C, B accepts C only if it recognizes and trusts it, then C performs the comparison. A simpler weakened-proxy construction lets B compare against A without exposing A, but Miller points out that the full protocol supports **grant matching**, while either form still needs a primitive symmetric sameness test so one participant cannot lie about which comparison authority it received.

## Comparison authority as a separate facet

The nominated C has enough authority to inspect the relevant internals of A and B, but exposes only the comparison operation. This is rights attenuation by interface: the comparison facet is deliberately weaker than either original object.

## Why primitive sameness remains

Agreement on the comparator has no security meaning unless both parties can determine they are referring to the same C. A primitive such as KeyKOS `DISCRIM` anchors the protocol. The exchange is an early bridge from operating-system reference identity to E's later object-sameness and distributed grant-matcher work.

Source: [cap-talk 1999-April archive](http://www.eros-os.org/pipermail/cap-talk/1999-April/) (Internet Archive original-bytes snapshot, sha256 `9303164e`), messages by Charles Landau and Mark S. Miller, 1999-04-18.
