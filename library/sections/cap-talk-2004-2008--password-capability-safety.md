---
title: "Safety of password capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2005-March/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2005-March.txt.gz
source_content_sha256: f75852dba389e7d5a48d34f10c7a7a91086b5e2a35bec652c065385673684e76
source_authors: [Alan H. Karp, Valerio Bellizzomi, Bill Frantz, Nick Szabo, Ben Laurie, Jed Donnelley, Mark S. Miller, David Hopwood, Joe Duffy]
source_date: 2005-03-08 to 2005-03-21
thread_subject: "Safety of Password Capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The password-capability thread asks what entropy, channel protection, replay discipline, and introduction protocol are sufficient when possession of a bit string conveys authority. The participants distinguish online guessing from offline disclosure, bootstrap from steady-state traffic, and bearer tokens from public-key references. A long random token can make guessing negligible, but no bit length prevents a debugger, log, crash dump, or compromised endpoint from copying it.

Public-key bootstrap changes which material may be exposed and can make introductions work across weaker media, while shared secrets can be cheaper after a channel is established. Replay protection and resource-exhaustion defenses are separate protocol obligations; making the capability unguessable does not make every message using it fresh or affordable to verify.

The unsettled boundary is local handling. Advocates treat careful runtimes, proxies, and protected storage as normal implementation layers. Critics see those layers as evidence that a password capability's copyability shifts rather than removes the trusted-computing-base burden. The thread supports web-keys, but not the shorthand that an unguessable URL is automatically safe in every surrounding system.

Source: [cap-talk 2005-March archive](http://www.eros-os.org/pipermail/cap-talk/2005-March/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2005-March.txt.gz`, sha256 `f75852db`), messages dated 2005-03-08 to 2005-03-21.
