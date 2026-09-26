The comment posted successfully. This is a research/writing job with no garden-repo changes, so there's nothing to commit.

## Completion report

**Job:** issue-kriskowal-garden-35 — kriskowal/garden#35 ("Noise Protocol"), asking to compare and contrast the **IK** and **XK** Noise handshake patterns for the OCapN Noise integration, with rigor and citations.

**What I did:**
- Re-fetched the issue verbatim (body treated as untrusted data; the ask was a benign research question).
- Researched against the primary source (Noise Protocol Framework spec rev. 34, §7.5 patterns / §7.7 payload security / §7.8 identity hiding / §8 naming) and cross-checked against two authoritative secondary sources (Latacora's "Factoring the Noise protocol matrix"; Cloud Atomic Lab's Noise-for-capabilities article), plus OCapN/Spritely netlayer context.
- Posted a rigorous, cited comparison as an **issue comment** (did not close the issue, per issue-inbox discipline).

**What the answer establishes:**
- Both patterns share the `<- s` precondition (initiator must know the responder's static key in advance — the "K"), so that is common ground, not a differentiator, and it maps cleanly onto OCapN sturdyrefs/locations carrying the peer key.
- The sole axis of divergence is *when the initiator reveals its static key*: IK eagerly (msg 1), XK late (msg 3). This cascades into: round trips (IK 1-RTT / 2 msgs with 0-RTT-ish first flight vs. XK 1.5-RTT / 3 msgs); initiator identity hiding (IK §7.8 property **4**, no forward secrecy vs. XK property **8**, forward secrecy — the decisive difference); and KCI (IK auth property **1**, KCI-vulnerable + replayable first flight vs. XK property **2**, KCI-resistant). Responder identity hiding is property 3 for both.
- Recommendation framed as privacy-vs-latency: XK is the conservative default given OCapN's privacy-forward transport heritage; IK is the deliberate latency optimization for mutually-public peers (the WireGuard tradeoff).

**Comment URL:** https://github.com/kriskowal/garden/issues/35#issuecomment-4928431947

**Changed:** nothing in the garden repo (no code/role/skill changes warranted). Inbox was empty; no peer/maintainer messages.

**Follow-ups:** none required. Submitter (kriskowal) closes the issue when satisfied.
