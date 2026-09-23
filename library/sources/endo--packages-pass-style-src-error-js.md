---
source: packages/pass-style/src/error.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-08
source_authors: [Turadg Aleahmad and prior contributors]
ingested: 2026-05-29
ingested_by: scholar
section_count: 3
status: current
notes: |
  Seventh comment-fragment ingest. The pass-style package's
  error-validation surface — three substantial multi-paragraph
  rationale blocks: (1) the three host configurations (Start
  Compartment / guest-frozen-globalThis / multi-guest-unsafe) plus
  the `makeTypeError` belt-and-suspenders construction via `null.null`
  syntax; (2) the V8 own-stack-accessor as an *undeniable* capability
  channel + the same-realm-getter-equality repair + the
  `PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR` fail-loud +
  forward-compatibility concern over the captureStackTrace proposal;
  (3) the security-vs-diagnostic-preservation tension that drives the
  two-tier passability (isErrorLike + assertError), the four-property
  own-data-property allowlist (`message`, `stack`, `cause`, `errors`),
  the error-constructor registry with AggregateError-non-uniformity
  disclaimer, and the deliberately-accepted passStyleOf side-effect
  scoped to unsafe-hardenTaming.
---

> Abstract: `packages/pass-style/src/error.js` is the pass-style
> package's defense around Error objects. The file's three substantial
> rationale comment blocks make explicit what the package defends
> against, across which host configurations, with what scoped
> deliberate-controlled-risk acceptances. The first block (lines
> 23-65) names three host configurations — Start Compartment, guest
> compartment with frozen globalThis, multi-guest unsafe shared
> compartment — and the belt-and-suspenders construction (`null.null`
> in a `try`/`catch`) that returns a TypeError instance guaranteed to
> be a realm intrinsic by language syntax. The second block (lines
> 77-153) names the V8-specific own-stack-accessor as an *undeniable
> capability channel* — undeniable because freeze does not close it,
> the channel is the getter itself — and constructs the
> same-realm-getter-equality repair that replaces the accessor with a
> data property under `hardenTaming: "unsafe"`. The third block
> (lines 184-362) names the security-vs-diagnostic-preservation
> tension that drives the two-tier passability of malformed errors:
> `isErrorLike` succeeds for malformed errors so marshal can carry
> them as top-level error reports; `assertError` enforces the strict
> four-property allowlist (`message`, `stack`, `cause`, `errors`) with
> recursive-passable-error rules for the cause-and-errors chain.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [pass-style-defense-across-host-configurations](../sections/endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations.md) | hardened-javascript, pass-style, errors, capability-security | current |
| [v8-stack-accessor-undeniable-channel-and-repair](../sections/endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair.md) | hardened-javascript, pass-style, errors, capability-security | current |
| [error-validation-security-vs-diagnostic-tension](../sections/endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension.md) | hardened-javascript, pass-style, errors, capability-security | current |

The file's argument-cluster distribution maps cleanly to three sections. Lines 1-22 are imports and module-prelude (no rationale). Lines 23-77 are the `makeTypeError` rationale + implementation. Lines 77-153 are the `makeRepairError` rationale + construction. Lines 184-362 are `isErrorLike` + `confirmRecursivelyPassableErrorPropertyDesc` + `confirmRecursivelyPassableError` + `ErrorHelper`. Three argument-cluster sections per cohesion-over-density discipline; each section is bounded by a single coherent argument.

## Provenance

- Fetched 2026-05-29 from `endojs/endo@ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2` via the local bare-clone at `worktrees/endojs-endo.git`.
- The commit is the file's last-modifying commit on `origin/master` as of the cycle: Turadg Aleahmad, 2026-04-08. The file is part of the pass-style package's broader refactor toward the `confirm*` / `assert*` / `is*` family.
- Verified file existence and line-count via bare-clone listing (cycle 73 / 74 verify-bare-clone discipline). Verified comment-density by counting `//` and `/*` line patterns — error.js carries 147 comment lines in 362 total (~40% comment density), the highest of the three cycle-86 comments-lane candidates.
