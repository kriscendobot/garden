---
ts: 2026-06-03T23:21:14Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--ca5ba1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4423421007
---

# dispatch: fixer — #417 reiterate per kriskowal's @endo/bytes-spackle elaboration

Maintainer review `4423421007` (CHANGES_REQUESTED, 2026-06-03T23:20:20Z) body:

> Please reiterate as described. The bytes package becomes
> the spackle front for immutable array buffers, frozen typed
> arrays backed by immutable arraybuffers, and the necessary
> work around for text codecs.
>
> Spackle the typed array constructors and necessary methods.
> Also consider a spackle pattern to ensure the text codecs
> are captured on intrinsics and cannot be overriden by
> compartment global endowment, e.g.,
> `Uint8Array[Symbol.for('toUtf8String')]` and
> `Uint8Array[Symbol.for('toUtf8String')]`.
>
> Simultaneously, forbid direct use of TextEncoder,
> TextDecoder, the typed array constructors, and array buffer
> constructor with eslint-plugin.
>
> Also, ensure that we have parity of behavior for usage of
> the bytes spackle between Node.js and XS with shared
> fixtures and assertions.

## 6 inline comments (full sweep per memory rule)

1. **`README.md:63`** (`3352429174`): create + adopt an eslint
   rule enforcing the spackle import pattern in
   `@endo/eslint-plugin`.

2. **`README.md:91`** (`3352443757`): clarify the spackle
   needed: one TypedArray constructor per realm; portable
   patterns for `instanceof` / construction / usage; idiomatic
   imports; eslint discourages non-portable usage.

3. **`README.md:110`** (`3352454441`): encourage spackle
   usage without forcing the shim. Test all variations (with/
   without lockdown, with/without shim). Use `@endo/bytes`
   as the uniform pattern.

4. **`README.md:111`** (`3352455376`): "Great." (positive
   acknowledgment, no action needed).

5. **`README.md:220`** (`3352461879`): code-suggestion
   replacement for the `bytesToImmutable` description: install
   at `ArrayBuffer.prototype[Symbol.for('sliceBufferToImmutable')]`,
   race first writer, subsequent loads call through.

6. **`README.md:234`** (`3352467194`): symbol must be in SES
   permits; SES with immutable arraybuffers requires the
   shim; without lockdown the shim isn't required.

## Scope: README reiteration (this dispatch); follow-ups flagged

This dispatch updates `packages/immutable-arraybuffer/README.md`
to reflect the elaborated proposal:

- @endo/bytes as the spackle front for: immutable
  ArrayBuffers, frozen TypedArrays backed by them, text-codec
  workarounds.
- Symbol-on-intrinsic pattern: e.g.
  `Uint8Array[Symbol.for('toUtf8String')]`,
  `ArrayBuffer.prototype[Symbol.for('sliceBufferToImmutable')]`.
- One TypedArray constructor per realm + portable
  instanceof/construction/usage patterns.
- ESLint plugin: forbid direct use of TextEncoder,
  TextDecoder, TypedArray constructors, ArrayBuffer
  constructor.
- XS/Node parity tests with shared fixtures + assertions.
- SES permits: symbols must be in permits; lockdown requires
  shim.
- Apply the line-220 code suggestion verbatim.

**Out of scope** (flag as follow-ups in the README + a journal
gardener message):
- Actual `@endo/bytes` source edits (separate dispatch when
  the design lands).
- Actual `@endo/eslint-plugin` rule code (separate dispatch).
- Actual SES permits updates (separate dispatch).
- Actual XS-runner wiring (Moddable SDK toolchain not yet
  available).

## Procedure

1. Apply the line-220 code suggestion verbatim.
2. Update sections around lines 63, 91, 110, 234 per inline
   comments and body directive.
3. Reframe the "Using the Ponyfills" section to lead with the
   spackle pattern as the default; shim as opt-in.
4. Add a "Forbidding direct use via eslint-plugin" section
   listing the forbidden constructors and the rule shape.
5. Expand the @endo/bytes section to describe the spackle
   front explicitly + the symbol-on-intrinsic pattern + the
   SES-permits requirement.
6. One regular-append commit + push to
   `mirror/3164-freezable-typedarrays`.
7. Reply on the review body OR top-level PR comment
   summarizing what landed + the follow-up plan.

## Per-action authorizations

- Read all relevant files (immutable-arraybuffer, bytes, ses,
  eslint-plugin) for context. Authorized.
- Edit `packages/immutable-arraybuffer/README.md`. Authorized.
- One regular-append commit + push to
  `endojs/endo-but-for-bots:mirror/3164-freezable-typedarrays`.
  Authorized.
- Top-level PR comment OR review-thread inline replies.
  Authorized.

## Not authorized

- Editing `packages/bytes/`, `packages/ses/`,
  `packages/eslint-plugin/` source code (follow-up dispatches).
- Modifying upstream endo#3164.
- Force-pushing.
- Un-drafting / re-drafting (already un-drafted).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--ca5ba1/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--ca5ba1/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`
4. Other skills referenced just-in-time.

Project worktree at `project/` on `mirror/3164-freezable-typedarrays`
(head `2071b71e3`).

## Report

A `result` journal entry. Include:

- New head SHA.
- Per-inline-comment status (addressed in README / replied
  inline / deferred to follow-up dispatch).
- Top-level reply OR per-inline reply IDs.
- @endo/bytes assessment in README (what the spackle front
  looks like).
- ESLint rule sketch (what it forbids + how it surfaces).
- Follow-up dispatches flagged for steward.
