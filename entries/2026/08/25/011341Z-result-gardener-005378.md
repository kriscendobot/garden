---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-25T01:13:42Z
---
---
kind: result
role: critic
repo: endojs/endo-but-for-bots
project: endo
pr: 1058
---

Design-panel critic block for endojs/endo-but-for-bots PR #1058
(`designs/hardener-indexed-cardinality.md`, head 568da89ad9, base origin/llm).

### critic

**Verdict:** request-changes

**Findings:**

- **must-fix.** § Design, the `baseFreezeAndTraverse` "becomes" snippet, hoists
  the prototype enqueue *above* the descriptor read. Today both copies read
  `descs` first (`packages/harden/make-hardener.js:385-389`,
  `packages/ses/src/make-hardener.js:193-195`), and the comment directly above
  that read states the reason: get the outbound links "before a Proxy has a
  chance to do something sneaky." The hoist puts a `getPrototypeOf` trap call,
  and therefore arbitrary user code, ahead of that snapshot on the **generic**
  path, which the design elsewhere asserts is untouched ("The prototype enqueue
  keeps its existing placement and gating in each copy" contradicts "is hoisted
  above the now-guarded descriptor block" three paragraphs later). The
  reordering is also unnecessary: `const descs = purelyIndexed ? undefined :
  getOwnPropertyDescriptors(obj);` before the unchanged prototype block
  preserves the original order in both copies. Either adopt an order-preserving
  edit or state and defend the reorder against that comment's intent.
  [proposed-rule: an optimization design that reorders operations on a path it
  claims is behavior-preserving must name the reorder and reconcile it with any
  existing comment that fixes the order.]

- **should-fix.** § Correctness Argument's load-bearing rationale for the
  conjunction is inverted. "Each conjunct is the other's engine-independent
  backstop, so the fast-path classification has no single lemma whose failure
  opens it" does not hold: both conjuncts are evaluated against the *same*
  `Reflect.ownKeys` snapshot, and the intrinsic `length` counts only elements.
  An `ownKeys` that **omits** an expando (exactly the family of non-conformance
  the file already documents for GraalJS, where `ownKeys` and
  `getOwnPropertyDescriptor` disagree about what exists) yields
  `keys.length === len` *and* an index-shaped last key: both conjuncts pass
  together and the fast path fails open. The count conjunct's backstop is
  asymmetric, catching extra or mis-spelled keys, never a missing one. Worse,
  today's caller performs a second, *independent* enumeration
  (`getOwnPropertyDescriptors(obj)`) that would still surface such a key and
  enqueue its outbound reference; the fast path deletes precisely that
  redundancy, so "extends that belt-and-suspenders posture to the
  classification itself" reads backwards. Restate the residual honestly: the
  fast path narrows own-key truth to a single source.
  [proposed-rule: a design that claims two checks are independent backstops
  must show they do not derive from a common source of truth.]

- **should-fix.** § Implementation and Test Plan defers the `freezeTypedArray`
  parity check between the two hand-mirrored copies to "a candidate follow-up",
  while this PR is the change that first introduces a cross-file *behavioral*
  contract (a return value plus a caller guard) between them. The fail-safe
  polarity argument covers a missed mirror; it does not cover later divergence
  in the slow path that one copy gains and the other does not. The parity check
  belongs in the PR that raises the cost of divergence.
  [proposed-rule: the PR that first creates a cross-file behavioral contract
  between duplicated modules carries the parity test, rather than deferring it.]

**Notes (out of scope but worth flagging):**

- § Implementation and Test Plan declines to state any speedup figure on
  reproducibility grounds, then hard-codes an unmeasured 2x abandonment gate
  and speculates the change is "plausibl[y]" abandoned because `Reflect.ownKeys`
  dominates. A trivial V8 harness simulating both shapes on a 64 KiB
  `Uint8Array` puts the ratio near 5x (`ownKeys` alone is roughly the whole
  fast-path cost). Keep the gate; drop the unsupported worry, or hold the
  threshold to the same epistemic standard as the figure it withholds.
  [proposed-rule: a design that withholds a measurement as unreproduced should
  not assert an unmeasured threshold that would kill the change.]
- Premises verified and sound: `isCanonicalIntegerIndexString` exists and does
  not throw on symbols, the toStringTag brand check and the intrinsic `length`
  getter are both available, the SES copy's prototype enqueue is indeed
  unconditional, the stale "non-configurable" comment is real, and Lemma 2's
  five rejected keys (including `"-0"`) all throw on V8 as claimed.
- The doc is dense with em-dashes; whether the garden's rule reaches project
  design docs is the pedant's call. [rule: skills/em-dash-style/SKILL.md]

Self-improvement: the critic brief's rationale-vs-reality slice paid off here
only because I read the two `make-hardener.js` copies rather than the design's
schematics. Worth encoding in `roles/jurors/critic/AGENT.md`: when a design
quotes a "becomes" diff of existing code, open the real file, because the
before-snippet is where elision hides a behavior change.
