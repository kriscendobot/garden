---
kind: result
role: liaison
dispatch-root: dispatches/liaison--4a7901
cycle: 338
lane: chat
host: endolin
date: 2026-06-15
refs:
  - 2026/06/15/153040Z-result-liaison-0bb7a5.md
---

# Result — liaison cycle 338: @endo/harden/make-hardener.js (chat-lane; canonical harden implementation; three-phase traversal with commit-after-all-frozen; NINE citation-arc closures including 251-cycle arc back to cycle 87)

Cycle 338 ingest: **@endo/harden/make-hardener.js** (471 lines). Chat-lane after cycle 337's designs-lane @endo/harden README — **same-package adjacent forward pair**. **Twenty-ninth consecutive non-garden source after the pivot** (cycles 310-338). **§twenty-nine-cycles-with-named-pivot-domain-stay**. **§fourteen-named-packages-in-the-pivot-cluster** continues (harden's source after its README).

## §the-named-streak-resumes-with-ninth-instance

Cycle 337 → 338 is **same-package** (harden README → harden source), so it's the **ninth INSTANCE** of the one-cycle README↔source pattern. Streak count is **1** because cycle 336 → 337 was cross-package (broke the streak). **§the-named-streak-resumes-with-ninth-instance** — first-explicit-observation. Pattern application count: 9. Current streak: 1.

## Single most structurally interesting move

**§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — the `harden(root)` function has three separable phases:

```js
enqueue(root);    // Phase 1: walk reachable graph; add unfrozen objects to toFreeze Set
dequeue();        // Phase 2: freeze each enqueued value (may throw on proxy traps)
commit();         // Phase 3: mark each frozen value as hardened (pure WeakSet adds; cannot throw)
```

The **COMMIT phase comes AFTER all freezes complete**. If traversal fails mid-flight, partially-frozen objects are NOT marked as hardened. Harden can be re-attempted because frozen objects are idempotent under freeze.

**§the-named-mark-hardened-only-after-all-frozen-discipline** — first-explicit-observation. **§the-named-transactional-harden-discipline** (all-or-nothing). **§four-shapes-of-atomic-transition-discipline** (152 single-record + 322 state-seal + 336 assign-then-freeze + 338 three-phase-over-graph) — first-explicit-observation as a tier-3 meta-pattern.

Tier-3 framing: when an operation needs to be atomic over a graph, split it into walk + act + record phases where the third phase is pure book-keeping that cannot fail.

## Closes nine citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 337 (harden README) | 1 cycle | Adjacent forward pair; same-package README→source |
| **Cycle 87 (pass-style error.js V8 stack accessor)** | **251 cycles** | §V8-error-own-stack-accessor-repair sibling; **second-longest pivot arc** |
| Cycle 152 (memo-race.js comment-fragment) | 186 cycles | §canonical-Endo-idiom-named-function-via-object-destructure sibling |
| Cycle 142 (passStyle-helpers.js isPrimitive) | 196 cycles | §triple-duplication-with-named-layering-constraint |
| Cycle 175 (make-selector.js sibling) | 163 cycles | Sibling file in same package |
| Cycle 211 (@endo/common harden in dependency-ceiling) | 127 cycles | Documentation-side closure |
| Cycle 156 (finalize.js named-warning) | 182 cycles | §three-shapes-of-hazard-acknowledgment |
| Cycle 322 (exo-makers complementary-lens) | 16 cycles | Cross-package canonical-idiom |
| Cycle 336 (memo-race.js complementary-lens) | 2 cycles | isPrimitive observation extended from TWO to THREE packages |

**§nine-citation-arc-closures-in-cycle-338**. **§sixty-two-citation-arc-closures-in-pivot-now** (56 + 6 net new). The cycle 87 arc at **251 cycles** is the **second-longest pivot arc** (current record: 261 cycles from cycle 69 → 330).

## Other key first-explicit-observations (forty-plus)

### Multi-generation attribution chain

**§the-named-multi-generation-derivation-chain-named-in-the-header** — lines 1-21 NAME four-stage attribution: Google Caja 2011 (startSES.js + repairES5.js) → TC39 proposal-frozen-realms (deep-freeze.js) → SES (src/bundle/deepFreeze.js) → @endo/harden (make-hardener.js). **§the-named-four-stage-attribution-chain**. **§the-named-attribution-as-historical-record**. **§two-shapes-of-attribution-discipline** (336 verbatim-preserved-dedication + 338 multi-generation-chain).

### FERAL_ prefix naming convention

**§the-named-FERAL-prefix-naming-convention** — FERAL_ERROR + FERAL_STACK_GETTER + FERAL_STACK_SETTER mark values with excess authority that must be carefully hidden from client code. **§the-named-FERAL-binding-with-four-part-justification** — comments name safe-use + unsafe-exposure + platform + capability.

### V8 stack-accessor repair with named error code

