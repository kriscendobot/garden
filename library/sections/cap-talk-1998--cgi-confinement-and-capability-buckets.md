---
title: "CGI confinement, authentication, and capability buckets"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-April.txt.gz
source_content_sha256: 15da6c5c47a7a927899b39778eb859e19fb64907f5fec97151eba49960fe76b8
source_authors: [Jonathan S. Shapiro, Ben Laurie]
source_date: 1998-04-21
thread_subject: "CGI scripts under EROS"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A web-server confinement discussion separates authentication, access, and scoping. A program can leak sensitive data only when it holds both a capability to that data and an outward communication capability. Unlike POSIX, where any process may open a socket, a capability system can omit network authority entirely or grant only a narrow authenticated connection. After authentication, the server maps the session to a least-authority **bucket of capabilities**; that bucket, rather than a global user identifier, is the operational identity. The thread leaves an important boundary explicit: unattended services cannot ask a sleeping administrator for every decision, so safe deployment still needs an advance policy about which capabilities enter the bucket.

## Confinement is about simultaneous authority

The confined CGI can safely see bank data if it has no unauthorized outbound channel. It can safely communicate if it is not simultaneously given sensitive data. A trusted mediator can narrow file or network access, ask a user where practical, and expose a smaller interface than the underlying subsystem.

## Authentication does not itself grant machine-wide identity

Authenticating an HTTP peer proves only what the application protocol establishes. The server then chooses a capability set sufficient for that session's functional contract. Shapiro's rule is the early operational form of POLA: grant the smallest and weakest set that makes the task work. A hands-off server must encode that choice beforehand, for example a temporary isolated store or read-only access to a named subset.

## Open edge: authenticated peer versus authorized channel

Laurie's question, how authority should vary with the party at the other end of the connection, does not reduce to kernel identity. The application must bind authentication evidence to a deliberately constructed capability set. This remains a live design problem for network gateways: transport authentication and application authority are separate stages, and ambient socket creation defeats confinement between them.

Source: [cap-talk 1998-April archive](http://www.eros-os.org/pipermail/cap-talk/1998-April/) (Internet Archive original-bytes snapshot, sha256 `15da6c5c`), messages by Jonathan S. Shapiro and Ben Laurie, 1998-04-21 to 1998-04-22.
