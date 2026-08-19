---
gate: deferred
priority: low
role: designer
posted_by: producer
posted_at: 2026-08-19T17:47:04Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Explore: Proper Tail Calls (PTC) in Ironhorse

Repository: endojs/endo-but-for-bots, branch `llm`. Exploratory design —
survey feasibility and tradeoffs; do not commit to implementation.

## Why this is worth exploring, not just skipping

Ironhorse's test262 skip list excludes `tail-call-optimization`
(`rust/engine/ironhorse-262/src/xst.rs`, `DEFAULT_ENDOR_SKIP_FEATURES`)
because it mirrors XS's own `xst262.c` `gxFeatures` exclusion — XS (the
parity oracle) doesn't implement Proper Tail Calls either, so Ironhorse
doesn't need to for XS-parity. But `designs/ironhorse-engine.md`'s own
doctrine ("accuracy over parity") already has precedent for Ironhorse
*exceeding* XS where it's cheap and correct to do so (see
`designs/ironhorse-debugger-recovery-and-uncaught.md` § "Ironhorse Decisions
Informed by the XS Oracle": hooking `XS_CODE_RETHROW`, which XS does not,
and the target-opcode-peek classification, "strictly better than XS's flag
walk"). PTC is a real, spec-legal capability gap versus the full language
(not just versus XS) — worth a genuine feasibility look rather than a
permanent skip-by-default.

## Read first

- `designs/ironhorse-engine.md` § Interpreter and dispatch, § Metering — the
  stack/frame model and the metering doctrine PTC would have to fit inside.
- `designs/ironhorse-debugger-recovery-and-uncaught.md` — **the sharpest
  conflict to resolve first**: the interpreter's stack is explicitly "the
  same frame geometry as XS (frames are stack slots, arguments below the
  frame, fixed offsets)... because the debugger's frame walk, the exception
  machinery, and several opcodes observe that geometry." Proper Tail Calls
  by definition means a tail-position call does NOT grow the frame stack —
  directly in tension with a debugger that walks frames assuming XS's
  geometry. Any PTC design must say explicitly how frame-walking, the
  exception/catch-jump chain, and `CatchJump` snapshots behave across a
  tail call that reused its caller's frame, not just how the call itself
  executes.
- `rust/engine/ironhorse-262/src/xst.rs`'s skip-list doc comment and the
  `--features-include` mechanism it already provides — the plumbing to
  re-enable a skipped feature class for testing already exists.

## What the exploration should cover

- **Feasibility in the current dispatch/stack model** — can a tail call be
  recognized and its frame reused (or a trampoline substituted) without
  breaking the XS-geometry invariant above, or does PTC require a genuinely
  different frame representation that the debugger/exception machinery would
  also need to change to accommodate?
- **Metering interaction** — does eliminating a frame push/pop change the
  computron accounting for a tail call versus an ordinary call? The
  determinism doctrine (frozen per-release cost table) must still hold.
- **Snapshot/heap format interaction** — does a snapshot taken mid-tail-call
  need to represent anything XS's snapshot format doesn't, given XS never
  produces this shape?
- **Test262 validation without the oracle's help** — XS can't validate PTC
  cases via the normal dual-run differential (it doesn't implement the
  feature, so a real dual-run would just diverge by design). Sketch how
  `tail-call-optimization`-tagged cases would be validated once unskipped:
  single-engine pass/fail against spec-expected behavior, or some other
  oracle substitute.
- **Recommendation**: worth building, worth building later, or not worth
  the invasiveness relative to its value — with reasoning, not just a
  verdict.

## Deliverable

A design document (or, if the feasibility survey concludes it's not worth
pursuing, a shorter written-up finding explaining why, filed the same way).
No code. This is deliberately parked/deferred — no urgency, promote when
there's room.
