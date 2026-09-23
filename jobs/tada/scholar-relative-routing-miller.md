The work is complete. Here is my completion report.

---

## Completion report — `scholar-relative-routing-miller`

Ingested Mark Miller's notion of **relative routing** into the cross-cutting reference library, abstracted and derived per the scholar conventions (erights' derived-from-not-the-original framing carried on every file; the erights CapTP pages additionally self-declare public domain).

**Research finding.** The concrete erights grounding is CapTP's three-vat Granovetter introduction: the withdraw op `acceptFrom(donorPath :String[], donorID :VatID, nonce :Nonce, vine :Vine)` carries a **route list** (named `vatASearchPath` in the companion narrative) — *"in case the acceptFrom message arrives in Carol's vat before Alice's vat has even connected."* A peer is named by durable identity (VatID / public key); *how to reach it* travels separately as a plural, ephemeral set of candidate routes. This is the direct ancestor of the OCapN peer-locator's **connection hints** (designator + transport are identity; hints are only for routing) and Endo's ephemeral `@hint` locator parameters.

**What changed (all landed on `origin/journal2`, verified present on tip):**
- **Concept page (centerpiece):** `library/concepts/relative-routing.md` — core idea, the erights `donorPath`/search-path grounding, the CapTP/OCapN connection-hints mapping, and a Sections table linking 2 new erights sections + 7 existing corpus sections; see-also + common-confusions.
- **2 web sources / 2 sections:** `erights--elib-distrib-captp-providefor` (three-vat narrative) and `erights--elib-distrib-captp-acceptfrom` (the `donorPath` route list), fetched via the erights.github.io mirror, content-SHA anchored.
- **Project note:** `projects/minion-town/ocap-mailbox-relative-routing.md` — frames the email-backed synthetic guest and in-daemon OCapN-over-Noise session as two *routes* to one peer (short-circuit to the nearest reliable path); cites the PR #37 review directive.
- **Indexes:** `topics/captp.md` (+2 rows), `concepts/README.md` (+1), `keywords.md` (+2 pointer lines), `sources/README.md` (+2), `projects/minion-town/README.md` (new Topic-notes index); `sections/README.md` and `topics/README.md` counts regenerated (captp 62→64).
- **Integrity gate (step 8): PASS** — `library-link-check --changed` and per-cluster checks OK; `regenerate-topics-counts --check` current after land. Result entry `entries/2026/08/14/063309Z-result-gardener-c483a7.md` posted.

**Follow-ups:** The rest of the erights `elib/distrib/captp/` hub (4tables, resolving, dagc, partition, SturdyRef, LocatorUnum/NonceLocator, WormholeOp, the OMG presentation) remains un-ingested — noted here as a candidate future `scholar-ingest-erights-captp` cluster job, not posted, since it is a larger ingestion distinct from this concept-scoped ask.

Self-improvement: the erights CapTP pages self-declare public domain (stronger than the derived-from license), yet the derived-from framing still reads correctly on every file — the convention degrades gracefully when the source license is more permissive than assumed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-relative-routing-miller.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3961897 cached reads)
- Output: 37333 tokens
- Cost: $4.1679005
- Wall-clock: 774s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
