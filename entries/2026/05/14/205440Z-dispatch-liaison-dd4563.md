---
ts: 2026-05-14T20:54:40Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo
    pr: 1256
    role: source
  - repo: endojs/endo
    issue: 1206
    role: source
---

# Dispatch: builder mirrors endo#1256 (bundle-source missing-entrypoint) — investigate first, then fix or report-for-closure

Dispatch root: `dispatches/builder--dd4563/`. Project worktree on `endojs/endo-but-for-bots@master` (detached). The bug-fix target is master per the implementation-on-master rule (fixes ferry upstream from there).

## The original

[endojs/endo#1256](https://github.com/endojs/endo/pull/1256), opened 3 years ago by @warner, closes [#1206](https://github.com/endojs/endo/issues/1206). Issue #1206:

> The following program should throw an error because bogus.js does not exist. Instead, it generates a bundle.
> ```js
> import '@endo/init';
> import bundleSource from '@endo/bundle-source';
> (async () => {
>   const bundle = await bundleSource(new URL('bogus.js', import.meta.url).pathname);
>   console.log(bundle);
> })();
> ```

PR #1256's diff (current head `2b92db74`):

```diff
+ assert(fs.existsSync(startFilename));
```

plus a stub test file `packages/bundle-source/test/test-missing-entrypoint.js` whose expected-message regex is the placeholder `'xxx'`. The PR has been in draft for 3 years; the bundle-source module has likely evolved since.

## Per-action authorization

Standing on endo-but-for-bots: push, open PR. READ-ONLY on `endojs/endo` (no comment on #1256 or #1206; the upstream interaction routes via boatman later if applicable).

## Task

Two phases. Phase 1 is investigation; Phase 2 depends on Phase 1's finding.

### Phase 1: investigate (does the bug still exist?)

1. **Read the current `packages/bundle-source/src/index.js`** on the worktree's master. Locate the `bundleSource` entry point. Note: 3 years on, the function shape and the input-handling path may have changed; the old `assert(fs.existsSync(startFilename))` may not even apply cleanly.

2. **Write a minimal repro test**: a single AVA test that invokes `bundleSource` on a path to a non-existent file (e.g., `'./does-not-exist.js'`) and asserts what currently happens. Run the test against the current master. Determine empirically: does bundling silently produce output, or does it throw?

3. **Branch on the finding**:
   - **Bug still exists**: proceed to Phase 2a.
   - **Bug is fixed**: proceed to Phase 2b.

### Phase 2a (bug still exists): mirror + fix

1. **Author the fix.** The 3-year-old proposed fix (`assert(fs.existsSync(startFilename))`) is the right shape, but the modern code-path may need the check in a different location (e.g., if `bundleSource` now accepts a `read` function rather than a filesystem path, the check shape is different). Implement the modern equivalent.

2. **Author a real regression test**: the test from #1256 with a proper error-message regex (not `'xxx'`). Verify the test fails before the fix and passes after. Per `skills/regression-evidence/SKILL.md`, every new test must be load-bearing.

3. **Open the fork-side mirror PR** on `endo-but-for-bots@master`. Branch: `fix/bundle-source-missing-entrypoint`. Title: `fix(bundle-source): assert that the entrypoint exists at all (mirror of endojs/endo#1256, closes #1206)`. Body cites the original issue and PR + describes the modern fix shape.

4. **Open as DRAFT** per the new PR-creation flow. The steward's per-cycle scan picks up from here (cleaner → judge → fixer-loop → un-draft).

5. **Out of scope for Phase 2a**:
   - Do not comment on upstream #1256.
   - Do not open a cross-fork PR against upstream.
   - The boatman ferries to #1256 later, after the fork-side panel approves.

### Phase 2b (bug is fixed): report for closure

1. **Verify the fix is intentional**, not coincidental. Run `git log -p packages/bundle-source/src/index.js` and look for a commit that addressed missing-entrypoint behavior. If you find it, cite the commit. If you don't, write a short paragraph describing where in the current code path the bundle errors out (e.g., a `fs.readFile` rejection that propagates up).

2. **Write a journal entry** at `<journal>/entries/2026/05/14/<HHMMSS>Z-result-builder-dd4563.md` (your normal result entry) noting:
   - The bug is fixed at master `<sha>`.
   - The mechanism: cite the commit or the code path.
   - The recommendation: close endojs/endo#1256 with a note (e.g., "the missing-entrypoint case is now handled at <location>; this PR is no longer needed").

3. **Add a row to the bulletin**'s *Awaits maintainer decision* section noting the recommendation: close #1256 (and confirm #1206 stays closed) with a note describing where the modern fix lives.

4. **No fork-side PR opened.**

## Report (either phase)

≤ 300 words: the finding (bug-still-exists vs bug-fixed), what was authored or recommended, one-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`.
