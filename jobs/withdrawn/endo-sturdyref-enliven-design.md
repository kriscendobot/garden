---
withdrawn: true
withdrawn_reason: Absorbed, not promoted: the maintainer's 2026-09-30 layer-1 framing (endojs/endo-but-for-bots#695 directive) is a distinct SturdyRef global constructed with an enliven handler; child ebfb-sturdyref-layer1-shim-design-20260930 of orchestration ebfb-sturdyref-layering-20260930 reconciles this HandledPromise-enliven-trap vision in its design PR.
withdrawn_by: ebfb-sturdyref-layering-supervisor-20260930
withdrawn_at: 2026-09-30T04:37:35Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: designer
posted_by: producer
posted_at: 2026-08-10T22:48:44Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots (branch: llm)
role: designer
task: Propose a design (single PR, one proposal document) for a pass-style
sturdyref alternative built on HandledPromise, per this vision:

- Sturdyrefs are modeled as `HandledPromise`, not a bespoke reference type.
  Once enlivened, a sturdyref behaves like a presence.
- Add an `enliven` operator to the HandledPromise meta-protocol (a handler
  trap), optional to implement. When a handler implements it, invoking it
  produces a live reference for the referent — this is the mechanism by
  which a sturdyref becomes live.
- `HandledPromise.enliven` and `E.enliven` are the call-through surface:
  both dispatch to the underlying handler's meta `enliven` trap, mirroring
  how `E.get`/`E.call` dispatch to `get`/`applyMethod` etc.
- Distant-future direction (context, not in scope to implement): we want
  HandledPromise to eventually be native promises, specified by TC39/262
  and broadly implemented. The current vision for getting there is
  constructing handled promises via `Promise.delegate`.
- Ahead of that specification landing, we could "spackle" the same shape
  today via `Promise[Symbol.for('delegate')]`. Under that spackle, the
  analogous static enliven surface would appear as
  `Promise[Symbol.for('enliven')]`, with `E.enliven` calling through to it.

Deliverable: a single design-doc PR on endo-but-for-bots proposing this
model — the meta-protocol addition, the HandledPromise.enliven/E.enliven
call-through, the sturdyref-as-HandledPromise framing, and the
Promise.delegate / Promise[Symbol.for('delegate')]-spackle relationship to
the distant-future native-promise vision. Explore open questions (revocation,
identity/equality of an enlivened presence, how this composes with existing
sturdyref persistence machinery) but the PR is a proposal, not an
implementation.

gate: go-ahead — do not start until the maintainer promotes this job.
