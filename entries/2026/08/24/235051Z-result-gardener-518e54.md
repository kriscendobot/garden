---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-24T23:50:52Z
---
---
ts: 2026-08-24T00:00:00Z
kind: result
role: skeptic
repo: endojs/endo-but-for-bots
project: endo
---

Panel seat `skeptic`, design panel, PR #1058 (`designs/hardener-indexed-cardinality.md`), diff base `origin/llm`, head `7176be8d86`.

### skeptic (adversarial premise attack)

**Verdict:** request-changes

**Findings:**

- *Alternatives Considered* asserts the demoted cardinality-equality variant is "behaviorally equivalent ... but strictly heavier", and the whole round-2 restructure rests on that premise. It is unproven and the two forms diverge **fail-open**. The last-key test trusts two engine behaviors — `[[OwnPropertyKeys]]` ordering (10.4.5.7) and `[[DefineOwnProperty]]` rejecting every out-of-range canonical numeric index (10.4.5.3) — while `keys.length === length` trusts neither: a spuriously-admitted key inflates the count and selects the slow path. `harden` is a confinement primitive, and this very file already carries a fail-safe against **GraalJS** non-conformance (`packages/harden/make-hardener.js:296-298`) which the design cites approvingly — yet its new mechanism newly trusts engine ordering with no fail-safe. Either scope the equivalence claim to strictly-conformant engines and say why that is acceptable here, or keep the last-key test *and* corroborate with the count. [rule: skills/regression-evidence/SKILL.md § Equivalence claims need a backing test]

- The *Correctness Argument* escalates `isCanonicalIntegerIndexString` from deciding *downgrade or not* to deciding *traverse or not*, without the lemma that escalation needs. It proves accessors cannot sit at an index, but never proves that every key the helper accepts on a genuine view is a valid in-range index and therefore holds a primitive. The helper is looser than the spec's *integer index* (no ≤2^53−1 bound, no in-bounds check): `isCanonicalIntegerIndexString('1e+21')` is `true`. It is unreachable only because `[[DefineOwnProperty]]` rejects it — verified on V8: `Object.defineProperty(new Uint8Array(3), '1e+21', {value:{}})` throws `Invalid typed array index`. That rejection is now load-bearing for confinement and belongs in the proof, not left implicit. [proposed-rule: when a design promotes an existing predicate to gate a security invariant it did not previously gate, the correctness argument must prove the predicate exactly characterizes the safe set, not merely reuse it.]

- The test catalog is collectively **vacuous with respect to the optimization**: every listed case is behavior-preservation, all of which an implementation that never takes the fast path passes. The doc claims "no test is flaky or vacuous"; that claim holds per-case and fails in aggregate. Add at least one assertion that observes the fast path *engaged*. [rule: skills/regression-evidence/SKILL.md]

- Catalog gaps, all at the boundary the fast path decides: (a) a canonical-index-*shaped* non-index key — verified that V8 accepts `ta['1e21'] = {}`, sorts it last, and the helper returns `false`, so today's traversal hardens the value; nothing pins that; (b) a growable-`SharedArrayBuffer` length-tracking view — verified `preventExtensions` succeeds and a later `grow()` exposes fresh **writable** indices, i.e. the exact behavior the out-of-scope note describes, unpinned by any test even though the Alternatives section's concurrency argument turns on SAB; (c) `harden` idempotency on a fast-pathed view. [rule: skills/adversarial-tests/SKILL.md § Boundary]

**Notes (out of scope but worth flagging):**

- The rationale for returning a boolean rather than the key list — that handing keys back would "reintroduc[e] exactly the GraalJS skew" — is inapt: `baseFreezeAndTraverse` already calls `getOwnPropertyDescriptors(obj)` unconditionally (`packages/harden/make-hardener.js:385`, `packages/ses/src/make-hardener.js:193`). The caller-side skew exists today; the boolean does not prevent it. The conclusion still stands on simplicity grounds; the stated reason does not. [proposed-rule: a rationale that cites a defensive precedent must confirm the precedent is not already violated at the call site it protects.]

- Evidence discipline is **satisfied** on the benchmark: the 15 ms / 3.5 ms figures are explicitly labelled preliminary, single-harness, and not reproduced, with replacement required in the implementation PR. Nit: the derived bound is 15/3.5 ≈ 4.3, stated as "about 4.4x". [rule: roles/jurors/skeptic/AGENT.md § Verified-claim evidence discipline]

- *Open questions* defers the mechanism choice to the maintainer while the correctness argument, implementation plan, and test catalog are written for one form only; a "use the prompted form" answer invalidates all three sections, not just the mechanism paragraph. Worth stating that cost in the question itself. [proposed-rule: an open question that would invalidate other sections of the design should name which sections it would invalidate.]

Verified against the worktree sources (`packages/harden/make-hardener.js`, `packages/ses/src/make-hardener.js`) and by direct engine probes on Node/V8; not verified on XS, SpiderMonkey, JavaScriptCore, or GraalJS, which is precisely the gap the first finding names.

Self-improvement: the design panel's seats have no standing rule for the case where a design *demotes* a safer alternative on simplicity grounds — the cite-or-propose discipline pushed me to `skills/regression-evidence/SKILL.md` § Equivalence claims, which fits but is a code-side rule. A short `[proposed-rule]` in `roles/jurors/skeptic/AGENT.md` — "when a design ranks two mechanisms as equivalent, walk the divergence under non-conformance and name which one fails open" — would make this attack routine rather than improvised.
