Everything is pushed and consistent (local == remote == `088168153`, tree clean). I've completed all the shepherd work that is tractable from this seat and reached a genuine design/security impasse on the rest, which I've escalated. Writing the completion report.

---

## Shepherd report — PR endojs/endo-but-for-bots#719 (`feat/hardened-url-vetted-shim`)

**Outcome: partial green + escalation.** The root cause of #719's red CI is a **broadly-red `master`**, not anything in #719's own diff — #719's URL work is sound (its 21 URL-shim tests all pass locally). The branch was 1 commit behind `master`, so I rebased it onto current `master` (clean, MERGEABLE) to bring in the files CI was actually testing via the merge commit.

### Fixed and pushed (head `088168153`, `--force-with-lease` against anchor `66204ddbb`)
- **`fix(cbor): declare @endo/eventual-send dev dependency`** — the `@endo/cbor` test failure (`Cannot find package '@endo/eventual-send'`) that was crashing **all** test lanes. cbor's `ses-ava` shims-only config (`ava-endo-shims-only.config.mjs`) requires `@endo/eventual-send/shim.js`, but cbor never declared the dep, so yarn's node-modules linker left it unresolvable. Every other `ses-ava` package declares it; I matched the convention. Verified: cbor's 10 tests now pass; CI lanes now run past cbor.
- **`style(ses): format …with prettier`** — the named Prettier failure in `packages/ses/test/text-encoder-decoder.test.js`. Verified: `lint:prettier` now reports "All matched files use Prettier code style!"
- **`fix(ses): declare globalThis for eslint …`** — a *second*, previously-masked eslint failure in the same file (`no-undef: globalThis`, hidden behind the `lint:prettier && lint:eslint` short-circuit). Added `/* global globalThis */` matching `test/global-object.test.js`. Verified: 0 eslint errors on that file.
- **`chore: Update yarn.lock`** (separate commit per convention).

Now green: `build`, `browser-tests`, `test262`, `cover`, `test-hermes`, `test-xs`, `test-ocapn-python`, `check-action-pins`, `viable-release`.

### Still red — all pre-existing `master`/repo debt, unrelated to #719's diff (escalated, `next: designer`)
I deliberately did **not** fix these in #719: bundling unrelated-package changes, SES security-permit edits, and a repo-wide 16-file pin bump into a URL feature PR is wrong PR hygiene, and two of them require decisions beyond a shepherd's authority. `master`'s own CI is red on the same three.

1. **Lint — 5 jsdoc warnings (eslint exits 1):** `packages/daemon/{directory.js:129,174; pet-sitter.js:71; pet-store.js:159}` (missing `@param`, present since 2026-06-26) and `packages/compartment-mapper/src/types/policy-schema.ts:64` (`@remarks` TSDoc tag rejected by `jsdoc/check-tag-names`). Trivial fixer work — but on packages #719 doesn't touch.
2. **Tests — 3 failures** from `master` commit `536f82d18` ("tame TextEncoder/TextDecoder as universal intrinsics"), which was merged with its test never validated (cbor crashed the lane first). Its `%TextDecoderPrototype%` permit sets `fatal: false`/`ignoreBOM: false` (stripping the getters its own tests expect) while the sibling `encoding: getter` survives — likely should be `fatal: getter`/`ignoreBOM: getter` to complete the standard-property whitelist. And its `absent when not on host` test excludes the codec via `globalNames` and expects absence, which contradicts the universal-intrinsic design its own changeset documents. **Changing SES permits is a security/design decision → `next: designer`.**
3. **zizmor (repo-wide, `master` also red):** GitHub moved the `actions/setup-node` `v6` tag to commit `249970729cb0`, so zizmor's online audit now flags every `48b55a011bda # v6` pin as stale across all 16 workflow refs. Needs an `update-action-pins` chore. Note tension: the offline `check-action-pins` job still **passes** with `48b55a`, so this is zizmor's live-tag audit vs. the repo's own pin policy — a maintainer call.

### Handoff
Messaged the maintainer (via the liaison) with the full diagnosis and a recommendation: **one `master`-greening job** (jsdoc docs + text-codec permits/tests reconciliation + action-pin bump), after which #719 rebases to green. #719's URL sections of `permits.js` don't overlap the text-codec permit section, so that rebase will be clean. Awaiting the go-ahead to post it (a reply will promote to a fresh job if I've completed).

**Escalation class: `next: designer`** (SES-permit design/security decision on `master`), plus operational lint/infra items for the same `master`-greening pass. All tractable shepherd work is done; the remainder is a genuine design/safety impasse beyond shepherd authority.
