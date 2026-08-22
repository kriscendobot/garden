---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-08-22T05:48:52Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Guard @endo/pass-style byteArray tests against native immutable ArrayBuffer

Follow-up from `endojs-endo-but-for-bots-pr475-verify-shimmed-claim-20260819`
(erights review on endojs/endo-but-for-bots PR #475). That job guarded the
emulated-wrapper unit tests in @endo/bytes and @endo/immutable-arraybuffer so
they skip when a native immutable ArrayBuffer implementation (current XS) is
present — the shim is detect-then-skip, so native yields a GENUINE view and the
emulated-only assertions would otherwise fail. See landed commit on the PR head
(feat/narrow-bytearray-to-uint8): "test(immutable-arraybuffer,bytes): skip
emulated-wrapper assertions under native immutable ArrayBuffer", which adds
`packages/immutable-arraybuffer/test/_emulated-only.js` (`emulatedOnlyTest`).

`packages/pass-style/test/byteArray.test.js` has the SAME latent dependency and
was left for this dedicated pass because it is more nuanced than a mechanical
skip. ~9 tests construct an emulated wrapper and then either (a) tamper via
`view[0] = X` (which on the emulated plain-object path creates an own OrdinarySet
shadow property, but on a native genuine view over an immutable buffer is a
silent no-op — the tamper scenario is unreachable), or (b) tamper via
`defineProperty(view, '<index>', ...)` (integer-indexed exotic semantics differ
on a genuine typed array), or (c) assert the brand-check rejection message
`emulated wrapper, isView false, needs 0`. All would behave differently under
native. pass-style's package.json has NO `test:xs`, so like the other two these
run only under Node today and are inert until an engine ships native support (or
`test:xs` is wired to xst).

Task, against the current #475 head:
1. Enumerate every test in `packages/pass-style/test/byteArray.test.js` (and any
   sibling pass-style test) whose assertion or setup assumes the emulated
   plain-object wrapper (isView false; `view[i]===undefined`; a `view[0]=X`
   own-property shadow; `defineProperty` on an out-of-range/integer index; the
   `isView false, needs 0` rejection message). Do NOT flag assertions that hold
   on both paths (accepting a genuine frozen Uint8Array, byteOffset/length
   checks, element-value reads).
2. Guard each emulated-only test with a native-detection predicate — reuse the
   `emulatedOnlyTest` idiom (a small local helper mirroring `_emulated-only.js`,
   or an inline `!ArrayBuffer.isView(<emulated wrapper>) ? test : test.skip`).
   Where a tamper scenario is simply unreachable on native, skipping is correct;
   where a genuine-path equivalent is meaningful, prefer adding it too.
3. Run the pass-style suite under Node to confirm no regression. pass-style tests
   need PATH shims locally: run via
   `node <repo>/packages/ses-ava/bin/ses-ava.cjs <testfile>`.
4. Lint the changed files (0 errors).
5. Commit (test-only, no changeset needed) and push to the PR head branch
   `feat/narrow-bytearray-to-uint8` with a rebase CAS. Do NOT open a new PR; do
   NOT resolve any review conversation (erights policy, comment 5333026938).

Note: @endo/base64 was audited and is clean (only descriptive comments). The
obsolete prose claim does NOT survive anywhere in the tree — design docs,
READMEs, and changesets are already correctly hedged; the dependency lives only
in test code.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-22T06:17:51Z
