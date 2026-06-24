---
ts: 2026-05-15T02:24:48Z
kind: message
role: weaver
to: liaison
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/021841Z-dispatch-liaison-ef7995.md
---

# weaver rebase of #107 onto origin/kriskowal-random-chacha12: reshape required, stopping per dispatch contract

## What I did

Surveyed divergence: HEAD (`design/random-pure-rand-v8-interface`, 436f07c6b) is 28 ahead / 38 behind `origin/kriskowal-random-chacha12` (b0d9f31ce). Patch-id-aware `git log --cherry-pick` shows zero shared commits: the new base rewrote the random/chacha12 history end-to-end.

The PR #107 branch is really just four commits on top of an old #75 base (`6f109f571`):

1. `99d870b6b refactor(random): remove fast-check adapter (moved to #107)` — removes `fast-check.js`, the typedef, and two adapter tests from `packages/random/`.
2. `5f57652f3 chore: Update yarn.lock`.
3. `4e8e1ea20 feat(random-fast-check): new package with v5 + v8 pure-rand adapters` — adds the entire new `packages/random-fast-check/` package and `designs/random-pure-rand-v8-interface.md`.
4. `436f07c6b chore: Update yarn.lock`.

Tested a `git rebase --onto origin/kriskowal-random-chacha12 6f109f571 HEAD` and a cherry-pick of just commit 3 onto the new base in a detached scratch HEAD (now reset; nothing pushed). The mechanical picture is clean:

- Commit 1 is fully obsoleted by the new base, which already removed `packages/random/fast-check.js` and rewrote the package. Skips cleanly.
- Commits 2 and 4 are superseded; regenerate `yarn.lock` once at the end.
- Commit 3 cherry-picks with no conflicts (all-new files).

## Why I stopped

Beyond the mechanical part, the new package does not run on the new base without semantic adjustments that go past "rename moved imports":

1. `packages/random-fast-check/index.js` line 31: `import { randomUint32 } from '@endo/random/read-uint.js'`. The new base renamed that subpath to `uint.js`. One-line fix; mechanical.

2. `packages/random-fast-check/test/_make-source.js` line 20: `makeSource = seed => makeChaCha12(seed)` and treats the result as a `RandomSource` (`(out: Uint8Array) => void`). On the new base, `makeChaCha12(seed)` returns a `ChaCha12Generator` record `{next, getState, clone, fillRandomBytes}`. The new base's own random tests pattern this as `makeChaCha12(seed).fillRandomBytes`. This is a one-symbol fix but it is an **interface change**, not a rename: callers that relied on `makeChaCha12(seed)` being callable have to change.

3. `designs/random-pure-rand-v8-interface.md` (437 lines) tells a narrative that no longer matches what landed. Sample stale claims: "PR #75 in turn no longer ships a `fast-check.js` subpath at all" (true, but the surrounding API description is the pre-rewrite shape), "PR #75 drops `packages/random/fast-check.js`, the ... `@fast-check/ava` devDep, and the `./fast-check.js` subpath export" (the new #75 went further: it also dropped `random.types.d.ts`, renamed `read-uint.js` → `uint.js`, and reshaped `chacha12` into a generator record). The doc reads like it was written against an earlier #75 draft. A fixer needs to walk the doc against the actual `origin/kriskowal-random-chacha12` API and reword the affected sections.

Per dispatch instructions ("if reshape work is needed beyond mechanical conflict resolution (the maintainer mentioned reshape), surface as message-to-liaison and stop; a follow-up fixer handles the reshape"), I am stopping here. Items 2 and 3 are reshape; item 1 alone would be mechanical.

## Suggested fixer dispatch

The fixer can do all four steps as one commit chain on top of `origin/kriskowal-random-chacha12`:

1. Cherry-pick `4e8e1ea20` (it conflict-frees).
2. Edit `packages/random-fast-check/index.js`: `read-uint.js` → `uint.js`.
3. Edit `packages/random-fast-check/test/_make-source.js`: `makeChaCha12(seed)` → `makeChaCha12(seed).fillRandomBytes`.
4. Walk `designs/random-pure-rand-v8-interface.md` against the new-base APIs (`@endo/random` subpaths, `@endo/chacha12` generator record shape, `RandomSource` semantics) and update the stale sections. The doc's "v8 interface" thesis still holds; the surrounding context paragraphs need refresh.
5. Regenerate `yarn.lock` against the new base (single commit at the end, not the original two-commit pattern, per yarn-lock-separate-commit skill).
6. Force-with-lease push.

## Current state

`design/random-pure-rand-v8-interface` on origin and in the worktree is **unchanged** from when I started (still at 436f07c6b). The scratch rebase / cherry-pick attempts were aborted; no force-push was issued. Working tree is clean.

Self-improvement: nothing this time. The dispatch contract worked exactly as written: the reshape was detectable from a survey-then-scratch attempt, and the surface-and-stop branch fired cleanly.
