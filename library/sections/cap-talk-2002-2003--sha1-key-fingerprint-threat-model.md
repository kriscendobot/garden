---
title: "Why SHA-1 for key fingerprints?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-September/
source_snapshot: http://web.archive.org/web/20160730010609id_/http://www.eros-os.org/pipermail/cap-talk/2003-September.txt.gz
source_content_sha256: 5fb31ec62affbe3433b9434885bee48621e4c91a8457cc32b739c14592165e02
source_authors: [Tyler Close, Trevor Perrin, Zooko, Hal Finney, David Hopwood]
source_date: 2003-09-18 to 2003-09-26
thread_subject: "Why SHA-1 for key fingerprints?"
ingested: 2026-09-16
ingested_by: scholar
topics: [decentralized-identifiers, capability-security, content-addressed-storage]
status: current
notes: "Derived summary of a 2003 cryptographic discussion, not current algorithm guidance."
---

Abstract: The YURL fingerprint thread asks which hash property protects a self-authenticating public-key reference. Collision resistance alone is not the whole threat model: an attacker needs a colliding encoding that a client accepts as a usable key and for which the attacker can exercise the private operation. Selective or partially selective second-preimage attacks may give enough control over an RSA key encoding to meet that condition. The participants choose the conservative SHA-1 recommendation over faster MD5 because known structural weakness creates uncertainty about the eventual shape of an attack, while hashing a small public key makes the measured speed difference operationally negligible. This is historical reasoning from 2003, not present-day approval of either hash.

## The attack must produce usable authority

A random second preimage that contains an unfactorable RSA modulus is not automatically useful to the attacker. But public-key encodings expose degrees of freedom, and a selective attack may preserve a chosen modulus or otherwise produce data interpreted as a key the attacker controls. The relevant security property therefore depends on both the hash and the accepted key format.

## Conservative choice under uncertainty

The thread notes that MD5 had not then suffered a demonstrated full collision or preimage break, but weaknesses in its compression function made the next cryptanalytic advance unpredictable. Assuming that future damage would stop neatly at ordinary collisions was a risk, not a proof. SHA-1 or a truncated SHA-1 fingerprint cost only a few microseconds for a typical key, so participants found little reason to spend that risk budget on performance.

Source: [cap-talk 2003-September archive](http://www.eros-os.org/pipermail/cap-talk/2003-September/) (Internet Archive original-bytes snapshot `web/20160730010609id_/.../2003-September.txt.gz`, sha256 `5fb31ec6`), messages dated 2003-09-18 to 2003-09-26.
