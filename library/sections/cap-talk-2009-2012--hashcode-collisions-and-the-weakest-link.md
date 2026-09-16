---
title: "Hash collisions and the weakest link: relying on SHA-256 for Waterken ETags"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-February/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-February.txt.gz
source_content_sha256: 031e283291d79d59a055a829a4807556952bcb0bd03a28448ad9e3999d9dea35
source_authors: [Raoul Duke, Tyler Close, Jack Lloyd, David Wagner]
source_date: 2010-02-19
thread_subject: "use of hashcodes?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A short but clarifying February 2010 thread on whether it is sound to build a security- or correctness-critical guarantee on a cryptographic hash, given that hashes have collisions. The prompt was Waterken's use of an ETag ("two responses with the same ETag must yield the same text") for query caching. Tyler Close answers that Waterken's ETag is "a SHA-256 HMAC of all state and code used during a query" and dryly offers: "You'd have a pretty good paper if you could generate a collision." The substantive points come from two cryptographers on the list. Jack Lloyd reframes the risk from probability to *fragility*: the right question is not "how likely is a collision" but "what happens to the system if the assumption breaks," because some designs shatter completely on a single violated assumption (a reused DSA nonce reveals the private key) while others degrade gently. David Wagner supplies the load-bearing perspective: "Our ability to build secure cryptographic algorithms vastly exceeds our ability to build secure software," so a practical SHA-256 collision is "pretty far down the list" of risks to Waterken, and if it ever were the weakest link "Tyler has done an absolutely brilliant job of software engineering."

## From probability to fragility

Raoul Duke's worry was the naive one, that low probability is not zero probability and nobody discusses the implications of a collision ever occurring. Lloyd's answer moves the conversation off the probability axis. For a well-studied primitive like SHA-256 HMAC the best known attacks are brute force, and the true probability distribution over "someone publishes a break" is not something anyone can estimate honestly. What *is* worth doing is enumerating the blast radius of the assumption failing. His canonical contrast: reusing a nonce with DSA leaks the signing key outright, whereas reusing a nonce with RSA/PSS causes almost no damage. Knowing which class a system is in tells you how much defensive attention the assumption deserves, and gives you an early-warning trigger (a 2^100-time collision paper is impractical today but is the cue to begin migrating before it becomes trivial).

## The weakest-link principle

Wagner's framing is the one the library carries forward. Cryptographic building blocks are, in practice, the strongest components in a system; software is the weakest. So anchoring a correctness or identity guarantee on SHA-256 is sound engineering precisely because it moves the guarantee onto the strong component. The risk of a practical SHA-256 collision is real but dominated by many higher-probability software risks that deserve the attention first. Wagner explicitly endorses Waterken's design here as "well grounded in cryptographic principles and a solid, robust, well-thought-out design."

## Bearing on Endo

The question generalizes directly to every place Endo's lineage names or authenticates by content hash rather than by an unforgeable reference: content-addressed bundles and blobs, integrity hashes on fetched modules, and the hash component of a [[web-key]] or a sturdyref. This thread is the on-list statement of why that is acceptable engineering: the hash is not the weakest link, and building the guarantee on the strong component is the point (see [[content-address-versus-signature]] for the companion distinction between naming-by-hash and authenticating-by-signature). Lloyd's fragility lens is the standing discipline: when a design does rely on collision-resistance, document what breaks if it fails and keep an agility path to a stronger hash, rather than treating "collisions are improbable" as the whole safety argument.

Source: [cap-talk 2010-February archive](http://www.eros-os.org/pipermail/cap-talk/2010-February/) (Internet Archive original-bytes `id_` snapshot of `2010-February.txt.gz`, sha256 `031e2832`), thread "use of hashcodes?", 2010-02-19.
