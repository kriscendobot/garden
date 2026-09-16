---
title: "IoT capabilities as cryptographic strings: state, attenuation, and collection"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-June/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-June.txt.gz
source_content_sha256: 3f9591683282a454f29b48fdad1748322e1d49fab036106b0cbab6bbdf7dc07f
source_authors: [Tim Coote, Norm Hardy, David Barbour, Rob Meijer, Alan Karp]
source_date: 2014-06-16 to 2014-06-23
thread_subject: "Object Capability model for IoT"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, distributed-objects, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Coote asks how an IoT capability crosses language, OS, and device boundaries without degenerating into “just a string.” The answer is that a string can carry capability semantics when it is unforgeable and possession authorizes a specific operation. The thread then exposes a representation tradeoff. A random sparse token requires an origin-side table mapping token to object; if tokens can move independently of connections, reclaiming unreachable entries becomes a distributed lifetime problem. A signed, MACed, or encrypted meaningful token can encode a stateless facet or attenuation directly, avoiding some table state, but makes caveat parsing, key rotation, expiry, and revocation part of the verifier's TCB.

The debate does not establish that meaningful tokens eliminate distributed collection for stateful objects. It establishes only that self-describing references can make some facets and pure computations locally discardable. Random and meaningful representations occupy different points between server state, token size, disclosure, rotation, and revocation.

Source: [cap-talk 2014-June archive](http://www.eros-os.org/pipermail/cap-talk/2014-June/) (Internet Archive original-bytes `id_` snapshot of `2014-June.txt.gz`, sha256 `3f959168`), thread "Object Capability model for IoT", 2014-06-16 to 2014-06-23.
