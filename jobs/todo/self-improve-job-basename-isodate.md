---
role: gardener
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Self-improvement: date-suffix job basenames for recurring actions, going forward

Repository: this repo (garden). Garden-infra work — edit and push directly to
`main2`, no PR (CLAUDE.md § Conventions: the garden does not open PRs against
itself).

## What happened (the grounding incident)

While hand-posting an 11-child orchestration
(`endojs-endo-but-for-bots-gateway-phase-restack-chain`, 2026-08-17), a fresh
child basename `endojs-endo-but-for-bots-pr395-weave` silently collided with
an **unrelated, already-completed** job of that exact basename — an earlier
restack of PR #395 done against a since-superseded base. `post-plan.sh`
correctly treated it as "already present in lifecycle; nothing to do" (that
is its documented, correct idempotency behavior — see
[job-board](../skills/job-board/SKILL.md) § Post/Park), but the practical
effect was that **the intended new child was never parked**, which would have
broken the orchestration at that step if it had gone unnoticed. It was caught
only by manually reading the loop's log output line by line. This is one
vivid incident, not (yet) a pattern across independent engagements — weigh
the self-improvement skill's own threshold guidance
([self-improvement](../skills/self-improvement/SKILL.md) § Threshold for
landing a change) accordingly: a documentation/convention fix and a targeted
audit are clearly warranted; a broad mechanical rule change should not be
over-fit to a single incident.

## The ask

**Job basenames for recurring, repeatable actions should carry an ISO date
suffix going forward**, so re-running the same nominal action against the
same target later in time gets a distinct basename instead of colliding with
(and being silently swallowed by) an old one. This already happens
inconsistently in practice — e.g. `pr403-weave-20260813`,
`endojs-endo-but-for-bots-pr388-review-04154a91` (id-suffixed) — but it is
not a documented, consistently-applied convention.

**Scope this to the right category of basename, do not blanket-apply it.**
Basename idempotency ("re-post the same ask, get a no-op instead of a
duplicate") is a deliberately documented feature for a **stable, one-shot
unit of work** — a `design-X`, `build-X`, a specific fix — per CLAUDE.md § How
work reaches workers: "[a deterministic basename so] a re-issued ask is
idempotent." Date-suffixing those would break that property for no benefit.
The actual risk is narrower: **verbs that legitimately recur against the same
target over time** — `weave`, `shepherd`, `conduct`, a restack, a `retcon`, a
review-feedback response, an "attention directive" routing job — where
today's invocation and last month's invocation are genuinely different work
even though the nominal target (a PR number) is the same. Those are the
basenames that need a disambiguator; audit for and fix these:

1. **Document the convention explicitly**: [job-board](../skills/job-board/SKILL.md)
   § Post/Park (basename discussion already lives there) and CLAUDE.md § How
   work reaches workers (the "derive a short deterministic basename" guidance)
   should state the split plainly: stable one-shot asks stay bare;
   recurring-verb asks (name them) get an ISO-date (`YYYYMMDD`, matching the
   existing `-20260813`-style examples already in use) or other disambiguator
   suffix. Update any role file that documents its own basename convention
   (`roles/weaver/AGENT.md`, `roles/shepherd/AGENT.md`,
   `roles/conductor/AGENT.md`, and others as found) to match.
2. **Audit the deterministic minting scripts** — `scripts/jobs/comment-watcher.sh`
   (the branch-op/pipeline-verb job-minting paths, e.g. `weave`/`shepherd`/
   `conduct`/`retcon`/attention-directive basenames) and anything under
   `scripts/jobs/gardening/` that mints a job for a recurring action — and add
   a date suffix wherever one is missing today. Don't assume; grep for the
   actual basename-construction sites and check each one's shape.
3. **Consider (open question, do not treat as mandatory)** whether
   `post-job.sh`/`post-plan.sh` should surface a same-basename collision
   against a **much older** completed (`tada/`) job more loudly than the
   current one-line log message — that visibility gap is what let today's
   collision almost go unnoticed inside a scripted loop. If pursued, this is
   a UX/safety improvement to the posting scripts themselves, separate from
   the basename-convention documentation change above; scope and land
   independently if it turns out to be more than a one-line change.

## Acceptance

- The convention is stated once, clearly, in `job-board` (canonical) and
  cross-linked from CLAUDE.md and any role file that duplicated basename
  guidance — not restated inconsistently in multiple places.
- Every deterministic job-minting call site for a recurring verb either
  already includes a disambiguator or is fixed to include one, with the
  specific sites named in the completion report.
- `scripts/jobs/test/` (or the relevant existing test suite covering
  `post-job.sh`/`post-plan.sh`/`comment-watcher.sh` basename construction)
  still passes; add a test for the fixed call sites if none already covers
  basename shape.
- Report what changed and cite this incident's orchestration
  (`endojs-endo-but-for-bots-gateway-phase-restack-chain`) as the grounding
  example in the commit/report per house style (name the artifact, don't
  just assert the lesson).

<!-- garden-reaped: 2 -->
