---
title: "Constructor, hidden authority, and confinement"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-July/
source_snapshot: http://web.archive.org/web/20160729213013id_/http://www.eros-os.org/pipermail/cap-talk/2002-July.txt.gz
source_content_sha256: ee71d69933927d841b62efccf6b115303a1c835dfeed30868da5fdd5c34f54f8
source_authors: [Amir Livne, Sandro Magi, Jonathan S. Shapiro]
source_date: 2002-07-23 to 2002-07-24
thread_subject: "Question about What is a Capability, Anyway?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Livne challenges an EROS collaboration example: code that can read another user's secret might copy it to a developer-controlled log or forward the capability. Shapiro's answer makes the Confinement Myth's missing premise concrete. The user, not the developer, controls the program's initial authorities; EROS Constructor (and an analogous E mechanism) lets the user ask whether the program has any hidden outward channels before granting the secret. Almost no EROS program begins with outside access. A program can transmit the secret or its capability only through a communication channel the user supplied. Logging is therefore an explicit jointly authorized channel, not an ambient entitlement of the developer.

## Authority is supplied at instantiation

Writing the code does not give its author a live reference from the instantiated program. Constructor validates the closure of reachable authorities and rejects a supposedly confined instance that already reaches a log, network, or collaborator. This is the object-capability model's access-controlled delegation channel in operational form.

## Logging exposes the real policy choice

A useful application may need a log, but that need does not justify ambient logging. The user passes a logging capability just as they would pass stdout. If both developer and user regard the contents as sensitive, later debugging becomes a consent problem: the user may need to decide whether to disclose a log they cannot safely inspect. The thread leaves that human policy issue open while keeping the authority boundary exact.

Source: [cap-talk 2002-July archive](http://www.eros-os.org/pipermail/cap-talk/2002-July/) (Internet Archive original-bytes snapshot `web/20160729213013id_/.../2002-July.txt.gz`, sha256 `ee71d699`), messages dated 2002-07-23 to 2002-07-24.
