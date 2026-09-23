---
title: "Objects, facets, state, and behavioral identity"
source_kind: mailing-list-archive
source_urls: [http://www.eros-os.org/pipermail/cap-talk/2006-August/, http://www.eros-os.org/pipermail/cap-talk/2006-December/]
source_snapshots: [https://web.archive.org/web/20160730011119id_/http://www.eros-os.org/pipermail/cap-talk/2006-August.txt.gz, https://web.archive.org/web/20160730000949id_/http://www.eros-os.org/pipermail/cap-talk/2006-December.txt.gz]
source_content_sha256: [a6d23673f434cf7ae5939b986d73a18ef9a55295e89e776abbecb4da5a9caaed, 0f6b36648ebb51457e36d479105213dc2394c8ad45ac2786b7d1324412a2bbed]
source_authors: [Neal H. Walfield, Eric Northup, Charles Landau, Jed Donnelley, Alan H. Karp, David Hopwood, Toby Murray, Mark S. Miller, Ian Grigg, Norman Hardy, Jonathan S. Shapiro, Bill Frantz, Valerio Bellizzomi, John Carlson]
source_date: 2006-08-02 to 2006-12-31
thread_subject: "Objects and Facets"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, patterns, exo]
status: current
notes: "Derived summary across two monthly bundles, not the original messages."
---

Abstract: A facet is not merely a smaller interface pasted onto one implementation object. In the capability model, distinct non-identical references with different behavior are distinct capabilities; they may be understood as facets of a conceptual composite when they coordinate over shared logical state. Implementation sharing does not determine the security abstraction.

Neal Walfield's Hurd file example separates a durable File from each OpenFile cursor. Eric Northup and Charles Landau classify the factory, per-open cursor, and read-only/append-only/read-write views by their externally visible state and behavior. The December continuation exposes a terminology fault line: programming-language semantics often identify an object by behavior, while mainstream programmers use “object” for a state-bearing implementation and “interface” for a view. Miller and Landau retain the capability-level account while Shapiro warns that vocabulary detached from programmer practice impedes adoption.

For Endo exos, the useful rule is behavioral: each facet reference is an authority-bearing object in its own right, even when several facets close over one state record. Whether documentation calls their aggregate “the object” is secondary; guards, identity, and authority analysis must follow the references callers actually receive.

Source: cap-talk [2006-August](http://www.eros-os.org/pipermail/cap-talk/2006-August/) and [2006-December](http://www.eros-os.org/pipermail/cap-talk/2006-December/) archives (Internet Archive original-bytes snapshots, sha256 `a6d23673` and `0f6b3664`), messages dated 2006-08-02 to 2006-12-31.
