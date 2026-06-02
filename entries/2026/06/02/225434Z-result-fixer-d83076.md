---
ts: 2026-06-02T22:54:34Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--d83076
prs:
  - repo: endojs/endo-but-for-bots
    pr: 388
    role: target
refs:
  - entries/2026/06/02/224651Z-dispatch-liaison-d83076.md
  - https://github.com/endojs/endo-but-for-bots/pull/388#issuecomment-4607634829
---

# result: fixer — #388 kriskowal review carry, in-PR items

## Head SHA after push

`f3de0d0fa` (was `f8d1d223b`).
Two-commit append: `59abce943` (impl) + `f3de0d0fa` (yarn.lock).

## Applied items (1-7)

- **1. Changeset deletion.** Removed `.changeset/endo-gateway-bootstrap-registrar.md` (changesets unneeded on llm branch).
- **2. `Uint8Array<ArrayBuffer>` typedef tightening on bootstrap.js:129.** Reverted after applying: the single-line tightening on the `signature` property caused 22 TS2740 errors in `bootstrap.test.js` / `gateway.test.js` (tests pass `kp.sign(...)` which returns `ArrayBuffer`). Surfaced as deferred item D0 in the top-level PR comment; addressed jointly with D3 (Uint8Array lingua franca) so the typedef stays internally consistent.
- **3. `checkBytes` → `checkBytesLength` rename.** Applied at definition + 3 call sites in `bootstrap.js`.
- **4. `listRegistrations` → `listRegisteredPeers` rename.** Applied: bootstrap.js definition, typedef, harden({}) export, comment ref; bootstrap.test.js 3 call sites + 1 test description.
- **5. RangeError coverage on node-crypto-powers.js:155.** Verified the bare `catch (err)` already covers `RangeError` (and every other emissible class); updated the comment to call out RangeError / OOM explicitly. No code change; reply on the inline thread will cite the comment-only addressing if the maintainer wants a thread-level acknowledgement.
- **6. `@endo/hex` adoption in proof-of-possession.js.** Removed local `toHex` helper; imported `encodeHex` from `@endo/hex`; replaced 2 call sites (issue + verifyAndConsume). Added `@endo/hex` to gateway's `package.json` dependencies. The `publicKeyToHex` helper in `bootstrap.js` is a separate manual hex encoder I left untouched (the reviewer's comment was scoped to `proof-of-possession.js`); could fold into a follow-up if desired.
- **7. Early-break in nonce `sweep()`.** Reshaped `for (...)` to `break` on first unexpired entry, with a comment explaining the monotonicity argument (constant `ttlMs` added to monotonic `clock.now()`, `Map` preserves insertion order).

## Local gate exit codes

- `corepack yarn install`: 0 (one warning about peer-dependency mismatches, pre-existing baseline).
- `cd packages/gateway && yarn lint`: 0. 27 warnings (0 errors), all pre-existing `jsdoc/reject-any-type` and `@jessie.js/safe-await-separator` in test files.
- `cd packages/gateway && yarn ava`: 0. 127 tests passed, 0 failures.

## Push

`git push origin HEAD:design/gateway-package-phase-2` succeeded; remote moved from `f8d1d223b` to `f3de0d0fa`.

## Top-level PR comment

[`endojs/endo-but-for-bots#388 (comment) 4607634829`](https://github.com/endojs/endo-but-for-bots/pull/388#issuecomment-4607634829). Body lists the 6 applied items, the D0 (signature typedef tightening) deferral, and the D1-D8 deferrals each with their reason.

## Reactji actions

Added `eyes` reactji on all 14 inline review comments under review `4413566645`:

- 3344371101 (.changeset)
- 3344377619 (typedefs to types.d.ts)
- 3344380292 (Uint8Array<ArrayBuffer>)
- 3344387661 (checkBytes rename)
- 3344394317 (Uint8Array lingua franca)
- 3344403912 (cancelled promise pattern)
- 3344408499 (listRegistrations rename)
- 3344448440 (Uint8Array obviates asNodeBytes)
- 3344457685 (RangeError coverage)
- 3344462878 (@endo/hex)
- 3344465380 (constant-time-equals)
- 3344469336 (early-break)
- 3344477615 (typedefs + carve juror + scripted skill)
- 3344480610 (fold into @endo/where)

## Judgment calls

- **Item 2 reverted post-apply (introduced as D0 in deferred list).** Tightening only the `signature` property of `RegistrationArgs` to `Uint8Array<ArrayBuffer>` while leaving `publicKey` and `nonce` siblings at `ArrayBuffer | Uint8Array` makes the typedef internally inconsistent and breaks `tsc` at every test call site (22+ TS2740 errors) because `kp.sign(...)` returns `ArrayBuffer`. The brief's "apply locally on the single line. Do NOT widen this into a stack-wide Uint8Array refactor" framing was internally incompatible with the tests as currently written, so the single-line apply was reverted; the directive is preserved as D0 in the top-level comment and jointly addressable with D3 (Uint8Array lingua franca). This is the cleanest "land what is in scope; surface the entanglement" handling.
- **Item 5 chose "comment-only" path.** The brief authorized this when "If it's already covered, leave a one-line comment confirming." The bare `catch (err)` already covers RangeError; the comment was expanded to call it out by name. The judgment is that "comment update" is the right artifact; no code change; the top-level PR summary cites the file:line for the maintainer's verification.
- **Item 6 scoped to proof-of-possession.js only.** Bootstrap.js's `publicKeyToHex` is a separate manual hex encoder. The reviewer's comment was on proof-of-possession.js only; the not-authorized list bars cross-package work but does not speak to other in-package occurrences. Left untouched in this dispatch for tight scope; if the maintainer wants both folded into `@endo/hex` the follow-up is trivial.

## Definition of done

- 6 of 7 must-fix items addressed in commit `59abce943`; item 2 deferred with rationale as D0 (entangled with D3).
- Separate `chore: Update yarn.lock` commit (`f3de0d0fa`).
- Top-level PR summary posted with applied items by SHA + D0-D8 deferrals each with reason.
- CI not yet observed on the new head; this PR is a kriscendobot DRAFT, so the maintainer's next-action venue is review-after-CI, not merge-queue.
- Result journal entry references the originating dispatch.

Self-improvement: a stricter "single-line typedef tightening" directive that breaks compile because the implementation accepts a wider type than the typedef now claims is a recurring shape (the implementation's runtime tolerance leaks ahead of the typedef's strictness). Worth a one-line note on `garden/skills/regression-evidence/SKILL.md` or a new "typedef-impl mismatch surfacing" skill: when a maintainer asks for a single-line typedef narrowing on a property whose implementation broadly accepts a wider type, run `yarn lint:types` *before* the surface-level apply; if `tsc` lights up at call sites, the right artifact is a deferral with the entangled refactor cited, not a strict-apply that the test gauntlet will catch downstream. Routed as a `message` to liaison if the pattern recurs; one-shot for now.
