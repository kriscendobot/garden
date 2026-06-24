---
ts: 2026-05-15T04:32:00Z
ts: 2026-05-15T04:32:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: source
refs:
  - https://github.com/endojs/endo/pull/3232#discussion_r3245918820
---

# Dispatch: fixer applies gibson042's r3245918820 feedback to #75 (gamut continuation follows)

Dispatch root: `dispatches/fixer--e037f1/`. Project worktree on `endojs/endo-but-for-bots@kriskowal-random-chacha12` (current head `f82c9d9cd`).

Maintainer directive (2026-05-15): *"Please dispatch a fixer to #75 to respond to Richard's feedback and run the gamut again https://github.com/endojs/endo/pull/3232"*.

## The feedback

Richard (`@gibson042`) submitted one inline comment on upstream #3232 (review id `PRR_kwDODR4qQ88AAAABAAbcvw`, commit `6fbe4b06`, comment id `3245918820`) on `packages/random/test/random.test.js:57`:

> This strikes me as overly brittle; it presumes a particular pattern of consumption that is not required (i.e., little-endian consumption of the buffer that retains its first octet and interprets it as the least significant of the value to be scaled down). Less brittle would be something like this:

Verbatim suggestion (apply this in place of the current `random() multiplies randomUint53 by exactly 2 ** -53` test):

```js
// We expect random() to achieve a uniform distribution by scaling down
// randomUint53() output by exactly `2 ** -53`, but don't want to overly
// constrain _how_ the former maps octets into integers (consuming 8 vs. 7, big
// vs. little endian, etc.). So we provide a source that sets every bit to
// force maximum output, and if we ever need even more assurance could also use
// sources that set every bit of four contiguous octets after a prefix of 0 to 4
// fully-clear octets (0xFFFFFFFF_00..., 0x00FFFFFF_FF00...,
// 0x0000FFFF_FFFF00..., 0x000000FF_FFFFFF00..., 0x00000000_FFFFFFFF_00...),
// exactly one of which should drive random() output to be `0.5 - 2 ** -53`
// (i.e., the one in which the set octets correspond exactly with the least
// significant 32 bits for randomUint53).
test('random() multiplies randomUint53 by exactly 2 ** -53', t => {
  /** @param {Uint8Array} out */
  const maxSource = out => {
    for (let i = 0; i < out.length; i += 1) out[i] = 0xFF;
  };
  t.is(random(maxSource), 1 - 2 ** -53);
});
```

## Task

1. **Read the existing test** at `packages/random/test/random.test.js` near line 57. Confirm the brittle test that Richard's suggestion replaces (the `randomUint53 * 2 ** -53` equivalence test added per his earlier r3239085874 — and re-targeted here for less-brittleness).

2. **Replace the brittle test body** with Richard's suggestion verbatim. Keep the test name identical (`'random() multiplies randomUint53 by exactly 2 ** -53'`) so the upstream review thread anchor remains pointable.

3. **Run the affected test locally:** `yarn workspace @endo/random test --match 'random() multiplies*'` — must pass. (If yarn is unavailable in the dispatch root per today's recurring observation, document and proceed; the fixer's first commit + push happens BEFORE extended local validation per the self-improvement filed at `015257Z`.)

4. **Commit** as a single conventional commit:
   - Subject: `test(random): use maxSource to assert random = randomUint53 * 2 ** -53 (per r3245918820)`
   - Body: cites the upstream review thread anchor; one-line on why less-brittle.

5. **Per today's self-improvement:** commit + push BEFORE extended local validation.

6. **Push** with `--force-with-lease=kriskowal-random-chacha12:f82c9d9cd6a4dd37864316fbf03825266cd9288e origin HEAD:refs/heads/kriskowal-random-chacha12`.

7. **Shepherd** — watch CI converge via `gh pr checks 75 --watch`. `test-ocapn-guile-interop` is the gating signal.

## Per-action authorization

Standing on endo-but-for-bots: force-push to `kriskowal-random-chacha12`. READ-ONLY on `endojs/endo`.

## Gamut continuation (post-fixer)

After this fixer reports back green CI, the liaison dispatches:

- **Judge** — 12-seat code panel on the new head (the PR touches production source under `packages/random/`, `packages/chacha12/`, tests, changesets).
- **Fixer-loop** if must-fix items surface; otherwise the judge declares the loop done.
- **The PR is already non-draft.** Judge's final act on a successful loop is to post the formal approve review; no un-draft needed.

The fixer's report below kicks off the gamut continuation; no need for the fixer to dispatch the judge itself.

## Out of scope

- **No comment on #75 or upstream #3232.** The fixer applies the suggestion silently; the boatman (when next ferried) carries the reviewthread-reply forward.
- **No upstream interaction.** Bot-side fix only.
- **No retcon.** The new commit lands on top of the current shape; if a future retcon batches the work into the existing `simplify-magic-multiplier` commit, that happens at ferry time.
- **No un-draft action.** #75 is already non-draft.

## Report

≤ 300 words: file edited, commit SHA + subject, head SHA after push, CI status at fixer-end, one-line `Self-improvement: ...`. The liaison reads the report and dispatches the judge for the gamut continuation.