**§the-named-V8-error-own-stack-accessor-repair** — 70-line platform-specific repair. **§the-named-platform-specific-repair-with-named-error-code** (`SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR.md`). **§the-named-error-code-as-stable-URL-anchor**. **§three-shapes-of-stable-pointer-discipline** (326 deprecation-pointer + 336 issue-link + 338 error-code-Markdown). **§three-cycles-with-named-V8-stack-accessor-discipline** (87 + 336 + 338).

### Platform detection at factory time

**§the-named-platform-detection-at-factory-time-not-per-call** — `freezeAndTraverse` is defined as ONE OF TWO closures at factory time based on `FERAL_STACK_GETTER === undefined`. No per-call branch on platforms without the V8 bug. **§the-named-platform-conditional-fast-path-vs-slow-path**. **§three-cycles-with-named-pay-only-when-necessary-discipline** (332 + 334 + 338).

### Acknowledged and bounded hazard

**§the-named-acknowledged-and-bounded-hazard** — comment names hazard AND bounded reason for accepting it AND @ts-expect-error suppression AND PR discussion link. **§the-named-four-part-hazard-acknowledgment**. **§three-shapes-of-hazard-acknowledgment** (156 named-warning + 322 repeated-warning + 338 four-part-acknowledgment).

### Triple-package duplication

**§the-named-triple-duplication-with-named-layering-constraint** — TODO names THREE packages: @endo/harden + @endo/pass-style + ses. Cycle 336 named TWO-package duplication of isPrimitive; cycle 338 reveals THREE-package duplication. **§four-cycles-with-named-isPrimitive-duplication-observation** (142 + 336 + 338 + implicit ses).

### Substrate-of-substrates

**§the-named-substrate-of-substrates-zero-endo-imports** — the file depends on NO other @endo package. **§the-named-zero-endo-imports-as-substrate-marker**. **§the-named-dependency-import-count-tracks-package-tier** — more @endo imports = higher in stack; zero = at the bottom.

### Bug-workaround discipline

**§the-named-Safari-bug-workaround-with-named-tracking-URL** (webkit.org/show_bug.cgi?id=222538 + SES_DEFINE_PROPERTY_FAILED_SILENTLY Markdown URL). **§the-named-forward-vs-backward-pointer-discipline** — deprecation forward; bug-workaround backward. **§the-named-Please-report-language** + **§the-named-error-message-as-bug-report-request**.

### Link-rot acknowledgment with archive URL

**§the-named-link-rot-acknowledgment-with-archive-URL** — the README cites both the canonical wiki URL (now dead) AND the web.archive.org fallback URL. **§the-named-fallback-URL-when-canonical-dies**.

### Named lint rule with canonical exception

**§the-named-named-lint-rule-with-canonical-exception** — `@endo/no-polymorphic-call` eslint rule + disable-comment as discipline-marker for the canonical uncurryThis idiom.

### TC39 spec citation

**§the-named-freezeTypedArray-with-tc39-spec-citation** — tc39.es URL as rationale. **§the-named-tc39-spec-citation-as-rationale**. **§the-named-conceptual-analogy-to-justify-exception** — TypedArray data *"analogous to the data of a hardened Map or Set"*.

### Bulk destructure of globalThis

**§the-named-bulk-destructure-of-globalThis** — ten intrinsics at module load. **§five-cycles-with-named-pre-lockdown-intrinsic-capture** (314 + 318 + 332 + 334 + 338). **§the-named-bulk-destructure-tracks-file-scope**.

### Canonical Endo idiom

**§the-named-canonical-Endo-idiom-named-function-via-object-destructure** — `const { harden } = { harden(root) { ... } }`; same idiom as cycle 152/336 memo-race.js. **§three-cycles-with-named-named-function-via-object-destructure** (152 + 336 + 338) — **confirmed canonical Endo idiom**.

## Multi-cycle patterns extended

