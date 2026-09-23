# Completion report: ebfb-lockdown-ava-snapshot-uint8array-corruption

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1334 (head `llm-fix-lockdown-ava-snapshot-uint8array`, base `llm-f9cbcfc`). It patches ava so that writing a snapshot under `@endo/init` produces a readable file, adds a regression test, and repairs the one corrupt snapshot in the repo. The new test fails without the patch and passes with it.

**Root cause.** Confirmed as the job describes, with one detail added: the shim also points `Uint8Array.prototype.constructor` at the emulated constructor. So `value.constructor` no longer matches the `Uint8Array` that cbor2 looks up. The same thing would happen to any library that keys a lookup on the original constructor, including cbor2's own default encoders.

**Why the fix is in ava, not the shim.** Keeping the original constructor identity isn't possible:
- SES requires `%Uint8ArrayPrototype%.constructor === %Uint8Array%`, and its permit check throws `Does not match permit` otherwise.
- The original built-in `Uint8Array` constructor can't be made to return the emulation's view over an immutable buffer.
- Pointing `constructor` back at the original would make `new Uint8Array().constructor !== Uint8Array` visible to all code.

So I took the job's fallback of a test-harness fix.

**Changes**
1. **ava patch.** `.yarn/patches/ava-npm-8.0.1-b8bcbeb736.patch`, applied through the root `package.json` `resolutions.ava`. `yarn.lock` gains the patched entry, and no workspace `package.json` changed. At encode time ava now also registers the current global `Uint8Array`, if it isn't already registered.
2. **Regression test.** `packages/init/test/snapshot-roundtrip.test.js`, with its fixture and config under `test/_snapshot-roundtrip/`. It runs ava in a child process on a fixture that imports `@endo/init/debug.js`: first with `--update-snapshots` into a temporary directory, then again to read the snapshot back. With the patch disabled it fails with the original `Received undefined at Function.from` error.
3. **Snapshot sweep.** I decoded all 19 files from `git ls-files '*.snap'`. Only `packages/ocapn/test/snapshots/api-surface.test.js.snap` was corrupt. #475 (3acee4a566) had regenerated it and worked around the failed read by comparing the `.md` report by hand instead of calling `t.snapshot`. I restored `t.snapshot`, removed the workaround, and regenerated the `.snap` (6008 → 811 bytes; the `.md` is unchanged).

**Checks run:** `packages/init` ava (6 tests passed) and `yarn lint` both pass; `packages/platform` ava passes (362 tests); the ocapn api-surface test passes; eslint is clean on the changed files.

**Follow-ups**
- The PR is a draft; to put it through review, the maintainer can say "run the gauntlet #1334".
- Until #1334 merges, running `--update-snapshots` under `@endo/init` on `llm` still writes corrupt files. That includes the #1100 gauntlet, so snapshot updates there should wait for #1334 or be rebased onto it.
- The same constructor mismatch can affect non-test code that uses cbor2's default encoders on typed arrays after lockdown. I didn't change that here; it may deserve its own issue.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-lockdown-ava-snapshot-uint8array-corruption.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3882117 cached reads)
- Output: 24789 tokens
- Cost: $2.0724114
- Wall-clock: 479s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
