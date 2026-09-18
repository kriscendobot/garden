---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Comprehensive survey of all open PRs under the garden's care

Maintainer directive (kriskowal, 2026-09-18). Produce one report covering
**every open pull request the garden is actively caring for** — discover this
set rather than assuming it; walk `journal/comment-repos/`, `journal/
config/fork-owners`, and the repos with recent job/PR activity (grep job
basenames and `journal/pr-review-sequence.md`) to find the real set, likely
centered on `endojs/endo-but-for-bots` plus the active `kriscendobot/*` forks
(minion.town, garden, agoric-sdk, proposal-compartments, test262, and any
others with a currently-open garden-authored or garden-managed PR). Don't
survey a fork that merely exists with no open PR.

## For each PR

A **short paragraph** on its status: what it does, where it stands (draft /
in review / CI state / panel round if applicable / blocked and on what),
and anything time-sensitive. Read the PR itself, not just its title — a
one-line guess is not a status account.

## Structure

1. **Grouped by relevant subsystem.** Use judgment informed by the existing
   review-arc taxonomy (`journal/pr-review-sequence.md`, the arc→press
   mapping already tracked in `journal/schedules/arc-status-daily.md` and
   the `kriskowal/garden` tracker issues #47-56, #61) as a starting
   vocabulary — SturdyRef, byte arrays, OCapN/Noise, daemon data plane,
   Endor/xs2rust (ironhorse), git integration, VFS parity, npm-CAS registry,
   Compartments proposal, finbot, minion.town, garden-infra itself, etc. —
   but don't force a PR into a bad-fit bucket; add a bucket if the existing
   taxonomy doesn't cover it.
2. **Cross-referenced by milestone.** `designs/README.md` on
   `endojs/endo-but-for-bots`'s `llm` branch is the live ranked roadmap
   (Milestones M1-M11, per [[endo-designs-readme-roadmap]] if you have that
   context, else just read the file) — note which milestone(s) each PR
   serves, where determinable.
3. **Ordering: most urgent first, overall**, but **within any dependency
   chain, place the DEPENDENT before its dependencies** (the PR that needs
   something goes first in the listing, its prerequisite(s) follow after
   it) — the maintainer was explicit about this ordering being
   dependent-then-dependency, not the reverse. Reuse the existing
   `pr-dependency-graph`/`pr-dependency-topo-sort` skills
   (`skills/pr-dependency-graph/SKILL.md`,
   `skills/pr-dependency-topo-sort/SKILL.md`) for the actual dependency
   registry read and ordering primitive rather than hand-rolling it.
   Beyond strict dependency chains, order the overall list in roughly
   **chronologically-addressable** order — the sequence a reviewer could
   realistically work through, given what's actually ready now vs. blocked
   on something else landing first.
   "Most urgent" is your judgment call — weigh signals like: age/staleness,
   CI red, a maintainer directly waiting on it, whether it's blocking other
   open PRs, review-round count already spent. State briefly, per PR or per
   group, WHY it's placed where it is when the reasoning isn't obvious from
   the status paragraph alone.

## Output

Write the finished report as a **single, well-organized Markdown file**,
landed in the journal at `reports/open-pr-survey-<yyyy-mm-dd>.md` (follow
whatever the existing `reports/` directory's convention is — read the one
existing file there, `reports/monthly-progress-*.md`, for landing
mechanics if it uses a specific lander script rather than a direct commit).
**Do not attempt to publish a Claude Artifact yourself** — that capability
is not confirmed available in this execution environment; the liaison will
take your finished Markdown and publish the polished artifact/dashboard
separately. Your deliverable is the complete, accurate, well-structured
CONTENT — headers, grouping, milestone tags, ordering, and per-PR
paragraphs — ready to be turned into a page without further research.

Report the landed path/commit in your completion.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-18T21:52:41Z
