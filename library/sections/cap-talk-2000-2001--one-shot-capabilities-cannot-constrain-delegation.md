---
title: "One-shot capabilities cannot constrain delegation"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2000-October/
source_snapshot: http://web.archive.org/web/20160729232409id_/http://www.eros-os.org/pipermail/cap-talk/2000-October.txt.gz
source_content_sha256: 486a621c9fb731cda3eaf0cfedeec684899fe48d39394742ec06851b5a1bc182
source_authors: [Johan Hanson, Mark S. Miller, Gernot Heiser]
source_date: 2000-10-05 to 2000-10-06
thread_subject: "Bibliography on the web?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, revocation]
status: current
notes: "Derived summary, not the original messages. Added by the 2002-2003 completeness pass."
---

Abstract: Hanson's proposal for a primitive one-shot capability draws Miller's compact separation of two problems often conflated in capability design. Use-once authority is an easy derived right: a wrapper forwards the first invocation and rejects later ones. It does not constrain delegation. If each invocation returns a refreshed one-shot capability, Bob can wrap the chain in a `laundry` that updates its private target after every call and presents an ordinary reusable service to Mallet. Whatever authority Bob can repeatedly exercise, Bob can proxy for another party whenever they can communicate. This 2000 thread is a direct primary-source precursor to the 2003 permission-versus-authority analysis and the later conclusion that limiting transfer of a token does not limit propagation of its effective authority.

## Use-once is a wrapper policy

Miller demonstrates an E `once` wrapper whose private `used` flag permits one selected call and then fails. Revocation by invoking an unused one-shot capability with a null operation is therefore possible, but not primitive: ordinary composable objects already express it.

## Refresh recreates reusable authority

Hanson's stronger proposal returns a replacement capability after each invocation. Miller's counter-construction stores the latest replacement behind a reusable forwarder. Each call consumes the old token, installs the returned token, and remains ready for the next caller. Bob and Mallet can share this wrapper even though neither can duplicate any individual one-shot token.

The lesson is about authority, not representation: restricting how permission tokens are copied does not restrict the effects their holder can arrange through proxying. Enforcing non-delegation requires preventing the parties from communicating, which is the confinement problem.

Source: [cap-talk 2000-October archive](http://www.eros-os.org/pipermail/cap-talk/2000-October/) (Internet Archive original-bytes snapshot `web/20160729232409id_/.../2000-October.txt.gz`, sha256 `486a621c`), messages dated 2000-10-05 to 2000-10-06.
