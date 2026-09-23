---
title: "Cap'n Proto, zero-copy messages, and untrusted-memory boundaries"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2013-May/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2013-May.txt.gz
source_content_sha256: 5fd900ed69fc73a40f1cb4e1c580e3a0ed7370d2ad3adab9fa909b733c99198e
source_authors: [Jonathan Shapiro, Ben Laurie, Kenton Varda, Bill Frantz, Daira Hopwood, Norm Hardy, Zooko Wilcox-O'Hearn]
source_date: 2013-05-01 to 2013-05-21
thread_subject: "CapNProto and other ocap-relevant technologies"
ingested: 2026-09-16
ingested_by: scholar
topics: [distributed-objects, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The Cap'n Proto launch discussion tests zero-copy serialization against a hostile sender that may mutate shared memory between reads. Laurie states the kernel rule: copy arguments before validating them, because a value that can change between validation and use creates a time-of-check/time-of-use attack. Varda's narrower rule is to validate each pointer access and read each field at most once, copying only values that require compound validation; both sides agree that code at an untrusted shared-memory boundary must be written with unusual care. Frantz adds a capability lesson from a CapROS web-key server: assume the front end will be compromised and keep the secret-to-object mapping behind a narrower process facet that cannot enumerate all entries.

The exchange also contrasts CapIDL's native-ABI, statically typed, bounded-message priorities with Cap'n Proto's extensible wire representation. The lasting design point is not that zero-copy is safe or unsafe in the abstract. Safety depends on who can mutate the backing bytes, whether accessors revalidate, and whether consumers accidentally retain views across turns.

## Bearing on Endo

An Endo or OCapN decoder must treat bytes supplied across a trust boundary as attacker-controlled until converted into immutable validated values. Performance optimizations that retain mutable transport buffers need an explicit single-read and lifetime argument; ordinary application code should receive copied or deeply immutable data.

Source: [cap-talk 2013-May archive](http://www.eros-os.org/pipermail/cap-talk/2013-May/) (Internet Archive original-bytes `id_` snapshot of `2013-May.txt.gz`, sha256 `5fd900ed`), thread "CapNProto and other ocap-relevant technologies", 2013-05-01 to 2013-05-21.
