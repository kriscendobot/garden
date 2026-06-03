---
ts: 2026-06-03T22:01:22Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--bce41e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4616723717
  - https://docs.endojs.org/documents/spackle.html
---

# dispatch: fixer — #417 document ponyfill usage; propose XS/Node parity tests; consider @endo/bytes spackle ramifications

Maintainer directive on #417 issue-comment 2026-06-03T22:00:49Z
(verbatim):

> Please document how one would use these ponyfills such that
> a program will reliably run, whether the shim applies on top
> of a platform with native support for immutable ArrayBuffer
> or without. Please propose tests that verify these patterns
> by sharing a fixture and assertions between code running
> under XS and Node.js. Please also consider ramifications for
> `@endo/bytes` as a potential spackle for typed arrays backed
> by immutable array buffers
> https://docs.endojs.org/documents/spackle.html

#417 is the un-drafted mirror of upstream endo#3164
(erights's `feat(immutable-arraybuffer): freezable virtual
typedarrays`). Head `0bf3dc8e6`, base `master` (`ba26f4cdb`).

## Three concrete asks

### 1. Document ponyfill usage for shim+native parity

The package adds ponyfills (`freezable-typedarray-pony.js`,
`pony-internal.js`) for freezable virtual typedarrays. Document
how to use them such that a program runs reliably:
- When the platform has native immutable-ArrayBuffer support
  (shim is unnecessary).
- When the platform does not (shim applies).

Likely lives in the package's README (`packages/immutable-
arraybuffer/README.md` or equivalent). Read the existing docs
to choose the right place + format.

### 2. Propose XS/Node.js parity tests

Per the recently-landed parity-test pattern (cycle-rename,
cycle-cjs-reexporter, cycle-esm-in-cjs, cycle-rename-unused —
each a SES-side + Node-side test pair sharing a fixture):
propose tests for the freezable-typedarray ponyfills that
follow the same pattern but cross-platform (XS + Node.js).

XS-side: Moddable SDK's XS engine. Node-side: standard ava.
Shared fixture + assertions verifying both produce the same
observable shape.

"Propose" — the dispatch is for a written test proposal in the
PR comments + (optionally) skeleton test files. Full XS test
implementation may be out-of-scope (requires XS toolchain
familiarity).

### 3. `@endo/bytes` spackle ramifications

Reference: https://docs.endojs.org/documents/spackle.html (the
polyfill/ponyfill race pattern). `@endo/bytes` could be a
"spackle" for typed arrays backed by immutable array buffers.

Document the ramifications:
- What changes in `@endo/bytes` would be required?
- Does this require API additions, or can existing exports
  cover the use case?
- Migration path for consumers?

Likely a brief design-note section in the same docs PR.

## Procedure

1. Read the existing package files in
   `packages/immutable-arraybuffer/` to understand current
   docs.
2. Read `https://docs.endojs.org/documents/spackle.html` (or
   the equivalent in `packages/ses/` or wherever it lives) to
   understand the spackle pattern.
3. Read `@endo/bytes` (`packages/bytes/`) to assess shape +
   what additions might be needed.
4. Land the three documentation pieces as a single
   regular-append commit.
5. Push.
6. Reply on the issue-comment thread (via `gh pr comment` or
   inline reply) summarizing what landed.

## Per-action authorizations

- Read all relevant files in `packages/immutable-arraybuffer/`,
  `packages/bytes/`, `packages/ses/`. Authorized.
- Edit/create README + docs in
  `packages/immutable-arraybuffer/`. Authorized.
- Add skeleton parity-test files (with `t.skip` or stub
  bodies) if you choose to land them. Authorized.
- One regular-append commit + push to
  `mirror/3164-freezable-typedarrays`. Authorized.
- Reply comment on #417. Authorized.

## Not authorized

- Modifying upstream endo#3164 (this is a mirror).
- Modifying `@endo/bytes` package source (just document the
  ramifications; the actual additions are a follow-up).
- Implementing the full XS parity tests (requires XS
  toolchain).
- Force-pushing.
- Un-drafting / re-drafting (PR is already un-drafted post-
  gamut).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--bce41e/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--bce41e/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `mirror/3164-freezable-typedarrays`
(head `0bf3dc8e6`).

## Report

A `result` journal entry. Include:

- Files touched (which README/docs).
- Summary of the three pieces of content landed.
- New head SHA.
- Reply comment ID.
- Judgment calls (especially: whether you landed skeleton XS
  test files or kept the test proposal pure-prose).
- @endo/bytes assessment summary (what would change).
