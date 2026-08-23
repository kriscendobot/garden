---
kind: result
role: warden
host: endolin-garden2-5bcdff64
at: 2026-08-23T10:42:41Z
---
Panel seat `warden` on `endojs/endo-but-for-bots` PR #796 (`feat/hashline-core`,
head `3380bebd0a`, base `origin/llm`). Surface: SES / hardened-JS boundary,
harden discipline, unguarded globals, prototype pollution.

### warden

**Verdict:** request-changes

**Findings:**

- `packages/daemon/src/hashline.js:651` — `errorMessage` reads `error.message`
  **twice**: once in the type guard, once in the `return`. A caught value with a
  varying `message` accessor passes the guard and returns a non-string, which
  `failureResult` embeds as `failure.message` (typed `string`) in the hardened
  `EditResult` that crosses the daemon-to-agent boundary; `harden` then freezes
  the attacker's object into that result. This is exactly the escape the
  function's own docstring (lines 638-648) says it closes, and the module states
  the single-read discipline three times for other untrusted reads
  (lines 262-265, 303-305, 397-399). Verified by executing the module under
  `@endo/init/debug.js`: a `Proxy` over `ops` throwing
  `{ __proto__: Error.prototype }` with an alternating `message` getter yields
  `typeof failure.message === 'object'` and `Object.isFrozen(...) === true`. Fix
  is one line: bind `const { message } = error;` before the guard and return the
  bound local. **must-fix**
  [rule: packages/daemon/src/hashline.js § "Read each untrusted property exactly once"]

- `packages/crc32/package.json:39` — `"test": "ava"`. The package's entire
  safety claim is intrinsic capture plus `harden`, yet no test ever locks down
  (no `@endo/init`, no `require` in the ava config, `"test:xs": "exit 0"`). So
  `harden(crc32)` under test is `@endo/harden`'s standalone fallback — which by
  its own comment "preserves the mutability of the realm" and does not traverse
  prototypes — and `test/crc32.test.js:191`'s `t.true(Object.isFrozen(crc32))`
  never exercises HardenedJS `harden` or the tamed intrinsics the brand reads.
  `@endo/zip`, the sibling this code was extracted from and its first consumer,
  runs `yarn run -T ses-ava`, whose `prepare-endo.js` imports
  `@endo/init/debug.js`. Match it. **should-fix**
  [proposed-rule: a package whose safety claim rests on `harden` or on captured intrinsics must run its own tests under lockdown, as `@endo/zip` does]

- `packages/crc32/src/crc32.js:225` — `const at = emulated.at;` is an unguarded
  property read on the same untrusted object whose `.length` read 70 lines
  earlier (148-155) is deliberately wrapped in `try`/`catch` to convert a
  hostile getter's throw into a structured `TypeError`. A proxy with a throwing
  `get` trap on `at` propagates a raw attacker-chosen value (possibly a
  non-`Error`) out of `crc32`. Same wrapper, same message shape.
  **comment-only**
  [rule: packages/crc32/src/crc32.js:148-155 — the `.length` guard sets the contract for untrusted reads]

**Notes (out of scope but worth flagging):**

- `packages/daemon/src/hashline.js:117` exports `EMPTY_FILE_SHA256` with no
  `harden(EMPTY_FILE_SHA256)`, which AGENTS.md states absolutely. `npx eslint`
  on the file passes and hardening a primitive is a no-op, so this is
  consistency only. [rule: AGENTS.md § `harden()` is mandatory]
- Clean on the rest of the warden surface, checked and confirmed: no
  `globalThis` write, no prototype mutation, no `__proto__`/`setPrototypeOf`,
  no `eval`/`new Function` anywhere in the diff; every export hardened at
  definition; `splitLines`, `validateEditPatch`, `parseHashlineText` and
  `applyEditPatch` all return hardened results; `actions` and
  `relocationReport` are sorted *before* hardening (hardening first would
  throw); anchor lines are gated by `anchorMatches` before any span loop, so an
  unbounded `anchor.line` cannot drive the splice; and the crc32 README carries
  the "not a cryptographic hash" caveat.

Self-improvement: the two real findings both came from the same move — taking a
module's *own* stated invariant as the rule and checking whether the module
keeps it everywhere. `hashline.js` writes "read each untrusted property exactly
once" three times and then breaks it in the one helper whose whole job is
handling hostile values; `crc32.js` wraps one untrusted read and not its
sibling. Proposing to the gardener that the warden brief add: when a diff
documents a defensive discipline in prose, grep the diff for every other site
that discipline covers before reading anything else — the violation is usually
in the helper the prose is proudest of.
