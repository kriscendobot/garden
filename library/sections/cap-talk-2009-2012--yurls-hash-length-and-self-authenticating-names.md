---
title: "YURLs: hash length and self-authenticating names"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-April.txt.gz
source_content_sha256: f28a7548e567b27ebc011f3f9ada2db5c782e5f6867a33eb70614f9e5aa258a1
source_authors: [Tyler Close, David Barbour, David-Sarah Hopwood]
source_date: 2011-04-21 to 2011-04-25
thread_subject: "What is the implementation status of yurls?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, content-addressed-storage, identity]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: YURLs (Tyler Close's Waterken scheme) put a hash of a server's public key into the hostname, so a URL authenticates its endpoint without depending on DNS or a certificate authority. The thread is about how many hash bits that fingerprint needs. Close reported that Waterken's `genkey` tool truncates the key hash to a length keyed to the RSA key size (80 bits for a 1024-bit key, 112 for 2048, 128 for 3072 and above), matching numbers RSA published equating key strength to symmetric-security levels. David Barbour, favoring a design that uses the key hash for overlay-network routing (Chord, Pastry, or Tapestry) rather than DNS, argued the truncation is inappropriate for that more general use and warned that 80 bits invites natural birthday collisions at internet scale, on top of the historical tendency of secure hashes to be partially broken over time. David-Sarah Hopwood added the sharper cryptographic caution: hash preimage attacks are perfectly parallelizable, need negligible memory, and admit multi-target attacks, so finding a preimage for any one of 2^20 eighty-bit hashes costs about 2^60 work, not 2^80. Close's rebuttal was operational: from a single operator's perspective the odds remain one in 2^80, and an operator who dislikes those odds simply asks `genkey` for a longer hash.

## Sizing a self-authenticating name

The hostname-as-key-fingerprint design removes DNS and the certificate-authority hierarchy from the trust path: the name *is* the endpoint's identity, verified by hashing the presented public key and comparing. That makes the hash length a direct security parameter. Close's `genkey` ties it to the RSA modulus size so the fingerprint strength matches the key strength (he later corrected himself: the desired hash length determines the choice, not the reverse). Barbour's objection is about scale and threat model rather than per-server odds. If the fingerprint doubles as a routing key in a structured overlay, a hash short enough for one server becomes a collision liability across the whole namespace, and the long history of hash functions degrading below their nominal bit-width argues for headroom. Hopwood quantified the gap between the two viewpoints: multi-target preimage search means the attacker's cost is amortized across all targets, so a population of short hashes is far weaker than any single hash suggests. Close did not dispute the mathematics but held that an individual operator's risk is unchanged and adjustable, so the default is a defensible tradeoff, not a flaw.

## Bearing on Endo

Endo's cryptographic peer identity (`captp` endpoints keyed by a public-key hash, sturdy references that name a remote object without a naming authority) is the same self-authenticating-name design, so the hash-length budget is a live Endo parameter, not a historical curiosity. The lesson is that the fingerprint length must be sized against the *population* of names and the *multi-target, parallelizable* preimage threat Hopwood described, not against a single endpoint's odds, and with headroom for the hash function weakening over the deployment's lifetime. Where an Endo identifier also indexes a routing or discovery structure (Barbour's overlay case), the collision budget tightens further. This is the concrete continuation of the [2010 authority-carrying-URLs](cap-talk-2009-2012--authority-carrying-urls-in-the-wild.md) and [networking-named-content](cap-talk-2009-2012--networking-named-content-self-authenticating-names.md) threads.

Source: [cap-talk 2011-April archive](http://www.eros-os.org/pipermail/cap-talk/2011-April/) (Internet Archive original-bytes `id_` snapshot of `2011-April.txt.gz`, sha256 `f28a7548`), thread "What is the implementation status of yurls?", 2011-04-21 to 2011-04-25.
