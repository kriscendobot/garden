---
title: "Deep attenuation and typed operations"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-August/
source_snapshot: https://web.archive.org/web/20160730010929id_/http://www.eros-os.org/pipermail/cap-talk/2007-August.txt.gz
source_content_sha256: ba52b60483eea763910169cee60d771da00a186ff66137aa6463554934f1523d
source_authors: [David Hopwood, Mark S. Miller, Jed Donnelley, Charles Landau, John Carlson, Sam Mason, Sandro Magi, Alan H. Karp]
source_date: 2007-08-12 to 2007-08-18
thread_subject: "Deep attenuation; Deep attenuation, typed operations"
ingested: 2026-09-16
ingested_by: scholar
topics: [patterns, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Shallow attenuation narrows one reference; deep attenuation also narrows capabilities obtained through it. A read-only directory should not yield a writable descendant, and a revocable membrane should apply temporal attenuation transitively. The hard part is expressing restrictions across heterogeneous object types without treating coincidental method names as one universal permission vocabulary.

Hopwood and Miller settle on “deep attenuation” because the term states the recursive property and covers restrictions, such as revocation, that are not bit masks. Landau sketches an operation by which a container asks each fetched capability for an attenuated form. The typed-operation discussion then exposes the interoperability problem: a `[read, file]` rule may reject a new file-like type or accidentally bless an unrelated `read` method.

The practical pattern requires an explicit translation protocol at the membrane boundary. Endo membranes and exo facets should recursively wrap returned references, but attenuation remains interface-aware: guards and facet constructors define what “read-only” means for each protocol rather than relying on global method-name permissions.

Source: [cap-talk 2007-August archive](http://www.eros-os.org/pipermail/cap-talk/2007-August/) (Internet Archive original-bytes snapshot `web/20160730010929id_/.../2007-August.txt.gz`, sha256 `ba52b604`), messages dated 2007-08-12 to 2007-08-18.
