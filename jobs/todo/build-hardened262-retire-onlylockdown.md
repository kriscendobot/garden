---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# build: retire lockdown-only test selection in @endo/hardened262

Repo: **endojs/endo-but-for-bots**, base branch **llm**.

## Origin

kriskowal approved #1064 and asked (review 5045929318):

> Please post a follow-up job to propose a change that causes these tests to be
> run in every environment, removing the lockdownOnly flag from the run. This may
> reveal new failures that need addressing, but moreover will increase clarity for
> coverage ratchets.

The garden's first answer was a **design document** (PR #1066,
`design/hardened262-all-environment-runs`). kriskowal **closed it** with "Not
what I'm looking for" (comment 5446412651). Read #1066 CLOSED for the technical
groundwork only — it is well-grounded on the mechanism and the measured deltas —
but its *disposition* is what was rejected: it proposed to bank +14 new
`failed.txt` entries and left open questions. Do **not** reproduce that. Deliver
the actual code change, not another design.

## The change

In `packages/hardened262/`, remove the `onlyLockdown` front-matter flag from all
flagged cases (the design counted 14) so they run in **every** wired scenario
(`module` and `lockdownModule`) across `xs`, `sesXs`, `sesNode`, instead of being
filtered out of the non-lockdown column by the generic `only[A-Z]` filter
(`filterOnlyRules`). Rediscover the exact flagged set yourself (`grep -rl
onlyLockdown packages/hardened262/test`), don't trust the count.

## Disposition of surfaced failures — the point of the rejection

Follow the maintainer's own **#1064 precedent** (commit `ec37f708d`, "run buffer
coverage without lockdown"): where a newly-run case fails only because it asserts
a **lockdown-only postcondition** (e.g. `assert(Object.isFrozen(...))` that only
holds after `lockdown()`), **fix the test** — strip/guard that assertion — so it
passes in the non-lockdown column too. Keep the coverage ratchet **failure-free**;
do not add accepted `failed.txt` entries as the design proposed.

Only a case that fails because the combination is **genuinely unsupported** in an
environment (not a lockdown-only assertion, not a fixable test bug) may remain a
failure — and if any such case exists, call it out explicitly in the PR body for
the maintainer, with the root cause, rather than silently baking it into baseline.
Regenerate the `baseline/` ledgers to match and verify `git diff` on baselines is
confined to the intended movement (additions in `*/module/*.txt`, no
`lockdownModule` churn), with `scripts/scenarios.test.js` (the golden test) still
green.

## Deliverable

A normal mergeable PR against `llm` with the corpus edit + fixed tests +
regenerated baselines. This auto-runs the gauntlet. Not a draft, not a design.
