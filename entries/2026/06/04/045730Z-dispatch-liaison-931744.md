---
ts: 2026-06-04T04:57:30Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--931744
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4424846301
---

# dispatch: fixer — #417 second-round revise per kriskowal review 4424846301 (4 asks, scope-trimming)

Maintainer review `4424846301` (CHANGES_REQUESTED,
2026-06-04T04:56:45Z, body-only) with 4 inline asks. The
maintainer is iteratively trimming the spackle scope.

Pre-dispatch sweep: 4 inline comments tied to this review;
no other unaddressed standing asks on #417.

## 4 inline asks

### 1. `permits.js:1460` (`3353552129`) — delete symbol forms

> We are pretty confident that the standard will arrive at
> the names. We do not need to use a symbol for these. We can
> use the string names above. These can simply be deleted.

→ The symbol-form permits at this section should be deleted.
Plain string names (above this section) suffice.

Identify which symbol entries this targets (`fromImmutable`,
`toImmutable`, similar) and remove them, since the standard
names will suffice.

### 2. `permits.js:1434` (`3353558500`) — drop concatImmutables spackle

> Also, we presumably do not need shared state for the pure
> JavaScript stop-gap for `concatImmutables` and so don't need
> to install a spackle function on the intrinsic. Correct me
> if I'm wrong. There's no proposed standard behavior and no
> downside to using a pure JavaScript implementation.

→ Remove the `concatImmutables` spackle install entirely.
Keep a pure JS implementation in `@endo/bytes` as the
canonical form. No intrinsic install, no permit needed.

### 3. `permits.js:1281` (`3353571575`) — question text-codec permits

> Do we need these or can we tolerate eval twins of
> `bytesToText` or `bytesFromText`? I suspect we just need to
> avoid using global `TextEncoder` and `TextDecoder` with
> pseudo typed arrays backed by emulated immutable array
> buffers, using the `@endo/bytes` functions instead since
> they will compensate. We just need `@endo/bytes` to be able
> to sense the need to provide special treatment for the
> emulated...

→ Reconsider: do we need spackle/permits for text codecs at
all? If `@endo/bytes`' `bytesToText` and `bytesFromText` can
sense pseudo-typed-arrays and compensate, no intrinsic
install needed. Drop the `toText`/`fromText`/`toStrictText`
spackle install + permits.

The maintainer says "correct me if I'm wrong" — the fixer
should evaluate the tradeoff and make the call. If
`@endo/bytes` can compensate without spackle, drop it. If
spackle IS needed (e.g., for capture-at-load against
compartment endowment override), keep with explanation.

### 4. `permits.js:389` (`3353576502`) — freezable TypedArray + brand-check

> This I assume is unavoidable because we only want one such
> constructor per realm. Do we also need a spackle method for
> brand-checking array buffer or emulated immutable array
> buffer?

→ The freezable TypedArray constructor spackle stays
(unavoidable, one constructor per realm).

The question: do we also need a brand-checking spackle for
distinguishing immutable from emulated-immutable
ArrayBuffer? This may be a NEW addition (e.g.,
`Symbol.for('isImmutableArrayBuffer')`).

If brand-checking is needed for portability, add it. If the
existing `instanceof ArrayBuffer` works fine (because
emulated immutable AB is still an instanceof AB), no new
spackle needed.

Use judgment.

## Procedure

1. Read current state in `permits.js`, `bytes/src/`, and
   the spackle install modules.
2. For #1: delete the symbol-form permits identified.
3. For #2: remove concatImmutables spackle; keep pure JS in
   `@endo/bytes`.
4. For #3: evaluate, then either drop the text-codec
   spackle/permits OR keep with explanation.
5. For #4: evaluate, then either add brand-check spackle OR
   confirm not needed.
6. Update `install-*.js` modules + tests + README/DESIGN.md
   accordingly.
7. Run gates: lint, lint:types, ava, prettier.
8. Commit (multiple commits OK for review-friendly
   granularity).
9. Push.
10. Inline replies + top-level summary.

## Per-action authorizations

- Read + edit `packages/ses/permits.js`, `packages/bytes/`,
  `packages/immutable-arraybuffer/`, `packages/eslint-plugin/`
  (if rule allow-list needs updating for removed installs).
  Authorized.
- Multiple regular-append commits + push to
  `mirror/3164-freezable-typedarrays`. Authorized.
- Inline-thread replies + top-level summary. Authorized.

## Not authorized

- Modifying upstream.
- Force-pushing.
- Un-drafting / re-drafting.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--931744/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--931744/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`

Project worktree at `project/` on
`mirror/3164-freezable-typedarrays` (head `b6fdeff8d`).

## Report

A `result` journal entry. Include:

- Per-ask status (applied / deferred-with-explanation /
  not-needed).
- Per-package change summary.
- New head SHA + commits.
- Gate exit codes.
- Reply IDs.
- Judgment calls (especially #3 and #4 where the maintainer
  asked "correct me if I'm wrong").
