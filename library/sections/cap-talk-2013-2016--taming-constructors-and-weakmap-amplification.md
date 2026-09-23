---
title: "Taming constructors and WeakMap rights amplification"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-May/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-May.txt.gz
source_content_sha256: 67fbda9dc765b198ab20531b417347caee8dd398e2a46f1a0eb5461fc21e4a56
source_authors: [Kevin Reid, David Nicol, Norm Hardy, Mark S. Miller]
source_date: 2014-05-01 to 2014-05-08
thread_subject: "Taming constructors?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The constructor-taming discussion distinguishes access to a public constructor from authority to mint instances carrying a privileged brand. ECMAScript `WeakMap` supplies a particularly direct rights-amplification mechanism: identity-keyed hidden state can implement sealer/unsealer pairs, or can associate privileged payloads with the actual purse or facet identity without allocating a separate sealed box. Miller's mint comparison shows why the direct WeakMap pattern can be both simpler and less authority-revealing than a generic sealer abstraction.

The security boundary is the closure holding the WeakMap, not the syntactic `new` operation. Taming must account for every path that can obtain the constructor, prototype, or branding table, while ordinary code can safely retain access to generic object construction. This is an early JavaScript statement of the pattern Endo later uses pervasively: lexical encapsulation plus hardened public facets, with identity-sensitive private state held outside the object.

Source: [cap-talk 2014-May archive](http://www.eros-os.org/pipermail/cap-talk/2014-May/) (Internet Archive original-bytes `id_` snapshot of `2014-May.txt.gz`, sha256 `67fbda9d`), thread "Taming constructors?", 2014-05-01 to 2014-05-08.
