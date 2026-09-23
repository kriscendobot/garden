---
title: "Principal attribution, proxies, and confinement"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-July/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-July.txt.gz
source_content_sha256: 3262da95439fd9dab4a1736482fa651abb9f59818a159ea2bb168092e6137a45
source_authors: [Jonathan S. Shapiro, Dave Long, Bill Frantz]
source_date: 1999-07-01
thread_subject: "feasibility of principal-based access control"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The thread disputes whether a capability system can reliably attribute an action to a human principal. Stamping a process or capability records which stamped reference performed the action, not who chose or caused it: A may act directly, hand the capability to B, create a proxy for B, or be tricked into using it. Confinement controls a program's channels, but it does not stop the legitimate controller from proxying for someone else. Shapiro concludes that audit trails can establish capability provenance but cannot recover the administrator's desired flesh-and-blood attribution; Frantz restates the mandatory-security motivation as distrusting programs run by trusted users.

## A stamped capability proves less than a principal label suggests

An audit record saying "X was written using a capability stamped A" is compatible with several causal stories. Because A can always interpose a proxy, forbidding capability copying or stamping the immediate caller cannot distinguish them. The limitation is semantic, not a missing logging feature.

## What confinement does and does not promise

Confinement can ensure that a program has no unauthorized leak channel and can protect the program from outside interference. It cannot authenticate the ultimate person directing a proxy, nor prevent the authorized client from handing control of the whole confined service to another party. Wrappers remain useful for exposing only a weaker operation set, but the wrapper itself is delegable.

## Open contention

The participants agree that unrestricted software holding authority can expose it. They do not fully converge on whether restricted compartments plus principal labels can enforce useful principal-based policies. The later November thread resumes this disagreement.

Source: [cap-talk 1999-July archive](http://www.eros-os.org/pipermail/cap-talk/1999-July/) (Internet Archive original-bytes snapshot, sha256 `3262da95`), messages by Jonathan S. Shapiro, Dave Long, and Bill Frantz, 1999-07-01 to 1999-07-19.
