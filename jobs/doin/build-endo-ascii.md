---
role: builder
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-06T14:41:04Z cleared=none -->

---
tier: minion
dispatch: automatic
---
# Build: carve out `@endo/ascii` — XS-safe 7-bit-asserted ASCII text→bytes encoder

**Repo:** `kriscendobot/endo-but-for-bots` fork of `endojs/endo-but-for-bots`.
New package `packages/ascii` (`@endo/ascii`), on a PR based on the integration
line PR #836 lands on (its base was `llm-bfc91f5`; use the post-merge tip so
`@endo/sha256` is present).

**Gated on PR [#836](https://github.com/endojs/endo-but-for-bots/pull/836)
(`@endo/sha256`) landing.** This job is parked `blocked_on` #836; the unblock
watcher promotes it to `todo/` when #836 merges or closes. **The builder MUST
first confirm #836 was merged, not merely closed** — if it was closed unmerged,
do NOT build; report that the gating context is gone and stop.

## Why this exists

Maintainer directive (kriskowal, review comment on #836,
<https://github.com/endojs/endo-but-for-bots/pull/836#discussion_r3678781337>):

> Post a follow-up job to carve out `@endo/ascii`, which should be like this
> but also assert that each byte is in the admitted 7-bit range, to be
> unblocked when this lands.

"Like this" is the one-line helper in `packages/sha256/test/_xs.js` (added by
#836), which encodes ASCII text to bytes without `TextEncoder` (XS hosts lack
it):

```js
const ascii = text => Uint8Array.from(text, ch => ch.charCodeAt(0));
```

An earlier review pass on #836 (tada
`endojs-endo-but-for-bots-pr836-review-3e0d6210`) was asked to "use
`@endo/ascii`", found the package did not exist (not in the monorepo, not on
npm), and escalated to the maintainer. The comment above is the maintainer's
answer: build it as a follow-up package, blocked on #836.

## What to build

1. `packages/ascii` exporting the encoder (name per repo convention, e.g.
   `encodeAscii`; the sha256 test calls it `ascii`): takes a string, returns a
   `Uint8Array` of its code units, and **asserts every code unit is in the
   admitted 7-bit range 0x00–0x7F**, hard-failing (the repo's assert idiom —
   cf. `packages/sha256/src/assert.js` from #836: plain TypeError/RangeError +
   `harden`) on any code unit ≥ 0x80. Pure JavaScript — no `TextEncoder`, no
   `node:` imports, no host globals — so it imports and runs under XS (`xst`)
   exactly like the helper it replaces.
2. Package shape mirrors `@endo/hex` (`packages/hex`) and #836's
   `@endo/sha256`: package.json (name, exports, files, scripts), LICENSE,
   README.md, SECURITY.md, the tsconfig trio, ava tests (including non-ASCII
   rejection cases), and a changeset.
3. Switch `packages/sha256/test/_xs.js` over to `@endo/ascii`: drop the local
   helper, add the dependency, and keep the XS bundling path
   (`packages/sha256/scripts/generate-test-xs.js`) working — the package must
   resolve under `@endo/compartment-mapper` bundling the same way `@endo/hex`
   does. Grep the repo for other copies of the `charCodeAt(0)` text→bytes
   helper and switch any in scope; list the rest in the tada report.
4. Keep the package dependency-light (XS-floor utility other packages will
   entrain).

## Norms

- Verify locally before handoff ([local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md)): package ava tests,
  eslint, tsc, plus the `@endo/sha256` suite (its XS spot check consumes the
  new package; run `yarn test:xs` where the host supports it, else note CI as
  the arbiter in the tada report).
- Changeset per [changeset-discipline](../../skills/changeset-discipline/SKILL.md);
  `yarn.lock` in a separate commit if touched
  ([yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md)).
- Scope is the maintainer-specced carve-out: the 7-bit-asserted encoder and
  what the package shape requires. Do NOT speculatively add decode/Unicode
  APIs — if a decode side seems warranted, note it as a follow-up in the tada
  report instead.

## Skills

- [local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [changeset-discipline](../../skills/changeset-discipline/SKILL.md),
  [yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

`@endo/ascii` exists with the 7-bit-asserted encoder, `packages/sha256`'s XS
spot check consumes it (local helper gone), everything is locally verified, and
the PR is ready for the gauntlet.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T14:41:09Z
