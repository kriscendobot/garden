---
title: "Single-use capabilities in existing systems"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-September/
source_snapshot: http://web.archive.org/web/20160730010609id_/http://www.eros-os.org/pipermail/cap-talk/2003-September.txt.gz
source_content_sha256: 5fb31ec62affbe3433b9434885bee48621e4c91a8457cc32b739c14592165e02
source_authors: [Gernot Heiser, Jonathan S. Shapiro, Bill Frantz]
source_date: 2003-09-27 to 2003-09-30
thread_subject: "Sngle-use capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns]
status: current
notes: "Derived summary, not the original messages. The subject's typo is preserved only in thread_subject."
---

Abstract: Asked for precedents for single-use capabilities, Shapiro identifies EROS and KeyKOS resume capabilities and recalls Kerberos single-use tickets; Frantz adds the more general construction that most capability systems can implement a one-shot object. The exchange distinguishes a primitive with consume-on-invoke semantics from a reusable capability to an object that enforces the same state transition.

## Primitive and constructed forms

An EROS or KeyKOS resume capability is consumed by resuming the waiting domain. More generally, a wrapper can hold a target, atomically replace it with a used-up state on first invocation, and forward only that invocation. Single-use behavior therefore does not require a universally special capability type, though a system primitive can provide stronger scheduling or atomicity guarantees.

Source: [cap-talk 2003-September archive](http://www.eros-os.org/pipermail/cap-talk/2003-September/) (Internet Archive original-bytes snapshot `web/20160730010609id_/.../2003-September.txt.gz`, sha256 `5fb31ec6`), messages dated 2003-09-27 to 2003-09-30.
