---
job: a5f036
posted_by_role: liaison
posted_by_host: endolinbot
posted_at: 2026-05-19T03:06:39Z
verb: fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 75
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - general-contractor
refs:
  - https://github.com/endojs/endo/pull/3232#discussion_r3245953732
  - https://github.com/endojs/endo/pull/3232#discussion_r3263397803
preconditions: []
claimed_by_role: general-contractor
claimed_by_host: endolinbot
claimed_by_session: 11ad
claimed_at: 2026-05-19T03:14:30Z
result_entry: entries/2026/05/19/031739Z-result-fixer-f86dd6.md
completed_at: 2026-05-19T03:18:42Z
outcome: done
---

# Fix: carry upstream feedback back to mirror endojs/endo-but-for-bots#75

Source: upstream `endojs/endo#3232` (the upstream of our bot-fork mirror PR #75).
Mirror: `endojs/endo-but-for-bots#75` (`feat(random,chacha12): factor @endo/random from @endo/chacha12`). Head `9e3a7727`. Branch `kriskowal-random-chacha12`.

## The feedback chain

The recent thread on `packages/random/test/random.test.js:57` (which currently uses the `maxSource` all-bits-set fixture per yesterday's fixer that applied `r3245918820`):

1. **gibson042, 2026-05-15T04:45:19Z (`r3245953732`)** — followup to his original suggestion:
   > *"But on the other hand, this brittleness could be construed as a feature that prevents refactors from accidentally slipping in breaking changes. In which case I would highlight that in the explanatory comments (but also still do the set-all-bits analog as well)."*

2. **kriskowal, 2026-05-19T03:00:00Z (`r3263397803`)** — agreed and proposed:
   > *"Agreed. This was emitted in order to provide assurance that the max float int constant matched the value prescribed in the comment, but I like narrowing this fence. I'm going to propose both all set, none set, 52 bits set, and 53 bits set."*

The agreed-upon expansion: four assertion sources for the `random() multiplies randomUint53 by exactly 2 ** -53` test:
- All set (already in the test; `maxSource` filling every byte with `0xff`) → `random === 1 - 2 ** -53`
- None set (zero source) → `random === 0`
- 52 bits set → `random === ? × 2 ** -53` (the exact value depends on the bit pattern → calculate)
- 53 bits set → `random === ? × 2 ** -53` (calculate)

The fixer **figures out the exact expected float values** by reasoning about the bit-shift mechanism the test exercises. The test should also include the explanatory comment Richard asked for: highlight that the brittleness is a *feature* (refactor-prevention) so future maintainers understand why the assertions are coupled to the specific bit patterns.

## Task

1. Edit `packages/random/test/random.test.js` near line 57. Keep the test name (`'random() multiplies randomUint53 by exactly 2 ** -53'`) so the upstream thread anchor remains valid.
2. Replace the body with the four-source variant. Compute the expected values by reading `packages/random/src/read-uint.js`'s `randomUint53` implementation; the value should be derivable analytically.
3. Add the explanatory comment Richard asked for: brittleness = refactor-prevention; cite both `r3245953732` and `r3263397803` in the comment provenance.
4. **The mirror-only nature of this work**: this is a bot-fork PR (`endojs/endo-but-for-bots#75`); changes land there, NOT on `endojs/endo`. The boatman ferries to upstream when the maintainer authorizes.
5. Per today's self-improvement: commit + push BEFORE extended local validation. Force-push with `--force-with-lease=kriskowal-random-chacha12:9e3a77276`.
6. Conventional commit:
   - `test(random): broaden randomUint53 multiplier assertion to four bit-pattern sources (per r3245953732 + r3263397803)`
   - No yarn.lock churn expected.
7. Local validation:
   - `yarn workspace @endo/random test --match 'random() multiplies*'` — all four assertions pass.
   - `yarn lint` clean.
8. CI watch via `gh pr checks 75 -R endojs/endo-but-for-bots --watch`.

## Per-action authorization

Standing on endo-but-for-bots: force-push to `kriskowal-random-chacha12` with lease. READ-ONLY on `endojs/endo`.

## Out of scope

- No upstream ferry — boatman handles when authorized.
- No upstream comment.
- No un-draft (already non-draft).
- No code changes outside the multiplier test.

## Report

File edited, commit SHA, head SHA after push, four expected-value computations (briefly), CI status, one-line `Self-improvement: ...`.
