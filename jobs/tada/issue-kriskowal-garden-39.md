The review is complete and posted. Final report:

---

**Job: Review "The Zero-Knowledge Authorization Equivalence Theorem" (issue kriskowal/garden#39, from dckc)**

**What I did.** Fetched the issue and the Substack article, cloned `codeberg.org/PatrickM123/darkwow` at the pinned commit `0ac13a390d`, installed Lean 4.12.0 (the repo's pinned toolchain), and actually built/inspected the `proofs/lean` codebase rather than taking the "verified in Lean 4" claim at face value. Ran a literature survey (parallel subagent) to establish prior art, and posted a full peer-review comment to the issue **without closing it** (per `skills/issue-inbox` discipline).

**Key findings (all empirically checked, not asserted):**
- **The published Lean proofs do not compile.** The capability type system is built on Mathlib's `Finset` but declares **no Mathlib dependency** (`Finset` is `unknown identifier` in clean Lean 4.12); `Gadgets.lean` opens with a Rust-style `/*!` comment that Lean can't parse. `lake build` reports "success" while its target globs **0 of 26** proof modules — a false green.
- **The stated theorems are tautologies, not the article's theorem.** `authorizationInversion_TypeLevel` is a definitional record unpack/repack — I reconstructed its exact shape in core Lean and `#print axioms` confirms it **depends on no axioms**. The actual ZK content is deferred to `axiom circuitSoundnessBridge` whose premise `∃ circuit : String, True` is **vacuously true**, so it asserts inhabitation unconditionally.
- **The information-theoretic core is unformalized and mis-stated:** `I_min = log₂|π|` is residual anonymity-set entropy (→0 at a singleton), contradicting the article's own "singleton ⇒ full identity leak."
- **The LTE gate (`0x55`) proof is over ℤ**, assuming `0 ≤ a_offset` and eliding the `𝔽_p` wraparound argument that is the real soundness crux.
- **Novelty: low.** Each claim is decades-old prior art (ocap: Dennis–Van Horn 1966 / Miller 2006 / "Capability Myths Demolished" 2003; GMW NP⊆ZK 1986/91; anonymous credentials: Chaum 1985 / Camenisch–Lysyanskaya 2001 / zk-creds 2023; ABE/predicate encryption 2005–2008; anonymity-set entropy / k-anonymity 2002). The "iff" is essentially a corollary of GMW. Credited the repo's own honest Lean README, which already disclaims the inflated framing.

**What changed.** No garden code touched (review task); worktree clean, nothing to push to main2. One issue comment posted: kriskowal/garden#39 (comment `4950161841`).

**Follow-ups.** None required. The comment includes a constructive "how to make this a real theorem" list; the submitter (dckc) closes the issue when satisfied. If they want the review to also go upstream to `PatrickM123/darkwow`, that would be a separate, authorization-gated action (no upstream interaction was performed).
