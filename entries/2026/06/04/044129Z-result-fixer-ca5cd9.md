---
ts: 2026-06-04T04:41:29Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - entries/2026/06/04/043501Z-dispatch-liaison-ca5cd9.md
  - https://github.com/endojs/endo-but-for-bots/pull/418#discussion_r3353485138
  - https://github.com/endojs/endo-but-for-bots/pull/418#discussion_r3353511940
---

# result: fixer ca5cd9 — #418 use @endo/bytes at worker-archive-parsers

Addressed kriskowal's APPROVED-with-follow-up review `4424734833` on PR #418.
Single inline ask at `packages/daemon/src/worker-archive-parsers.js:50`
("Use `@endo/bytes`.").

## Old snippet

```js
const textDecoder = new TextDecoder();
const textEncoder = new TextEncoder();
// ...
    const source = textDecoder.decode(bytes);
    const { code: transformedSource } = await evadeCensor(source, {
      sourceType,
      sourceUrl: moduleLocation,
    });
    const transformedBytes = textEncoder.encode(transformedSource);
```

## New snippet

```js
import { bytesFromText } from '@endo/bytes/from-string.js';
import { bytesToText } from '@endo/bytes/to-string.js';
// ...
    const source = bytesToText(bytes);
    const { code: transformedSource } = await evadeCensor(source, {
      sourceType,
      sourceUrl: moduleLocation,
    });
    const transformedBytes = bytesFromText(transformedSource);
```

The module-level `textDecoder` / `textEncoder` singletons are removed; the
imports replace them. `@endo/bytes` captures the underlying TextEncoder /
TextDecoder once at module load, matching the prior pattern.

## New head

- Branch: `fix/endo-make-node-evasive-runtime`
- New head SHA: `89d502fbd0357a653bd7f59061d42d9df78c149f`
- One commit appended on top of `195cc370a`: `refactor(daemon): use @endo/bytes in worker-archive-parsers`.
- Regular append; no force.

## package.json / tsconfig.composite.json

- **No change.** `@endo/bytes` was already listed as a daemon dependency
  (`packages/daemon/package.json` line 57); `packages/bytes/tsconfig.composite.json`
  was already in the composite references list. Verified by
  `yarn build:types:check` (exit 0, "All composite tsconfig files are up to date.").

## Local gate exit codes

- `yarn workspace @endo/daemon lint`: 0 (390 warnings, 0 errors; all warnings are
  pre-existing repo-wide jsdoc/safe-await nits unrelated to this diff).
- `yarn workspace @endo/daemon lint:types`: 0.
- `yarn ava test/endo.test.js --match "*evades SES censorship*" --timeout=180s`: 0
  (both regression tests pass: TS-JSDoc-import and @endo/errors evasion).
- `yarn prettier --check packages/daemon/src/worker-archive-parsers.js`: 0.
- `yarn build:types:check`: 0.

The wide-repo `pre-push-gates.sh` was not used because its auto-fix stage
(`yarn format` + `yarn lint --fix`) reaches outside the dispatch's
`packages/daemon/` authorization scope. Equivalent gates were run scoped to
the daemon workspace.

## Inline reply

- Reply id: `3353511940` (on parent comment `3353485138`).
- Body cites SHA `89d502fbd`, names the helpers used (`bytesToText` /
  `bytesFromText`), and notes the dep and tsconfig were already present.

## Judgment calls

- **Helper selection.** `@endo/bytes` exposes `bytesFromText` (UTF-8 encode)
  and `bytesToText` (UTF-8 decode) as the direct one-to-one replacements for
  `TextEncoder.encode` / `TextDecoder.decode`. Both come from the per-symbol
  subpath modules per the package's README; that matches kriskowal's prior
  guidance to import qualified names.
- **Removed the singletons rather than wrapping.** Per the `@endo/bytes`
  README "the TextEncoder and TextDecoder instances backing `bytesFromText`
  and `bytesToText` are captured once at module load," the package already
  owns the equivalent singletons, so keeping local `textDecoder` / `textEncoder`
  module-level bindings would duplicate state with no benefit.
- **Wide-repo gate scope.** Running `pre-push-gates.sh` at repo root pulled
  Prettier and eslint auto-fixes into 24 files across packages outside
  `packages/daemon/`, which the dispatch's per-action authorization does not
  cover. Reset the index and working tree to HEAD, re-applied only the scoped
  change, and verified with daemon-scoped gates. The wide-repo prettier /
  eslint drift surfaced is a separate matter; not addressed here.

## Hand-off

Per the dispatch's "After fixer push" note and kriskowal's "pass to the
conductor" directive, the liaison dispatches the conductor next to merge
PR #418.

Self-improvement: nothing this time. The pre-push-gates skill is correctly
shaped for a builder pushing a fresh diff on the gamut; for a fixer touching
one inline ask with a narrow per-action authorization, scoping the format /
lint / typecheck gates to the affected workspace is already the established
pattern, so no skill-level change is warranted.
