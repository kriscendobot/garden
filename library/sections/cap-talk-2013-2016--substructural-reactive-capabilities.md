---
title: "Substructural types and continuously granted capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2013-September/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2013-September.txt.gz
source_content_sha256: 7d43c3f3a66a09c692701dba04915eb1eab28a489a1d12ed86bbe73c41bd87d4
source_authors: [David Barbour, Alan Karp, Mark S. Miller, David Mercer, Tony Arcieri, Rob Meijer, David Wagner, Jack Rusher, Ben Kloosterman, William Leslie]
source_date: 2013-09-11 to 2013-09-13
thread_subject: "Capabilities interact nicely with Substructural Types and Reactivity"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, revocation, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Barbour's Awelon proposal combines reactive dataflow with affine, relevant, and linear types. A capability is not sent once and forgotten; it is continuously granted by a signal, so stopping or replacing the signal supplies uniform revocation and makes current grants visible. Substructural constraints add static control over copying and dropping authority, while a capability to a uniqueness source replaces ambient creation of identity, mutable state, GUIDs, and sealer pairs. Miller counters that E's `DeepFrozen` auditor already provides useful determinism and confinement for immutable values, exposing a disagreement over whether ordinary object creation and identity are ambient authorities that must themselves be budgeted.

The proposal is attractive precisely where its semantics differ from message passing. Continuous replacement can bound the lifetime of a leaked reference, but it also moves liveness, renewal, and partition behavior into the security contract. Linear or affine treatment can prove that a reference is not duplicated in the typed fragment, but cannot by itself prevent an authorized holder from proxying effects.

Source: [cap-talk 2013-September archive](http://www.eros-os.org/pipermail/cap-talk/2013-September/) (Internet Archive original-bytes `id_` snapshot of `2013-September.txt.gz`, sha256 `7d43c3f3`), thread "Capabilities interact nicely with Substructural Types and Reactivity", 2013-09-11 to 2013-09-13.
