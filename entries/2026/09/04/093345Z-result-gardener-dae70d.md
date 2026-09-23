---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-04T09:33:47Z
---
role: decomplector
re: design panel, kriscendobot/minion.town PR #88 (design/clip-immutable-nonce-locator, head 56c2ea8, base origin/main)
diff: designs/clip-immutable-nonce-locator.md (new, 635 lines) + supersession notes in designs/clip-ocap-synthesis.md

### decomplector (simple-vs-easy / complecting lens)

**Verdict:** request-changes

**Findings:**

- **[should-fix] The locator complects *the name of the backend* with *the grant of access to it*.** § 3.1 makes the locator be the backend's own randomly-numbered formula number, so naming and authorizing are one act. The design then pays for that braid three times without naming it as one decision: § 10 Q2 can only answer revocation as "mint distinct randomly-numbered formulas, drop one to revoke" (l.610) — a grant cannot be withdrawn without replacing the object; § 10 Q3 must give each invitee a *separate backend* to differentiate authority; and § 4 must ask, per upgrade, "same persisted backend or freshly minted." Q2, Q3 and § 4's branch are three faces of one modeling choice. The decomplected primitive is one backend plus a **per-grant revocable forwarder**: the locator names the forwarder, so rotation is dropping a forwarder, attenuation is minting a narrower one, and backend identity never moves. § 3.1's own swissnum framing points this way — a swissnum names a *grant*, not the object. Ask: state in § 3.1 whether a locator names the backend or a per-grant forwarder, and collapse Q2/Q3 into that one decision. [proposed-rule: a design that carries a bearer secret must state whether the secret names an object or a revocable grant on it, because revocation, attenuation and rotation all follow from that one choice.]

- **[should-fix] § 8 unit 2 pre-decides § 10 Q1 and re-braids a mutable place into the registry.** Unit 2 requires the design "say how `listSites` exposes succession so an old hash resolves to the current clip" (l.545). That is a mutable successor *place* plus a *resolution* step — precisely what § 6.1 keeps out ("never a resolver … never a minter") and what § 2's no-re-point policy is written against, and exactly the tension Q1 says is still open. Either decide Q1 in-doc and reconcile § 6.1, or strip the succession clause from unit 2 and gate the unit on Q1. [proposed-rule: a design's follow-on unit list must not presuppose the answer to one of that design's own open questions; if a unit needs the answer, gate the unit on the question.]

- **[should-fix] § 8 unit 5 braids content publication with authority granting.** § 4 is careful that registration "yields the **origin only**; the registry never mints or hands back a locator" (l.331), then unit 5 asks guest-side `publish` to return `liveUrl`/`sessionLocator` — one publish, one locator, welded into the publish result. That contradicts the § 4/§ 6.1 separation in spirit, forces a locator on a clip with no live backend, and forecloses Q3 (a second share should not require republishing content). Split the verbs: `publish(content) → origin`, and a separate `mintLiveLink(grant) → live link`. The stated goal (a guest never hand-concatenates a capability into a URL) is served by the second verb alone.

**Notes (out of scope but worth flagging):**

- § 5 discloses that multi-locator origins share one `localStorage`; note that this is a property of the *origin*, so no locator-layer change (including the forwarder above) fixes it — per-party isolation needs distinct origins. Worth one sentence in § 5 so a later design does not reach for it. [proposed-rule: when a design names a guarantee that a later section shows the underlying substrate cannot carry, say which layer must carry it instead.]
- § 2.1's place-vs-value admission (the origin labels a mutable directory, so immutability is policy not representation) is honestly stated and correctly parked at Q7. No further decomplector objection; that is round-1 addressed.
- Testability of unit 6's security-shaped assertions is a code-panel concern (breaker/assessor), not raised here.

Self-improvement: the seat brief tells the decomplector to walk categories and stop at what the design claims; this design's real yield was not a hidden braid but a *named* one whose costs were split across three separately-numbered open questions. Worth encoding in `roles/jurors/decomplector/AGENT.md`: when a design's open-questions list contains several entries, check whether two or more are consequences of a single modeling decision, and say so — an open-questions list that fans one choice into N questions hides the choice.
