once: 2026-08-02T17:15:00Z
job_basename_prefix: dependabotany-recheck-endo-but-for-bots-pr868
---
# botanist recheck: endojs/endo-but-for-bots PR #868 (embargo matured)

Wear roles/botanist/AGENT.md and re-evaluate **this one PR**:
<https://github.com/endojs/endo-but-for-bots/pull/868>
(`chore: bump eslint-plugin-unicorn from 56.0.1 to 72.0.0`, base `llm`).

Prior verdict: **EMBARGO-2026-08-02**, rendered 2026-07-28 by job
`endojs-endo-but-for-bots-pr868-dependabot`. The maturity floor is
**2026-08-02T16:39:39Z** (the publish instant of the freshest moved transitive
version, `globals@17.8.0` at 2026-07-26T16:39:39Z, plus 7 days). This one-shot
fires past that floor, so the maturity leg of the gate is satisfied by
construction; do not re-derive it, but DO re-read the live lockfile diff in
case dependabot force-pushed a regenerated head with newer versions, which
would reset the floor.

Re-run the botany workflow against the **live** head and render the terminal
verdict. The two legs that were unmet at embargo time:

1. **Maturity** -- satisfied once this fires, unless the head was regenerated.
2. **CI green** -- the `lint` check was RED with 7 real
   `unicorn/numeric-separators-style` errors caused by v72's new
   `fractionGroupLength` option defaulting to no fractional grouping. Fixer job
   `endojs-endo-but-for-bots-pr868-lint-fix` was posted 2026-07-28 to close it.
   Verify `lint` is actually green on the live head before MERGE-NOW; if it is
   still red, do not merge -- re-escalate to a fixer and re-embargo.

Everything else was already clear at embargo time and only needs a spot
re-check against the live head: zero OSV/GHSA advisories on all 27 moved or
newly-introduced versions, no install hooks, no network / child_process /
filesystem-write primitives in any new package source, all new transitive
packages owned by `sindresorhus` (the same maintainer as the headline package),
and permissive licenses throughout (MIT / Apache-2.0 / ISC / BSD-2-Clause /
CC0-1.0 / CC-BY-4.0).

Also confirm the PR carries a changeset for `@endo/eslint-plugin`:
`eslint-plugin-unicorn` is a runtime `dependencies` entry of that published
package, so the range bump is downstream-visible.

`endojs/endo-but-for-bots` is bot-owned, so **execute** the verdict: MERGE-NOW
conducts onto `llm` through the conductor spine
(`scripts/jobs/gardening/ci-wait-merge.sh`, maintainer-approval gate intact);
REJECT closes with the structured comment. Post the verdict comment on the PR
(covered by the repo's standing authorization) and remove PR #868's row from
the dependabotany ledger on a terminal verdict.
