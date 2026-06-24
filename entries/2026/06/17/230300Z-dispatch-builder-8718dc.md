---
ts: 2026-06-17T23:03:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--8718dc
model: sonnet
prs: []
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/449
  - https://github.com/endojs/endo-but-for-bots/pull/449#pullrequestreview-4520208257
  - entries/2026/06/17/225800Z-message-449-approved.md
---

# dispatch: builder — implement freezable TypedArray emulation per #449 design

erights APPROVED PR #449 (the design) at 22:57:35Z and merged at
22:57:50Z (merge commit `90610da88f26de213049e3d5e7753409175aad5a`
on `master-4a04d07`). Review body: "the design looks great!
Please dispatch a builder to implement the design in a new PR."

## State at dispatch time

- **Base**: `master-4a04d07` at `90610da88f26de213049e3d5e7753409175aad5a`.
  Has PR #435 (immutable-ArrayBuffer with `view[i]`/`view.set`
  shadowing semantics) and PR #449 (freezable TypedArray design)
  both merged in.
- **master** is still at `4a04d078b` — pre-#435. Do NOT base on
  master; base on `master-4a04d07`.
- **Design source**: `packages/immutable-arraybuffer/designs/freezable-typedarray.md`
  is the canonical spec at this base. Read it in full.
- **Companion design**: `packages/immutable-arraybuffer/designs/immutable-arraybuffer.md`
  (the #435 design that introduces the amplifier-with-this-fallthrough
  pattern the new design builds on).

## Task

In your `project/` worktree at `90610da88` on a new branch
`feat/freezable-typedarray-emulation` (or similar):

1. Read `garden/roles/builder/AGENT.md`.
2. Read both designs in full:
   - `packages/immutable-arraybuffer/designs/freezable-typedarray.md`
     (the new design — the one this PR implements).
   - `packages/immutable-arraybuffer/designs/immutable-arraybuffer.md`
     (the #435 design for context on the amplifier pattern).
3. Read the current state of these files (pre-implementation):
   - `packages/immutable-arraybuffer/src/lib.js` (the #435
     install loop is here; you extend it).
   - `packages/ses/src/permits.js` (consult per the design's
     *Implementation outline* > *permits.js delta* sub-section).
   - `packages/immutable-arraybuffer/test/*` (current test
     layout).
4. **Implement per the design's *Implementation outline***:
   - Add `freezableTypedArrayLibProperties` install loop that
     installs `virtualTypedArrayBufferGetter` (the
     `%TypedArrayPrototype%.buffer` accessor replacement) and the
     mutator-method throws hooks (`copyWithin`, `fill`, `reverse`,
     `set`, `sort`).
   - The amplifier pattern: same shape as #435's
     `freezableArrayBufferLibProperties`; reuse the
     `WeakMap.prototype.get` + `.apply()` pattern.
   - Discriminate + redirect: if the wrapper has a hidden buffer
     registered in `hiddenBuffers`, redirect to the genuine
     `%TypedArray%` accessor with `this` rewritten to the genuine
     `Uint8Array` constructed from `reverseHiddenBuffers.get(view)`.
   - Update `packages/ses/src/permits.js` only if a gap surfaces
     (the design's expected-no-gap case — `%TypedArrayPrototype%.buffer`
     is already a getter on master; the shim's getter-to-getter
     swap should require no permit change).
5. **Add tests per the design's *Test plan***:
   - Unit tests in `packages/immutable-arraybuffer/test/`:
     - Mutator-throws on frozen wrappers (per-flavor for each of
       the 11 concrete TypedArray constructors).
     - Indexed assignment silently swallowed on frozen wrappers
       (`view[0] = 42; view.at(0)` → still the underlying buffer
       byte 0).
     - `view.buffer` returns an immutable ArrayBuffer (not a
       mutable one).
     - `view.set` on a frozen wrapper throws.
   - Cross-package consumer touchpoints (per the design's
     *Cross-package consumer touchpoints* section) — these are
     the ocapn-codec / pass-style integration tests cited; if
     they live in `@endo/pass-style` or `@endo/bytes`, verify
     the post-shim behavior with a smoke test, OR cite them as
     verified-by-running-the-existing-tests if they already
     cover the relevant predicate.
6. **Run** `corepack yarn workspace @endo/immutable-arraybuffer test`
   (and `@endo/ses` test if you touched permits.js).
7. **Run pre-push-gates** (`garden/skills/pre-push-gates/check.sh`).
8. **Commit per logical unit**:
   - `feat(immutable-arraybuffer): freezable TypedArray emulation per #449 design`
   - `test(immutable-arraybuffer): per-flavor mutator + silent-swallow + buffer-immutability coverage`
   - (only if needed) `chore(ses): extend %TypedArrayPrototype% permits for freezable-typedarray hooks`
9. **Open a new PR** against `master-4a04d07` (frozen base — base
   on the same frozen base #435 + #449 share, NOT on master). PR
   title: `feat(immutable-arraybuffer): freezable TypedArray
   emulation` or similar. PR body: cite the design at
   `packages/immutable-arraybuffer/designs/freezable-typedarray.md`
   and the merged #449 design PR; describe what the shim now
   covers; enumerate test layers.
10. Open as **DRAFT** (per the gamut convention — the
    cleaner/barrister gauntlet runs first).
11. Post a summary comment if needed, at-mentioning erights and
    kriskowal.

## Authorizations

- Create new branch and push.
- Open new PR (DRAFT) against `master-4a04d07`.
- Top-level comment at-mentioning erights / kriskowal.

## Out of scope

- Do NOT touch master directly.
- Do NOT mark the new PR ready (DRAFT only — gamut chain follows).
- Do NOT modify the merged design (it's already in master-4a04d07).
- Do NOT touch #442 or #452 (different PRs).
- The summary-fix commit `e5dc87136` on the now-merged #449
  branch is a separate question — do NOT cherry-pick or include
  it.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` (or 06/18 if
the dispatch spans midnight UTC) naming:

- The new branch name and head SHA.
- The new PR number and URL.
- Per-commit substance.
- Files modified/added.
- Test results (per-suite).
- Pre-push-gates result.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: cleaner` (gamut stage 1).

End your turn with a concise summary back to the orchestrator.
