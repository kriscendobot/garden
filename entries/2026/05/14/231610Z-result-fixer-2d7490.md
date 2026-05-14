---
ts: 2026-05-14T23:16:10Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/14/230821Z-dispatch-liaison-2d7490.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 247
    role: target
---

Responded to kriskowal's two substantive inline questions on PR #247.

## Question 1 (sesAva ava-config investigation)

Thread reply only (no code change). The eventual-send Cut does not
exercise the constraint because `@endo/eventual-send` had only a plain
`ava` block, not `sesAvaConfigs`. The reply records the finding:
**yes** for any future sibling-test package whose source package uses
`sesAvaConfigs` (e.g. `promise-kit`, `pass-style`, `patterns`,
`marshal`, `exo`, `errors`, `captp`, `bytes`, `compartment-mapper`),
**no** for this Cut.

Recommended shape for the first such Cut: per-sibling-test wrapper
configs that import the root config (`../../../ava-endo-lockdown.config.mjs`
etc.) and spread it, adding `--conditions=test-endo-<pkg>` to
`nodeArguments`. Three or four four-line wrappers per sibling-test
package. A `withCondition(base, 'test-endo-<pkg>')` helper could
collapse these but I would want two or three concrete instances before
factoring out the helper.

Reply at <https://github.com/endojs/endo-but-for-bots/pull/247#discussion_r3244840214>.

## Question 2 (import E directly)

Code change + thread reply. Refactored `_get-hp.js` to load
`@endo/eventual-send/shim.js` and import `E, HandledPromise` from the
public surface of `@endo/eventual-send`, replacing the prior
`makeE(makeHandledPromise())` construction through the
`test-endo-eventual-send` exports condition.

The blocking constraint was that `no-shim.js` reads
`globalThis.HandledPromise`. Loading the shim from `_get-hp.js` is
fine: each AVA test process is fresh, the side effect on `globalThis`
is per-process. The six tests that go through `_get-hp.js`
(`e`, `eventual-send`, `hp`, `proxy`, `thenable`, `types`) plus the
`exports.test-d.ts` type test now ride the public surface. The two
internal-surface tests (`local.test.js`, `message-breakpoints.test.js`)
remain the sole consumers of the `test-endo-eventual-send` condition.

All 64 tests pass. Lint clean (0 errors). Format clean. tsc clean.

Commit `3d46ec51a` (`refactor(eventual-send-test): import E and
HandledPromise from public surface in _get-hp.js fixture`).

Reply at <https://github.com/endojs/endo-but-for-bots/pull/247#discussion_r3244840274>.

## CI

Pushed after rebase onto the new tip `ac989794b` (an interim
`chore(eventual-send-test): fix import order in exports.test-d.ts`
landed between dispatch-prepare and my push). CI run started on
`3d46ec51a`; matrix pending at time of writing. The `test-ocapn-guile-interop`
job is pass-equivalent per standing instruction.

## Out of scope

No re-request, no upstream top-level summary comment. The PR remains
non-draft. The standing review-state will advance on its own.

Self-improvement: nothing this time. The Q2 refactor and the Q1 finding
both fell out of reading the existing `_get-hp.js`, the eventual-send
exports map, and the `ses-ava` README and command source. The pattern
recommendation for future sibling-test packages is recorded above; if
the recommendation lands in two or three Cuts and the helper-factoring
threshold trips, it could become a skill at that point, but one
prospective instance is not enough.
