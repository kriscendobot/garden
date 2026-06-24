---
ts: 2026-05-14T23:14:31Z
kind: result
role: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--3d93e2/project/
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - entries/2026/05/14/050123Z-result-fixer-c03b1d.md
  - entries/2026/05/14/225200Z-message-steward-7e3a91.md
---

# Result: fixer addressed kriskowal's 17-hour-stale CHANGES_REQUESTED on #75

Triaged kriskowal's 2026-05-14T05:15Z CHANGES_REQUESTED review on PR #75 (head was `bb24053ae`).
That review carried exactly one inline comment, not handled by today's earlier carry-feedback fixer.

## Unaddressed comment (one)

- [`r3239227139`](https://github.com/endojs/endo-but-for-bots/pull/75#discussion_r3239227139)
  on `packages/random/test/random.test.js:46`. kriskowal: "I had a much simpler verification in mind,
  verifying that the magic number is indeed === 2 ** -53, rather than relying on the veracity of a comment."

## Fix

`b0d9f31ce` `test(random): simplify magic-multiplier test to direct constant check (#75)`.

Replaced the three-mock elaborated assertion added in `bb24053ae` with a single assertion:
when `randomUint53(source) === 1`, `random(source)` reduces to the magic constant itself,
so `t.is(random(oneSource), 2 ** -53)` directly pins the constant in `src/random.js` to `2 ** -53`
without any reliance on the prose comment. One mock source, one assertion, no commentary about
"three points spanning the range".

## Local validation

`yarn lint`, `yarn lint:types`, `yarn test` on `packages/random`: all green (15 tests, both ses-ava
and endo configs). Fail-closed verified by perturbing `POW2_M53` to `2 ** -52` in `src/random.js`
locally; the new test fails with the perturbation, passes when restored.

## Push

`git push origin HEAD:refs/heads/kriskowal-random-chacha12` succeeded as fast-forward
(no force needed). PR #75 head is now `b0d9f31ce`. The local worktree was first reset from
the stale `836928335` to the actual remote head `bb24053ae`, then the new commit landed on top.

## CI

All matrix jobs green at `b0d9f31ce`. Only failing check is `test-ocapn-guile-interop`, which
the steward's standing instruction at `225200Z-message-steward-7e3a91.md` treats as pass-equivalent
pending the Guix-resilience follow-up PR.

## Replies / re-request

- Inline reply on the thread citing `b0d9f31ce`:
  https://github.com/endojs/endo-but-for-bots/pull/75#discussion_r3244800482
- Top-level summary comment: https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4455450707
- `gh api repos/.../pulls/75/requested_reviewers -f 'reviewers[]=kriskowal'` returned with
  kriskowal in `requested_reviewers`; review re-requested.

## Other 2026-05-14 review state (for completeness)

The earlier CHANGES_REQUESTED reviews at `2026-05-12T04:36Z` and `2026-05-12T05:01Z` carry the
batch of rename / package-shape / style-guide comments that today's prior fixer chain handled
across commits `01d02d4f9` (rename `types.d.ts`), `98f303fe7` (rename `uint.js`), `a35140551`
(chacha12-fast-check-test test-package shape), `381db0cbc` (markdown one-sentence-per-line),
`4be6ee0e2` (typedoc skipLibCheck), and earlier. The dispatch scoped this fixer to the
17-hour-stale review only; no further triage of the older threads in scope here.

## Self-improvement

Stale worktree gotcha: the dispatch root's `project/` was at `836928335` (an older PR head)
while the actual `origin/kriskowal-random-chacha12` was at `bb24053ae`. `git status` reported
"working tree clean" against the stale head, which silently invited a divergent commit base.
`skills/rebase-before-followup/SKILL.md` and `skills/worktree-per-pr/SKILL.md` both name `git fetch
origin <branch> && git reset --hard FETCH_HEAD` as the canonical "start fresh" step, but neither
flags the dispatched worktree itself as a candidate for staleness when the dispatch prompt asserts
a specific HEAD. A short note in `dispatch-worktree/SKILL.md` or in COMMON.md's *Where things are*
("verify `git rev-parse HEAD` matches the dispatch prompt's claimed HEAD; if not, fetch and reset")
would catch this before the first commit. Surfacing this as a `message: fixer → liaison` separately
rather than embedding the lesson here.

Self-improvement: dispatched worktrees can ship stale; the prompt asserting a HEAD does not make
it so. Verify `git rev-parse HEAD` vs the prompt before the first commit. Routed as a separate
message to the liaison.
