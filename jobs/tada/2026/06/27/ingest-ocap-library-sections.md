All work is landed and pushed; the supervisor will complete the job from my report. Here is the completion report.

---

**Job `ingest-ocap-library-sections` — complete (gardener 93, endolinbot).**

**Key finding:** the six maintainer-named topics already had their authoritative **sources** ingested in the library (OCapN CapTP/Locators drafts, the Miller papers, the `@endo` packages). The real gap was the **concept-layer synthesis** tying them together. So this cycle was high-leverage concept curation over existing sections rather than fresh source ingest. Landed on `origin/journal2` (commit `dc5d328e`, +378 lines).

**Curated per topic:**
- **Three-party hand-off** → new `concepts/three-party-handoff.md`, grounded in OCapN CapTP § Third Party Handoffs (Gifter/Receiver/Exporter, `deposit-gift`, signed `desc:handoff-give`/`desc:handoff-receive`). The Granovetter operator across CapTP sessions.
- **Sturdyrefs** → new `concepts/sturdyref.md`, grounded in OCapN Locators § Sturdyref (Peer Locator + `swiss-num`) + Concurrency Among Strangers §9.2 offline capabilities. *Initial Conditions* made durable.
- **Distributed confinement** → new `concepts/distributed-confinement.md`, grounded in Paradigm Regained §5 (Cassie/Max factory, data diode, non-discretionary capabilities) + the *Confinement Myth*. Confinement within a vat (SES) and across vats (CapTP).
- **Eventual send** → new `concepts/eventual-send.md`, grounded in `@endo/eventual-send` (`E()`/`HandledPromise`/`E.when`) + CAS vat/event-loop model. Umbrella over the pre-existing `promise-pipelining` and `handler-protocol`.
- **Grant matching** → new `concepts/grant-matcher-puzzle.md` (status: **draft**). Identified as Mark Miller's erights.org *Grant Matcher Puzzle* (equality + transport, capability man-in-the-middle, POLA). **This is the one topic with no in-corpus source** — erights.org/caplet.com were unreachable (`ECONNREFUSED`) at ingest. Written from a web-search summary, **explicitly flagged external lineage**, with an honest "source not yet ingested" banner.
- **Pass-invariant equality** → already had `concepts/pass-invariant-handle-equality.md`; cross-linked it to grant-matcher-puzzle (its canonical *why*) and three-party-handoff (the transport counterpart).

**Cross-linking:** added bidirectional See-also backlinks into the five pre-existing concepts (`granovetter-operator`, `four-ways-to-acquire-references`, `pass-invariant-handle-equality`, `object-capability`, `promise-pipelining`). The six interlock exactly as the maintainer predicted. Registered all five new concepts in `concepts/README.md` (new "Distributed-ocap cluster" block) and appended 43 keyword lines to `keywords.md`.

**Follow-ons posted (deferred plans):**
- `scholar-ingest-grant-matcher-puzzle` (normal) — fetch & ingest the erights.org source when reachable; promote the draft concept to current.
- `scholar-ingest-passable-equality` (low) — broaden equality beyond the Handle-side instance into `@endo/marshal`/`@endo/patterns` (`keyEQ`/`compareKeys`/`sameKey`).

**Bulletin:** synthesis sent to the maintainer via `message-user`.

**Topic whose authoritative source I could not locate:** grant matching — erights.org down; concept written honestly from a search summary and source-ingest deferred behind the follow-on.

Sources consulted for the one external gap: [The Grant Matcher Puzzle (erights.org, unreachable)](https://erights.org/elib/equality/grant-matcher/index.html), [caplet.com mirror (unreachable)](http://www.caplet.com/security/taxonomy/grant-match/grant-matcher.html), [awesome-ocap](https://github.com/dckc/awesome-ocap), [Spritely](https://spritely.institute/).

Self-improvement: the highest-value scholar move on a "ingest topic X" ask is to **check the corpus for already-ingested sources first** — here 5 of 6 topics needed only concept synthesis + cross-linking, not source ingest, which kept the cycle well within budget and avoided redundant re-ingestion. Worth encoding in the scholar role: *survey existing sections/concepts before assuming a topic needs fresh source ingestion.*
