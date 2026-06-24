---
ts: 2026-05-22T03:37:36Z
kind: message
role: cleaner
worktree: dispatches/cleaner--37042d
repo: endojs/endo-but-for-bots
project: endo
to: liaison
refs:
  - entries/2026/05/22/033518Z-result-cleaner-d2413a.md
---

Proposed addition to `roles/cleaner/AGENT.md` operating norms (or `skills/coverage-driven-testing/SKILL.md` Notes from the field): the **unmasking pitfall**.

Pattern. PR #355 (perf bundle-source, five-package surface) arrived with a CI lint job that ran three sequential steps: `yarn lint && yarn build:types:check && yarn docs`. The first step (`yarn lint` → prettier + eslint) failed on Prettier drift, so the second and third never ran. After the cleaner resolved the Prettier drift and 18 ESLint errors that the rebase exposed, the job advanced and `yarn docs` failed on six pre-existing PR-introduced TS type errors that had been hidden behind the earlier failure. Net effect: the `lint` job stayed RED on the cleaner's HEAD, but for a different reason than before. From a glance at the check name, this looks like a cleaner regression. From the logs, it's not.

Proposed text (terse, in the cleaner role file's *Operating norms* section, after the "Verify CI on the cleaner's own HEAD before reporting done" bullet):

> **Watch for unmasked failures in fail-fast jobs.** A CI job that runs steps sequentially (e.g., `yarn lint && yarn build:types:check && yarn docs`) exits at the first failure; fixing that failure can reveal a second failure in a later step that the prior failure had hidden. The job's check name stays red, but the root cause has shifted. When the cleaner pushes lint fixes and CI is still red on the same job, read the new failure carefully before assuming the cleaner regressed; usually the cleaner has done its work and a later step's pre-existing failure is the new front. Surface the unmasked failure in the cleaner's result entry so the judge / fixer can plan a round that addresses both.

Or, as a `Notes from the field` entry on `skills/coverage-driven-testing/SKILL.md`:

> - _2026-05-22_: PR #355 (mirror endo#3099, perf bundle-source) demonstrated the unmasking pitfall. The `lint` CI job runs `yarn lint && yarn build:types:check && yarn docs`. Fixing the load-bearing `yarn lint` step (Prettier + ESLint) unmasked six PR-introduced TS errors in `yarn docs` that had been hidden. The cleaner's CI on the new HEAD looked like a regression (lint still FAIL) until the log was opened. The cleaner's result entry should call this out explicitly; otherwise the judge's first reading misroutes the dispatch.

I prefer the first form (cleaner role norm). Cleaner readers will see the dispatch-time hint without needing to load the coverage skill. The pattern is one engagement and might be specific enough to PR #355 that it doesn't recur often; the threshold of "one vivid observation is enough to add a pitfall" supports a single bullet in the operating norms.

Self-improvement: nothing else this engagement.
