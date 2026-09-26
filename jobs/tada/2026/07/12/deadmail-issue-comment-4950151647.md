Done. Report below.

---

**Job:** `deadmail-issue-comment-4950151647` — dead-lettered message whose intended recipient `issue-kriskowal-garden-38` had already completed. Picked up its intent: maintainer `dckc` had left a follow-on comment on kriskowal/garden issue #38 asking to review the darkwow author's newer "defined type systems for every genesis contract, starting with box and purse, the fundamental types" from engineering and formal-verification perspectives.

**What I did:**
- Cloned `PatrickM123/darkwow` at `linear-master` (HEAD `0ac13a3`) and read the box/purse Rust models, the shared capability calculus in `src/sdk/src/capability.rs`, and the backing Lean4 in `proofs/lean/src/DarkFi/Capability/` (Types, Composition, Distinction).
- Reviewed and posted a structured comment back on the issue thread (did **not** close it — the submitter does that): https://github.com/kriskowal/garden/issues/38#issuecomment-4950173364

**Key findings surfaced in the review:**
- The "type system" is really two things: (1) ordinary, useful Rust newtype hygiene with no FV content, and (2) a Lean-backed "capability calculus" that proves only barb *coverage* (⊆), not confinement/least-privilege — and which is **not wired into the contracts** (`wallet_construct` is called only in `#[cfg(test)]`; no `CapabilityExpression` evaluator exists, so descriptors are metadata, not enforcement).
- Concrete engineering gaps: purse's `BalanceParamsV1.token_id` is still raw `pallas::Base` (migration incomplete); box commitments untyped; `requires: Any(vec![])` on PutV1 is an unsatisfiable-vs-vacuous footgun; Rust `Barb`/`Primitive` enums have drifted from the Lean they claim to mirror (13 vs 14 barbs, 10 vs 17 primitives).
- FV concerns: coverage proves authority-from-below (backwards for ocap safety); `purseBalanceType` demands `↓spend` for a read; `capTypesDistinct` fails to distinguish native-transfer from dao-vote; and most importantly `tenderBidType` requires `Barb.prove` that its primitives cannot supply, so `Composition.lean` appears unable to `lake build` — which, if true, means the box/purse proofs in that same file aren't actually checked. Flagged this analytically since no Lean toolchain was available to confirm.

**Follow-ups:** None required of the garden. The actionable next step for the darkwow author (stated in the comment) is to run `lake build` on `proofs/lean/` to settle the `tenderBidType`/`Composition.lean` question. No garden repo (`main2`) changes were needed for this job; scratch checkout cleaned up.
