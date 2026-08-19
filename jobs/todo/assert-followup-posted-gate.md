---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gate job completion on posted follow-ups, not described ones

Repository: this repo (garden). Garden-infra work — edit and push directly to
`main2`, no PR (CLAUDE.md § Conventions).

## The grounding incidents (two, same day)

`endojs-endo-but-for-bots-pr910-shepherd` completed with: "The maintainer's
most recent comment on the PR is 'Conduct.' — a merge directive. That is a
conductor job... not this shepherd's scope" — and settled without posting
one. The already-parked orchestrated conductor child sat unpromoted for 5
days until a human noticed. `endojs-endo-but-for-bots-pr876-rebase` completed
with: "a fresh shepherd... and then conduct... are warranted now" — and
settled without posting either. Both reports used bold-prose headers
("**Follow-up:**" / "**Follow-ups (outside this job's rebase scope):**"),
not the canonical `## Follow-ups` heading, so even the async
`garden-follow-up` sweep (~10m cadence, scans `jobs/tada/*.md` for that exact
heading) silently missed them — a second, independent gap on top of the
first.

**The maintainer's standing requirement, stated directly: any follow-up job
must be POSTED before a task settles, never merely described.** A 10-minutes-
later async sweep is not "before it settles" — it's a backstop for the
genuinely-not-board-postable case (a maintainer-judgment call routed to the
inbox), not the primary mechanism.

## What already exists (build on it, don't replace it)

`complete-job.sh --handed-off BASE` (`skills/job-board/SKILL.md` §
Complete) already does the hard part correctly: it **verifies the named
successor job or orchestration actually exists** before stamping
`handed-off: BASE` + `deliverable-complete: false` into the completion
frontmatter, and refuses otherwise. This is the right tool, already built,
already correct. The gap is that using it is **optional** — nothing requires
a worker whose report implies unfinished chained work to actually call it.

## The fix — two parts

1. **Standardize the heading, fleet-wide.** Add a house-style rule (
   `roles/COMMON.md`, alongside the other style rules — em-dash, no-Latin-
   shorthand, etc.) that a report describing further necessary action uses
   the literal `## Follow-ups` (or `## Follow-up`) markdown heading, not a
   bold-prose variant. This alone fixes the async sweep's silent-miss gap
   and gives the new gate below a reliable anchor.

2. **A deterministic, no-LLM completion-time gate, structurally mirroring
   `scripts/jobs/assert-design-pr-gauntlet.sh`** (read it first — same
   shape: called from `scripts/jobs/gardener.sh` right before a job may be
   recorded complete, refuses completion when its check fails, forcing a
   correction rather than a silent miss). New script (name it to match the
   pattern, e.g. `assert-followup-posted.sh`):
   - Scan the completion report for a `## Follow-ups` / `## Follow-up`
     heading (per the standardized convention above).
   - If absent, or present but trivially empty ("none" / "nothing this
     time" — matching the existing self-improvement skill's own null-signal
     convention, `skills/self-improvement/SKILL.md`), the gate is a no-op —
     most jobs are unaffected.
   - If present and substantive, require the completion frontmatter to
     carry `handed-off:` naming a real board artifact (reuse
     `complete-job.sh`'s own existence check, don't reimplement it) **OR**
     an explicit, checkable alternative disposition for the legitimate
     non-board-postable case (a maintainer-inbox message actually sent —
     name a verifiable field/marker for this; do not accept a bare prose
     claim). If neither is present, **refuse completion** — same shape as
     the gauntlet gate: the job stays in `doin/`, forcing the worker to
     either finish the follow-up itself, post it and re-report with
     `--handed-off`, or route it to the inbox with the checkable marker.
   - **Include a safety valve** so a false-positive detection (a report
     that mentions "follow-up" in passing, not as an unfinished-work
     signal) can't wedge a job forever — an explicit override field the
     worker can set with a one-line reason, checked the same deliberate way
     `orchestration-failed`/`deliverable-complete` are already explicit,
     named fields rather than free text.

## Acceptance

- A regression test posting a completion report with a substantive
  `## Follow-ups` section and no `handed-off:`/inbox marker, asserting
  completion is refused; and the inverse (with a valid `handed-off:` naming
  a real board artifact), asserting it succeeds. Cover the trivial-empty
  case (no gate) too.
- `roles/COMMON.md` carries the new heading-convention rule, cross-linked
  from wherever the existing style rules are indexed.
- Report cites both grounding incidents (`endojs-endo-but-for-bots-pr910-shepherd`,
  `endojs-endo-but-for-bots-pr876-rebase`) as the motivating examples.

If the detection heuristic (what counts as "substantive," what counts as a
valid non-board-postable disposition) turns out to be a genuine judgment
call rather than mechanical extension of the existing gauntlet-gate pattern,
say so explicitly and hand off to a design job naming exactly the fork,
rather than force a decision — but the existing `--handed-off` verification
and the gauntlet-gate precedent cover most of the hard part already.
