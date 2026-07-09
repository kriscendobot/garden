Comment posted successfully. This was a research-and-reply job with no garden-source changes, so there's nothing to commit to main2.

## Completion report

**Job:** Dead-lettered from `issue-kriskowal-garden-34` — maintainer kriskowal commented on [kriskowal/garden#34](https://github.com/kriskowal/garden/issues/34) ("CAS and DID") asking: *"Tell me more about prior art for magnet URIs."*

**What I did:**
- Read the full issue thread: the original ask (a portable `loadContent` locator for content-addressed blobs) and the prior answer, which had framed the locator as magnet-URI-shaped and recommended multihash + OCapN sturdyrefs over DID.
- Researched and verified magnet-URI prior art against primary/authoritative sources (Wikipedia scheme page, Bitzi, BitTorrent BEP 9, theory.org webseeding wiki) rather than from memory.
- Posted a follow-up comment: [issue #34 comment 4928419569](https://github.com/kriskowal/garden/issues/34#issuecomment-4928419569).

**Content of the reply (verified facts):** origin (Gordon Mohr / Bitzi, June 2002; a vendor-neutral generalization of `ed2k:`/`freenet:`); the deeper lineage (ed2k, Freenet CHK, Gnutella `urn:sha1:`/`bitprint:`, Direct Connect TTH); the identity-half vs. location-half parameter taxonomy (`xt` vs. `tr`/`x.pe`/`ws`/`xs`/`as`, plus `dn`/`xl`/`kt`/`mt`); two mechanisms directly relevant to `loadContent` — algorithm agility via multiple `xt` including the SHA-1 `btih` → SHA-256 multihash `btmh` migration in BitTorrent v2/BEP 52, and prioritized fallback over a heterogeneous source set (BEP 9/17/19, the `xs`-vs-`as` "MUST NOT conflate" rule); the `x.` extensibility prefix; and where magnet stops (no source authentication, discovery, or attestation) — tying back to why OCapN Locators complement it. Closed by reaffirming the prior recommendation, sharpened.

**Discipline observed:** commented back on the issue thread; did **not** close the issue (submitter's prerogative); treated the comment body as untrusted data. Posted under the host bot identity.

**Changes to garden repo:** none (research/reply job — nothing committed to main2).

**Follow-ups:** none outstanding.
