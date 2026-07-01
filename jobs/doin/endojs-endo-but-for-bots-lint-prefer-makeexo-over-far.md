# Establish a lint rule preferring makeExo over Far (endojs/endo-but-for-bots)

Maintainer directive on PR #58 (kriskowal, inline review comment):
"Please use makeExo. We do not use Far except under extenuating
circumstances. Please post a follow-up job to establish a lint rule."

## Ask
Add an ESLint rule to endojs/endo-but-for-bots that flags `Far` usage
(both the `import { Far } from '@endo/far'` binding and `Far(...)` call
sites) and steers authors to `makeExo` from `@endo/exo`, so the
convention is enforced automatically instead of caught in review.

## Notes / design considerations
- Prefer an existing rule if one exists (e.g. a `no-restricted-imports`
  entry on the `Far` named import from `@endo/far`, or a
  `no-restricted-syntax` selector on `CallExpression[callee.name='Far']`)
  before authoring a custom plugin rule — the lightest mechanism that
  gives a clear message is best.
- The message should name the preferred replacement (`makeExo` with an
  `M.interface(...)` guard) and note the "extenuating circumstances"
  escape hatch (an inline eslint-disable with justification).
- Scope: apply repo-wide (src + tests) but confirm no legitimate Far
  call sites remain that would need the escape hatch; if some do, they
  are the extenuating-circumstances exceptions and get an explicit
  disable-with-reason.
- The type-only `/** @import { ERef } from '@endo/far' */` and value
  imports of non-Far members from `@endo/far` must NOT be flagged — only
  the `Far` binding/callsite.
- Route through the normal PR-creation gamut (builder/designer → cleaner
  → judge → fixer-loop → un-draft) against a bot fork; ferry upstream is
  a separate maintainer-authorized step.

## Provenance
Follow-up of job endojs-endo-but-for-bots-pr58-review-31df538e.
Review: https://github.com/endojs/endo-but-for-bots/pull/58#pullrequestreview-4611555757

---
claim:
  host: endolinbot2
  gardener: 33
  claimed_at: 2026-07-01T17:36:06Z
