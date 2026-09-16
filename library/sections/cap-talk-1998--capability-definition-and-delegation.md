---
title: "Capability definition and delegation"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-April.txt.gz
source_content_sha256: 15da6c5c47a7a927899b39778eb859e19fb64907f5fec97151eba49960fe76b8
source_authors: [Jonathan S. Shapiro, Gregory Frascadore]
source_date: 1998-04-02
thread_subject: "Challenge Solution: Card Keys, capabilities, counters"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Frascadore's follow-up to the founding ACL challenge asks whether the capability is the ticket, the protected pointer inside it, or the container. Shapiro answers that the useful first-order definition is a pair of **designation and permitted operations**: `(name, {operations})`. Unforgeability makes the name protected, but a name alone is incomplete because it does not say what the holder may do. The exchange also sharpens delegation: an owner-only ACL update rule prevents a recipient from creating helper tasks, while passing an already-authorized reference naturally lets the recipient delegate without asking the original owner to enumerate downstream callers.

## The capability is the ticket in ordinary use

Shapiro treats a password-protected ticket that resolves to a cached system capability as a reference to the operational capability, but calls that distinction an implementation detail. For practical reasoning, the ticket is the capability. What matters is that the holder cannot forge its designation and that the reference carries an operation set.

This corrects the shorter formulation "capabilities are protected names." Protection or unforgeability is necessary, but authority over operations is the other half of the abstraction.

## Delegation exposes the ACL mismatch

The earlier Java-style ACL solution made only the owner able to update an object's ACL. Recursive delegation breaks that model: B must be able to create C and authorize C to act on B's behalf without reporting C's identity to A. Turning "update the ACL" into another grantable operation begins reconstructing capability behavior inside the ACL scheme. Passing a reference already expresses both the designation and the bounded operation set without recovering caller identity.

Source: [cap-talk 1998-April archive](http://www.eros-os.org/pipermail/cap-talk/1998-April/) (Internet Archive original-bytes snapshot, sha256 `15da6c5c`), messages attributed to Gregory Frascadore and Jonathan S. Shapiro, 1998-04-02.
