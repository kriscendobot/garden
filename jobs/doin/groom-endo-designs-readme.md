---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Groom designs/README.md: verify, reorganize, archive, and illuminate the estimate/reality gap

Repository: endojs/endo-but-for-bots, directory `designs/`, branch `llm`.
Land as a draft PR against `llm` (designer convention) — that PR's review
thread is deliberately the interactive surface for reorganizing the
milestones; do not treat this job as needing a synchronous conversation to
"finish" the reorganization, get a strong first draft into review.

**Read `designs/AGENTS.md` first and in full** — this project's actual design
conventions (metadata table, status values, the cross-document
Progress-Tracking contract that already requires `designs/README.md` to stay
synced with every design's status). You will also be **amending** this file
(see Archiving, below), so read it as both instructions and an edit target.

## 1. Verify actual status (subagents welcome)

`designs/README.md`'s summary table, milestone tables, and roadmap graph
almost certainly drift from reality — designs get merged, abandoned, or
revised without every downstream row being updated. For every design entry
and milestone-table row:

- Cross-check its claimed **Status** (Not Started / Proposed / In Progress /
  Complete / etc., per `AGENTS.md`'s Status Values table) against the real
  PR/merge state on GitHub, and against the individual design doc's own
  metadata table (the two must agree — if they don't, `AGENTS.md`'s sync rule
  says the README should reflect current reality, but note any case where the
  *design doc itself* is stale too, as a candidate follow-up rather than
  silently rewriting a doc you weren't asked to revise).
- This is a large fan-out (dozens to low hundreds of entries). **Use
  subagents (the `Agent` tool) to parallelize verification** — e.g. one
  subagent per milestone bucket, each returning a compact table of
  `design -> claimed status -> verified status -> evidence (PR#/commit/date)`.
  You are not scoped read-only like a librarian job; you may use `gh`/`git`
  directly or through subagents as fits.
- Where a design's actual landing includes a real merge date, record it —
  you need this for §3 below.

## 2. Reorganize the milestones for landing-order clarity

The milestone ordering has accumulated multiple renumbering passes and
ad-hoc insertions (visible in the changelog you're about to relocate — read
it for context before moving it). Reorganize so the milestone list reads, in
order, as **the order we can actually expect things to land** — not the
order they were originally conceived. Where a milestone's own stated
dependency ordering (`AGENTS.md`/README invariant: "each milestone's
dependencies all live in earlier milestones") conflicts with realistic
landing order, that conflict is exactly the kind of thing to surface, not
paper over — note it in the PR description or an inline comment rather than
silently resequencing past a real dependency.

## 3. Factor in token budget, cost, and time — grounded in real velocity

Don't project landing order or timing from wishful estimates. Ground it in
observed evidence:

- Recent job cost/wall-clock data lives in `jobs/tada/*.md` usage stamps
  (`## Cost` sections: engagements, tokens, cost, wall-clock) in the garden's
  own journal (**not** this repo — you'll need the garden's journal state
  passed in or fetched separately from your project worktree; ask for it via
  a librarian job or message the liaison if you can't reach it from your
  sandbox).
- The garden recently landed live budget/token-bucket admission
  (`designs/live-budget-admission.md`, `designs/budgeted-campaign-dispatch.md`
  on the garden's own repo, not this one) — factor its existence into
  realistic throughput assumptions (campaigns are now bounded by token
  budget at dispatch, which changes how fast a backlog actually drains).
- Where the existing "Size and Time Estimates" / calibration-round sections
  already track estimate-vs-actual, extend that discipline rather than
  replacing it wholesale.
- Prefer **confidence tiers over invented calendar dates** where a hard date
  isn't defensible (e.g. "likely next," "in progress, timing uncertain,"
  "blocked on X") — a false-precision date that misses is worse than an
  honest tier.

## 4. Illuminate the discrepancies (this is the point, not a footnote)

Two distinct gaps to make visible, not just fix silently:

- **Planned milestone vs. actual landing.** Where a design was assigned to
  milestone N but actually landed while M-earlier-or-later work was still in
  flight (or landed long after its milestone's other members), show that —
  a table or a Mermaid diagram (this doc already uses Mermaid for its
  dependency graph; extend that convention rather than inventing a new
  diagram style) that plots planned-milestone vs. actual-landed-cycle is
  more useful here than prose.
- **Delivery-date estimates vs. real dates.** The existing "Size and Time
  Estimates" / calibration-round sections record estimates; where a design's
  actual landing date is now known (from §1), compare it against its
  estimate and surface the pattern (e.g. "estimates in milestone N
  undershot actual by a consistent margin") — this is calibration data the
  next estimate should use, not just a retrospective curiosity.

## 5. Move the changelog to the bottom

The `*Layered on <date>: ...*` chain of italic paragraphs currently sits
between the title and the `## Summary` table (roughly the first ~140 lines).
**Relocate it to the bottom of `designs/README.md`** as its own section
(e.g. `## Changelog`), reverse-chronological as it is today. Do not rewrite
individual entries — they're an append-only record of prior grooming passes;
moving them is a cut-and-paste, not a rewrite. Add your own dated entry to
the top of that relocated log (matching its existing format) describing this
grooming pass.

## 6. Archive Milestone 1 to designs/ARCHIVE.md, and update the standing convention

Milestone 1 ("Downloadable AI Agent Experience") is entirely `~~Complete~~`
and closed since March. Move it out of `designs/README.md` into a new
`designs/ARCHIVE.md` (create it) rather than just relocating it within the
same file — the goal is to actually shrink the working document, not just
reshuffle it.

- `ARCHIVE.md` should carry enough context to stand alone (the milestone's
  goal, its design table, exit criterion, actual duration — everything
  currently in the M1 section) plus a one-line pointer back from
  `designs/README.md` where M1 used to be.
- **This must become a durable rule, not a one-off**: add a section to
  `designs/AGENTS.md` (the file you read in step 1) documenting the
  archive convention — when a milestone qualifies (every design in it is
  `Complete`/`Implemented` and its exit criterion is met), where it goes
  (`designs/ARCHIVE.md`), and what stays behind (the one-line pointer). This
  is what makes the NEXT grooming pass (and every future designer job that
  touches this README) aware of the convention without being told by hand
  again.
- **Do not silently archive anything beyond Milestone 1.** While verifying
  (§1) you may find other early milestones (Milestone 2 looks like a
  candidate from the changelog) that are similarly fully complete — flag
  those explicitly in the PR description as archive candidates for a
  follow-up or for this same PR's review discussion, rather than archiving
  them unasked or leaving the finding unsaid.

## Scope guard

This job's target is `designs/README.md` (plus the new `ARCHIVE.md` and the
`AGENTS.md` convention update). If verification turns up individual design
docs whose own metadata is stale, **do not fix them in this job** — list them
in the PR description as a follow-up and, if the list is long, post a
follow-on job naming exactly what's left, per the usual "silent truncation is
a defect" discipline. If the grooming pass itself runs long, the same rule
applies to the pass itself: complete what you can to a coherent, mergeable
state and post a follow-on `groom-endo-designs-readme` job naming the
remainder, rather than leaving the document in a half-reorganized state.

`handler-timeout: 10800` (this job fans out verification across many entries
and may run long; budget accordingly rather than getting SIGTERM'd mid-pass).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T21:16:03Z
