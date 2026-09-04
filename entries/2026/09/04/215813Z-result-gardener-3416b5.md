---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-04T21:58:17Z
---
---
kind: result
role: novice
repo: kriscendobot/minion.town
project: minion-town
---

Panel seat `novice` on kriscendobot/minion.town PR #89
(`designs/clip-formula-id-origin-and-content-gc.md`, +672; base `origin/main`,
head `9dcc205`).

### novice (top-down clarity, new-reader pass)

**Verdict:** request-changes

**Findings:**

- **must-fix** — § B.3 Provider 2 (`designs/clip-formula-id-origin-and-content-gc.md:275`):
  "the load-bearing correction to the earlier ``vhosts/*.json`` alone determines the
  graph claim" cites a claim **this document never makes**. The new reader stops,
  scans back for it, finds nothing, and loses confidence that they have been reading
  carefully. It is residue of a panel round addressed to a reader of an earlier draft.
  State it positively: "not every live record carries `contentRoot`; those are
  resolved live over CapTP." [proposed-rule: a design revised across panel rounds
  never cites "the earlier claim" — the published text is the only text its reader has.]
- **must-fix** — § A.2's mint-site table asks the reader to accept an **exhaustive**
  enumeration over four similarly-named modules (`site-registry-exo.ts`,
  `site-registry.ts`, `daemon-site-registry.ts`, `publish.ts`). Which is the live
  daemon-backed path, which the in-memory scaffold, and which the degraded branch is
  introduced *only inside the table cells the introduction should precede*. Since
  Part A's whole conclusion rests on the enumeration being complete, the reader must
  hold that module map first. Two sentences before the table fix it.
  [proposed-rule: name the set before the table that enumerates it, when a conclusion
  rests on the enumeration being exhaustive.]
- **should-fix** — ~45 lines and six bolded metadata blocks (Status, Mandate, Grounded
  against, Companion, Terms, Cross-document reference key) stand between line 1 and
  § A.1, the first plain statement of the problem. **Terms** front-loads seven terms
  (exo, exo store, exo pin, manifest/`contentRoot`, CAS) the reader has no use for
  until Part B and will have forgotten by § B.1. Lead with § A.1's concern; gloss
  terms at first use.
- **should-fix** — Parts A and B are joined only by "one mandate". The actual
  connective — Part A's own three-publish run is what *demonstrates* the leak — sits
  unannounced in § B.1. One clause in **Status** makes the document one argument
  instead of two stapled reports.
- **should-fix** — two different `pin`s, unsignposted. **Terms** defines the exo
  `pin` (a formula id in the daemon's exo store); § B.1/§ B.7 discuss
  `ClipStore.pin()`, a no-op on the fs store. § B.7's "this GC never calls `pin()`"
  then reads as contradicting § B.8's dropping the exo pin. Name them apart at first
  use in Part B. [proposed-rule: novice secondary surface — a term may be defined and
  still leave the mental model unbuilt when one word names two mechanisms.]
- **comment-only** — § B.3 prose density: the "Containment narrows but does not
  remove this" and "Can a Provider-2 record arise in production" paragraphs run
  ~200 words each, and the `captp-vhost-table.ts` gloss is a 45-word definition
  nested inside a sentence about something else. Split; lift the gloss out.

**Notes (out of scope but worth flagging):**

- § B.4's worked dedup-race sequence (clip A -> unpublish -> guest B republishes ->
  404) and § B.6's dedup-floor warning ("an operator expecting three and seeing one
  is seeing a correct GC") are the two places the document teaches rather than
  asserts. They are the model the rest of Part B should follow.
  [rule: roles/jurors/novice/AGENT.md § Operating norms (e) example clarity]
- The honest-scoping passages in § A.3 (what the run proves and does not, the owner
  dimension) read clearly and need no change. [rule: skills/panel-review/SKILL.md]

Self-improvement: no role or skill gap surfaced this run; the novice brief's
category (a) "logical progress" caught the dangling back-reference and category (b)
"assumed background" caught the module-set gap, so the existing operating norms were
sufficient. One observation worth the gardener's attention if it recurs: a design
revised across multiple panel rounds accumulates corrections phrased *against the
prior draft*, which read as dangling references to anyone who only sees the final
text — the `[proposed-rule]` in finding 1 above is the candidate encoding.
