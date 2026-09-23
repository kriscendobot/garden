---
job: f798e9
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-05-22T01:45:37Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 345
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
preconditions: []
refs: []
---

Summary-fix bundle from barrister's panel verdict on PR #345 (mirror of endojs/endo#3032, @endo/cancel cancellation primitive). Six items, all addressable in one fixer dispatch without a panel re-run.

## Items to fix

1. **Add `import harden from '@endo/harden';` to each src file.** Files: `packages/cancel/src/all-map.js`, `packages/cancel/src/any-map.js`, `packages/cancel/src/cancel-kit.js`, `packages/cancel/src/delay-lite.js`, `packages/cancel/src/from-abort.js`, `packages/cancel/src/to-abort.js`. Sibling packages (`packages/bytes/src/*.js`, `packages/promise-kit/src/*.js`) import harden explicitly; the new cancel package relies on the SES global. Per project CLAUDE.md § "harden() is mandatory" + sibling convention. Place the import after the `/// <reference types="ses"/>` directive and before any `@import` line.

2. **Add `// @ts-check` as the first line of each src file** (above the SES reference directive). Same six files as item 1, plus `packages/cancel/src/types.js`. Per project CLAUDE.md § "@ts-check and JSDoc types": "Every `.js` source file must start with `// @ts-check`." Consider adding to top-level shims (`packages/cancel/abort.js`, `all-map.js`, `any-map.js`, `delay.js`, `delay-lite.js`, `from-abort.js`, `to-abort.js`, `index.js`) for consistency.

3. **Add changeset(s) covering this PR.** No `.changeset/*.md` file exists for the diff. Create one (or two) covering:
   - `'@endo/cancel': major` — Initial release. Cancellation tokens with synchronous observation, hierarchical propagation, AbortController interop, and cancellable operators (allMap, anyMap, delay).
   - `'@endo/daemon': patch` and `'@endo/cli': patch` — Internal adoption of @endo/cancel's makeCancelKit, replacing the makePromiseKit-with-sink-rejection pattern. Optional if the project treats internal-only refactors as not warranting an entry; the new-package entry is mandatory.

4. **Replace `assert.error(...)` and bare `Error(...)` with `@endo/errors`'s `makeError(X\`...\`)`.** Specifically:
   - `packages/cancel/src/delay-lite.js:35`: `reject(assert.error('parentCancelled must not fulfill'))` -> `reject(makeError(X\`parentCancelled must not fulfill\`))`.
   - `packages/cancel/src/cancel-kit.js:47`: `Error('Cancelled')` -> `makeError(X\`Cancelled\`)`.
   - `packages/cancel/src/cancel-kit.js:68`: same.
   - `packages/cancel/src/to-abort.js:24`: `Error('Cancelled')` -> `makeError(X\`Cancelled\`)`.
   Add `import { makeError, X } from '@endo/errors';` to each affected file. Per project CLAUDE.md § "Error handling". (If `@endo/errors` is not already a dependency of `@endo/cancel`, add to the package's `dependencies`.)

5. **Widen the wall-clock-floor assertion in the `delay fulfills with undefined after ms` test.** File: `packages/cancel/test/index.test.js:356-364`. The current assertion `t.true(elapsed >= 40, ...)` is too tight for loaded CI runners (especially XS). Either widen to a band like `elapsed >= 30 && elapsed < 5000` with a comment naming the engine-variance margin, or replace the wall-clock floor with a token-passing assertion (the callback into setTimeout resolves a sentinel; the test asserts the sentinel was reached). Per project CLAUDE.md § "Testing with AVA" and engine-realist seat.

6. **Replace `@ts-expect-error` in the `delay treats parentCancelled fulfillment as error` test.** File: `packages/cancel/test/index.test.js:391-400`. Per project CLAUDE.md § "Type-assertion discipline": `@ts-expect-error` is brittle because it flips to an error as soon as the upstream types improve. Replace with a `/** @type {Promise<never>} */` cast at the call site, or a documented helper that produces a typed-as-Cancelled but actually-fulfilling promise.

## Out-of-scope notes

The cli/package.json adds `@endo/bundle-source` as a dependency in the same commit as the makeCancelKit swap; the dep appears unrelated to the cancellation refactor. The fixer may want to verify whether it is actually used (the cli sources may need it for some other reason) and either keep it with a separate commit + commit-message mention, or drop it. Either way, the changeset content should reflect what landed.

After the fixer push, dispatch the **justice** (not the barrister) for the re-run round. The justice's brief inlines this verdict and the fixer's response so the panel reads the delta.
