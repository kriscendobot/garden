---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T08:33:00Z
---
---
kind: result
role: critic
repo: kriscendobot/endo-but-for-bots
project: endo
pr: 997
---

Design-panel seat `critic` on kriscendobot/endo-but-for-bots PR #997
(`designs/worker-retention-and-revocation.md` + `designs/README.md` sync),
diff base `16fa8ebcc726ef4979cbc62e5f73a878cc922eee`, head `5445ad950`.

### critic

**Verdict:** request-changes

**Findings:**

- (must-fix) **Thread 3 and Q4 contradict each other on explicit drop messages, and the contradiction hides a premature-collection hole.** Thread 3 (`designs/worker-retention-and-revocation.md:283-286`) endorses "explicit refcounted import/export protocols (SwingSet's `dropImports` / `retireExports`)" as the protocol-level alternative to local-GC-driven GC. Q4 (`:705-718`) then rejects `op:gc-exports` as a "local-timing artifact" because it is finalizer-emitted, yet Thread 1 (`:96-106`) says `deliverDropExports` fires "*because* the vat's own finalizer observed the drop". Same provenance, opposite verdicts. The discriminator Thread 3 actually needs: a message on the wire is a protocol fact whatever prompted the sender; what is forbidden is keying on *your own* GC or inferring a remote's state from timing. This matters because `op:gc-exports` is the only fact telling the exporter that a counterparty dropped a **direct import** of the anonymous intermediate. Releasing on resolution alone (Decision 6, `:821-828`) collects an intermediate the counterparty still holds, producing exactly the "a working reference just went bad" class Thread 1 rules out (`:159`). Fix by either scoping the `question` edge to intermediates never exported past the question, or admitting sender-attested drop as authoritative for the exported case. [proposed-rule: a design that classifies a wire message as authoritative-or-not must state the discriminator once and apply it consistently to every message it names.]

- (should-fix) **Thread 2 to Thread 5 hand-off is unspecified.** Thread 2's conclusion (`:270-274`) says Thread 5 supplies the sugar's liveness interval, but Thread 5 releases "unless something durable claimed a name" (`:474`) and the whole point of the sugar is *not* naming. The real hand-off is the new formula's static dependency edge, which the doc never names, nor its atomicity against the `question` edge dropping first: a fourth zero-refcount window beside the three at `:556-584`. [proposed-rule: when a design gives a transient root a release trigger, it must name the durable edge that takes over at release and the atomicity between them.]

- (should-fix) **Decision 1's fail-safe makes its own recommendation inert.** "Unknown provenance implies kill" (`:786-792`) means kill-the-worker fires universally until the Thread 1 open question (`:924-930`) is answered, so "prefer forwarder-mediated revocation" reads stronger than it is. Separately, Decision 2's own authority (the CapTP export table) does record *whether the daemon ever seated a slot in a given worker*, even if not current liveness, so provenance is partly decidable today; the open question should say which half is genuinely open. [rule: roles/jurors/critic/AGENT.md § Operating norms, secondary premise-integrity surface]

- (should-fix) **Q2 bound 3 mislabels rejection as backpressure** (`:614-629`). Refusing a send is a partition-shaped failure imposed on an honest deep-pipelining peer, unlike the metering precedent it borrows (delivery withheld, budget refills, sender eventually served). Also state that a cap over the transitively-pinned closure makes admissibility depend on exporter-side union-find topology the peer cannot predict. [proposed-rule: a design may call a mechanism "backpressure" only when the refused work is later admitted; a permanent refusal is named as the failure it is.]

**Notes (out of scope but worth flagging):**

- `:424-426` calls `persistence: 'orthogonal'` + `upgrade: 'succession'` "the thixotrope name-hub plan exactly", while `:412` and `:441` give thixotrope `upgrade: 'none'`, "no upgrade, by design". Reconcile default versus plan in one clause.
- `designs/README.md` now asserts both "152 designs" (historical **Totals** paragraph) and "151 designs" (**Current totals**, which states it supersedes the historical summaries) for the same 2026-08-16 addition. Editing a superseded historical block propagates the conflict rather than recording it. [rule: designs/AGENTS.md § Progress Tracking, Cross-document]

Self-improvement: the critic brief's premise-integrity slice is sharpest when applied *within* one document, comparing a thread's stated discriminator against how a later thread applies it. Worth adding to `roles/jurors/critic/AGENT.md` § Operating norms as a named check: scan for a rule the design states once and then applies inconsistently to a second instance of the same kind.