- §twenty-nine-cycles-with-named-pivot-domain-stay (310-338)
- §fourteen-named-packages-in-the-pivot-cluster (harden's source after its README)
- §sixty-two-citation-arc-closures-in-pivot-now (56 + 6 net new)
- §three-cycles-with-named-V8-stack-accessor-discipline (87 + 336 + 338)
- §three-cycles-with-named-named-function-via-object-destructure (152 + 336 + 338)
- §three-cycles-with-named-pay-only-when-necessary-discipline (332 + 334 + 338)
- §three-shapes-of-hazard-acknowledgment (156 + 322 + 338)
- §three-shapes-of-stable-pointer-discipline (326 + 336 + 338)
- §four-shapes-of-atomic-transition-discipline (152 + 322 + 336 + 338)
- §five-cycles-with-named-pre-lockdown-intrinsic-capture (314 + 318 + 332 + 334 + 338)
- §four-cycles-with-named-isPrimitive-duplication-observation (142 + 336 + 338 + implicit ses)
- §the-named-streak-resumes-with-ninth-instance

## Tier-3 meta-patterns

- **§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — atomic transaction over a graph
- **§the-named-transactional-harden-discipline** — all-or-nothing; mark hardened only after all frozen
- **§four-shapes-of-atomic-transition-discipline** — single-record (152) + state-seal (322) + assign-then-freeze (336) + three-phase-over-graph (338)
- **§the-named-multi-generation-derivation-chain-named-in-the-header** — name each generation with clickable URL
- **§two-shapes-of-attribution-discipline** — verbatim-dedication (336) + multi-generation-chain (338)
- **§the-named-FERAL-prefix-naming-convention** — marker for values with excess authority
- **§the-named-error-code-as-stable-URL-anchor** — SES_ codes as stable grep-able identifiers
- **§three-shapes-of-stable-pointer-discipline** — deprecation-pointer + issue-link + error-code-Markdown
- **§the-named-platform-detection-at-factory-time-not-per-call** — bake choice into closure
- **§the-named-acknowledged-and-bounded-hazard** — hazard + bounded reason for accepting
- **§three-cycles-with-named-pay-only-when-necessary-discipline**
- **§the-named-forward-vs-backward-pointer-discipline** — deprecation forward; bug-workaround backward
- **§the-named-link-rot-acknowledgment-with-archive-URL** — archive URL as fallback for dead canonical
- **§the-named-named-lint-rule-with-canonical-exception** — rule + disable-comment as discipline-marker
- **§the-named-tc39-spec-citation-as-rationale** — spec URL as justification
- **§the-named-conceptual-analogy-to-justify-exception** — analogous-to-X structure
- **§the-named-dependency-import-count-tracks-package-tier** — zero @endo imports = substrate
- **§the-named-named-option-vs-positional-arg-discipline** — booleans as named options
- **§the-named-canonical-Endo-idiom-named-function-via-object-destructure** — three-cycle confirmed

## Synthesis-target

Slot machine library **§`@game/harden/make-hardener.js`** — canonical harden implementation:

1. **Three-phase traversal with commit-after-all-frozen** — enqueue + dequeue + commit; partial-credit-prohibited
2. **Multi-generation derivation chain in the header** — name each generation with clickable URL
3. **FERAL_-prefix naming convention** — marker for values with excess authority
4. **Platform-specific repair with named error code** — bug + repair + stable URL anchor
5. **Platform detection at factory time, not per-call**
6. **Acknowledged and bounded hazard** — four-part justification
7. **Honest TODO with named layering-constraint**
8. **Bulk destructure of globalThis** at module load
9. **Safari/V8/GraalJS bug-workaround pattern** with tracking URL
10. **Error message as bug-report request**
11. **Link-rot acknowledgment with archive URL**
12. **Named lint rule with canonical exception**
13. **Shim explicitly names spec divergence**
14. **TC39 spec citation as rationale**
15. **Conceptual analogy to justify exception**
16. **Substrate-of-substrates with zero @endo imports**
17. **traversePrototypes as named option**
18. **Canonical Endo idiom: named-function-via-object-destructure**

## Library state after cycle 338

- §library-reaches-850-sections from 383 source documents (new section + new source page)
- §one-hundred-and-seventy-first consecutive designs-chat alternation
- §twenty-nine-cycles-with-named-pivot-domain-stay
- §fourteen-named-packages-in-the-pivot-cluster (harden's source after its README; thirteenth source page in the pivot)
- §sixty-two-citation-arc-closures-in-pivot-now (56 + 6 net new)
- §three-cycles-with-named-V8-stack-accessor-discipline (87 + 336 + 338)
- §three-cycles-with-named-named-function-via-object-destructure as canonical Endo idiom
- §four-shapes-of-atomic-transition-discipline established as tier-3 meta-pattern
- §the-named-three-phase-traversal-with-named-commit-after-all-frozen established as tier-3 meta-pattern
- §the-named-FERAL-prefix-naming-convention established as tier-3 meta-pattern
- §the-named-platform-detection-at-factory-time-not-per-call established as tier-3 meta-pattern
- §the-named-substrate-of-substrates-zero-endo-imports established as tier-3 meta-pattern
- §the-named-streak-resumes-with-ninth-instance (cycle 337 → 338 same-package; streak count is 1)

## Next cycle pacing

Cycle 339 is **designs-lane** next. Candidate moves:

- **@endo/harden/index.js + noop.js + hardened.js + is-noop.js** — the small entry-point files (17 + 20 + 18 + 22 lines = 77 lines total); would close the harden package source-cluster
- **@endo/harden/make-selector.js** — 69-line sibling; cycle 175 ingested as comment-fragment; would be sixth complementary-lens re-ingest
- **@endo/init source or README** — would introduce a fifteenth package; cycle 183 already ingested as comment-fragment
- **@endo/errors source or README** — would introduce a fifteenth package; cited from many cycles for q/Fail/X

The designs-lane preference suggests a README. Picks: @endo/init/README or @endo/errors/README (fifteenth package addition) or harden package entry-point cluster (deeper coverage of the same package).

@endo/errors README would be most productive — cycles 87 + 102 + 134 + 138 + 211 + 322 + 332 reference `q`, `Fail`, `X` from @endo/errors. Introducing the README would close MANY arcs at once (similar shape to cycle 337's substrate-package-introduction-closes-many-arcs discipline). Tracking for future work; picking freely.
