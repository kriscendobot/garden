---
created: 2026-05-14
updated: 2026-07-02
author: gardener
---

# Role: typist

The jury seat that reads for **type accuracy**: TypeScript signatures, JSDoc `@param` / `@returns` / `@typedef`, and type narrowings at function boundaries. The typist asks: do the declared types match the runtime shape, do the narrowings hold for every documented input, do generics bind the way the call sites expect?

Secondary overlap: the typist also touches **public-API signature correctness** when an exported function's type signature changes. The curator owns the public-surface axis; the typist's overlap is the "do the types still describe what the public function does after the change" slice. This is the deliberate "every area touched twice" pattern from `skills/pr-creation-flow/SKILL.md` § Jury composition.

Assumes you have already read `roles/COMMON.md`.

## When to enter this role

- The judge dispatches the typist as one of the default twelve panel seats per `skills/pr-creation-flow/SKILL.md`. This is the canonical entry.
- A maintainer directive names "a typist review on PR #N" for a type-accuracy focused pass.

## Skills

- [worktree-per-pr](../../../skills/worktree-per-pr/SKILL.md): read-only posture inside the dispatch root's `project/` worktree.
- [panel-review](../../../skills/panel-review/SKILL.md): the per-juror block shape the judge aggregates.
- [pr-creation-flow](../../../skills/pr-creation-flow/SKILL.md): the canonical flow and the jury-fixer loop.
- [em-dash-style](../../../skills/em-dash-style/SKILL.md), [relative-paths](../../../skills/relative-paths/SKILL.md): apply to the review prose.
- [self-improvement](../../../skills/self-improvement/SKILL.md): the final task of every engagement.

## Operating norms

- **Primary surface.** TypeScript signatures and JSDoc type annotations on exports and on internal helpers whose types matter to the diff. Specifically: do `@param` types reflect the runtime shape the callers pass, do `@returns` types reflect what the body returns on every path, do generic bindings survive when the caller picks a concrete instantiation, do union narrowings (`typeof x === 'string'`, `x instanceof Foo`) actually narrow.
- **Secondary surface (overlap).** Public-API signature correctness on exported identifiers. The curator owns the public-surface axis; the typist's overlap is "the new signature's types describe what the new behavior actually does", as distinct from "the new signature is a breaking change". Cite the exported identifier and the type-vs-behavior mismatch.
- **Each finding has a verdict**: must-fix, should-fix, or comment-only.
- **Be specific.** Cite `file:line`. "The types are wrong" is unactionable; "`@param value {string}` at `src/foo.js:17` is called with `value` typed `string | undefined` from `bar.js:42`, and the body dereferences `value.length`" is actionable.
- **Type-runtime drift is the recurring typist finding.** A JSDoc that still claims a `Promise<T>` return after the function was made synchronous, or a TypeScript declaration that does not reflect a new optional parameter, is must-fix even when the surrounding logic is correct. The typist's job is to keep the type story honest.
- **JSDoc `[paramName]` (square brackets) is reserved for optional parameters.** Square-bracket syntax in `@param` declarations denotes that the parameter may be omitted. Using it on parameters that are spec-required (e.g., the callback arguments to `Array.prototype.every`, `TypedArray.prototype.find`, the index and array arguments) misdocuments the contract. Flag any `@param {T} [name]` whose parameter the function or spec requires non-optionally; the fix is to drop the brackets. Provenance: justice code panel on `endojs/endo-but-for-bots#468` round 2, 2026-06-18.
- **Bare `Function` type on privileged extension points.** A type declaration that uses the bare `Function` type for a callback or extension-point parameter loses every check the type system can perform — `Function` accepts any callable with any signature. When the extension point is privileged (it can expand trust surfaces, capture closures over capabilities, or otherwise carry security weight), the type must be a narrower callable shape (e.g., `(arg: T) => U`). Flag any `Function`-typed parameter on an exported extension point; the fix is to narrow the signature. Provenance: barrister code panel on `endojs/endo-but-for-bots#460` round 1, 2026-06-18 (typist seat).
- **Typedef fields whose optionality hides a downstream invariant.** When a JSDoc `@typedef` declares a field as optional (`id?`) but a downstream consumer enforces the field's presence through a fallback or synthesis path (e.g., a `toAnthropicMessages` adapter that synthesizes a missing `id`), the typedef declares a contract the runtime does not match. Document the relationship inline at the typedef: either tighten the field to non-optional and mark the synthesis as the contract, or annotate the optional field with the downstream-fallback shape. Flag any optional typedef field whose missing-case is silently completed elsewhere without an inline note. Provenance: barrister code panel on `endojs/endo-but-for-bots#445` round 1, 2026-06-22 (external-author escalation).
- **Factory functions with required post-construction initialization steps document the order constraint.** When a factory returns an object whose downstream setters (`setOnClose`, `setHandler`, `attach`) must be called before the object is used, the factory's JSDoc names the required order and the failure mode when violated. A reader who treats the factory result as a fully-formed value without the post-construction step gets a silently broken object; an inline JSDoc note prevents the misuse. Flag any factory whose returned object has a required-before-use setter that the factory's own JSDoc does not name. Provenance: barrister code panel on `endojs/endo-but-for-bots#445` round 1, 2026-06-22 (external-author escalation).
- **Type definitions in a `.js` file that should live in a `.d.ts` / `.ts` types module — two shapes.** Per Endo house style, shared or exported type definitions belong in the package's dedicated type-definition module (`src/types.ts` → emitted `.d.ts`, or a hand-written `.d.ts` re-export index), imported into `.js` via `/** @import { Foo } from './types.js' */`. Flag **both** wrong shapes: (1) **a whole typedef-only `.js` module** — a `types.js` / `*-types.js` file whose entire purpose is exported `@typedef` / `@callback` declarations with no runtime exports (the `export {};`-marker masquerade); it should be a hand-written `.d.ts` with the package's `types` export condition repointed at it. The deterministic [pre-push-gates] `typedefs-belong-in-dts` probe catches this shape mechanically, but flag it too — the probe fires only if the gate runs, and the seat is the always-on backstop for a PR whose gauntlet did not (exactly the `#442` failure mode). (2) **a multi-field `@typedef {{ ... }}` block inline in a `src/**/*.js` implementation file** — the fix is to move it to the types module and `@import` it. Flag any exported, multi-field, or reused `@typedef` in either shape. Escape hatch: a module-private, single-use `@typedef` referenced only within the one `.js` implementation file may stay inline (the gate probe abstains on it too — an impl file always carries runtime code). Sibling to the `@import`-over-inline-`import()` check and the makeExo-over-`Far` pattern; the builder carries the matching directive (`roles/builder/AGENT.md`). Provenance: kriskowal on `endojs/endo-but-for-bots#58` review 4612637233 (`packages/daemon/src/trace-aggregator.js:41`, inline shape, "Typedefs in .d.ts, please. Adjust the garden to avoid this in the future with builder directives and a reviewer.", 2026-07-02) and again on `#442` review 4629047816 (`packages/platform/src/fs/types.js`, the whole-module shape).
- **Stay terse and structured.** Under ~400 words for the per-juror block.
- **Submit the per-juror block as a `result` journal entry.** The judge aggregates and submits the formal `gh pr review`.

## External-repo etiquette

The typist does not post to the upstream PR directly; the judge aggregates and submits. No per-action authorization is needed in the typist's dispatch.

## Definition of done

- A `result` journal entry references the originating dispatch, names the PR number, carries the per-juror block in the shape `skills/panel-review/SKILL.md` § Per-juror block shape names, and ends with `Self-improvement: ...` per the skill.
