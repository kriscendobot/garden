---
created: 2026-05-15
updated: 2026-06-24
author: gardener
---

# Skill: design-dependency-walk

Walk a chosen design's dependency chain to find an actionable starting point.
Given a candidate design that may depend on other unfinished designs (and those on
yet more), return one of four verdicts: build this design directly, stack on its
in-flight PRs, build a deeper dep first, or no candidate in the chain is
actionable. In v2 this is the **preparation step** of a `design` or `build` job: a
gardener (or the poller that posts the job) runs the walk to convert "the
maintainer named this design" into "this is the next concrete unit of work" before
the build proper begins.

Composes with [design-to-pr-pipeline](../design-to-pr-pipeline/SKILL.md) (which
produces the candidate set) and [design-queue-drift-check] (which filters the
set's eligibility). This skill is the **chain-walker**: given one candidate that
has passed the prior two filters, follow its declared dependencies until a verdict
lands.

## When to use

- A poller is refilling the design-PR-drafting cap and has picked one design from
  the eligible set. Before posting (or claiming) a `build` job, run the walk to
  confirm the design is actually buildable now or to redirect to a deeper dep.
- A liaison in-session wants to answer the user's "what's blocking this design from
  starting" question. The walk's verdict is the answer.
- A gardener that claimed a `build` job whose design has unmet deps runs the walk
  to decide whether to redirect.

## Inputs

- `seed_design_path`: the design document to start from (e.g., `designs/timer.md`,
  `packages/runtime/designs/proactive-messages.md`).
- `roadmap_branch`: today `llm` on `endojs/endo-but-for-bots`. Where designs live.
- `impl_base_branch`: today `master` on the same repo. Where implementations land.
- `in_flight_designs`: the set of `design_path` values already being built — read
  from the job board (`jobs/todo/` + `jobs/doin/` design/build jobs) — so the walk
  does not redirect to a design another job is already building.

## State

None. The walk is a pure read against the roadmap branch, the open / merged PR
list, and the job board.

## Verdict shape

The walk returns one of four verdicts:

- **start-here**: the seed design (or, after walking, some ancestor design the
  walk redirected to) is actionable. All of its declared dependencies are either
  merged (a closed PR with the implementation) or have no implementation surface (a
  pure-design dep whose own implementation already shipped under the same chain).
  The caller posts/claims a `build` job against this design directly.
- **stack-on-PRs**: the seed (or walked ancestor) depends on N open implementation
  PRs. The build's base branch is the merge of `<impl_base_branch>` and those N PR
  heads, per [stacked-pr-build](../stacked-pr-build/SKILL.md). The verdict names
  the open PR numbers and head
  SHAs so the caller can pin the stack.
- **start-with-dep**: the walk reached a dependency that has neither a started
  design nor an open PR. The caller posts/claims a `build` job against the dep
  instead (and the seed design re-enters the queue for a future cadence once the
  dep ships).
- **no-actionable-design**: every node in the walk is blocked (cycle in the dep
  graph, blocked-on-maintainer-decision dep, or every candidate's deps are
  themselves blocked). The caller leaves the slot empty this cadence and records
  the reason in the `progress` entry.

The verdict's payload is a small structured record:

```yaml
verdict: start-here | stack-on-PRs | start-with-dep | no-actionable-design
design_path: <path>                   # the design the caller should build
stack_prs:                            # populated only for stack-on-PRs
  - { number: <int>, head_sha: <sha>, design_path: <path> }
walked_chain:                         # the chain from seed to verdict-design
  - <path>
  - <path>
note: <one-line summary>              # human-readable verdict explanation
```

## Procedure

The walk is a recursive DFS over the design's declared `## Dependencies` (or
`## Depends On`) sections, with explicit cycle detection and a per-node
classification step.

### 1. Parse the seed design's dependencies

Read the seed design document from the roadmap branch:

```sh
gh api repos/<owner>/<name>/contents/<seed_design_path>?ref=<roadmap_branch> \
  --jq '.content' | base64 -d > "$GARDEN_STATE/walk/<slug>.md"
```

Find the `## Dependencies` (or `## Depends On`) section. Each bullet should name
another design by its path; tolerate slug-only mentions but prefer the explicit
path. Build `deps = [<dep-design-path>, ...]`.

A design with no `## Dependencies` section has `deps = []`; it is actionable by
definition (subject to the eligibility filter the caller has already run). Return
`{verdict: start-here, design_path: <seed>, walked_chain: [<seed>]}`.

### 2. Classify each dependency

For each `dep` in `deps`, determine its state. The states are mutually exclusive
and ordered by priority (the first matching state wins):

a. **dep-merged**: a closed-and-merged PR cross-references the dep's design path
   per [design-to-pr-pipeline](../design-to-pr-pipeline/SKILL.md) § What counts as
   covered. The dep's implementation has shipped; this dep is satisfied.

b. **dep-in-flight-PR**: an open PR (draft or ready-for-review, garden-authored)
   cross-references the dep's design path. The dep has an actionable head SHA the
   caller can stack on. Record the PR number and head SHA.

c. **dep-unstarted-design**: the dep's design document exists on the roadmap
   branch but no open or merged PR cross-references it. The dep is unstarted; the
   walk must recurse into it.

d. **dep-no-design**: the dep's design document does not exist on the roadmap
   branch. Surface as a registry bug via the message bus (to the maintainer);
   treat as `no-actionable-design` for the slot.

The classification uses two `gh` calls per dep:

```sh
SLUG=$(basename <dep-design-path> .md)
gh pr list -R <owner>/<repo> --state all --search "$SLUG" \
  --json number,state,title,body,headRefName,headRefOid \
  --limit 20
gh api repos/<owner>/<name>/contents/<dep-design-path>?ref=<roadmap_branch> \
  --silent 2>/dev/null || echo "MISSING"
```

### 3. Aggregate the verdict per the dep states

After classifying every `dep` in `deps`:

- **All deps are `dep-merged`**: verdict is `start-here` with
  `design_path = <seed>`.
- **Some deps are `dep-in-flight-PR`, the rest are `dep-merged`**: verdict is
  `stack-on-PRs` with `design_path = <seed>` and `stack_prs` populated from the
  in-flight-PR deps.
- **Any dep is `dep-unstarted-design`**: recurse into that dep (step 4). The
  recursion's verdict becomes the walk's verdict for the seed.
- **Any dep is `dep-no-design`**: send a bus message naming the dangling
  reference. The seed is `no-actionable-design`.

If a seed has mixed `dep-in-flight-PR` and `dep-unstarted-design` deps, the
unstarted dep is the immediate blocker; recurse into it first. The seed can still
resolve to `stack-on-PRs` later, but not in the same walk turn; the unstarted dep
needs to ship first.

### 4. Recurse into an unstarted dep

For each `dep-unstarted-design` dep:

a. **Cycle detection.** Maintain a `walked_chain = [<seed-path>, ...]` set across
   the recursion. If `dep` is already in `walked_chain`, the dependency graph has a
   cycle. Send a bus message naming the cycle members; return
   `no-actionable-design` for the seed.

b. **In-flight avoidance.** If `dep` is in the caller's `in_flight_designs`,
   another job is already building it. Returning `start-with-dep` pointing at `dep`
   is **wrong** here (it would start a second build against a design another job
   owns). Instead, return `stack-on-PRs` with the other job's pending PR (or, if
   the other job is mid-build and has no PR yet, the recursion returns "wait" and
   the caller leaves this slot empty this cadence; record the reason).

   The job board is the source of truth for *which design is being built right
   now*. The walk consults it; the caller's `in_flight_designs` input is the board
   snapshot at scan start.

c. **Recurse.** Run the walk on `dep` with `walked_chain += [dep]`. The
   recursion's verdict tells you what to do next:
   - `start-here` for `dep`: the seed's verdict becomes `start-with-dep` with
     `design_path = dep`. The slot builds the dep first; the seed re-enters the
     queue.
   - `stack-on-PRs` for `dep`: the seed's verdict is **still** `start-with-dep`
     with `design_path = dep` (the slot builds the dep first as a stacked PR; the
     seed waits for the dep's PR to merge or for a future cadence to stack on it).
   - `start-with-dep` for `dep`'s own unstarted dep: the seed propagates that
     decision (the slot builds the deepest dep first).
   - `no-actionable-design`: the seed's verdict is `no-actionable-design`. The walk
     reached an impasse along this branch.

   If the seed has multiple `dep-unstarted-design` deps and the first recursion
   returns `no-actionable-design`, try the next; only return `no-actionable-design`
   for the seed if every unstarted dep is itself unactionable. Order the dep walks
   by the dep's last-modified date on the roadmap branch (newest first); ties by
   path lexicographic order, for determinism.

### 5. Return the verdict

The caller reads the verdict and proceeds:

- `start-here`: post/claim a `build` job against `design_path` with
  `impl_base_branch` as the base.
- `stack-on-PRs`: post/claim a `build` job with the stacked base per
  [stacked-pr-build](../stacked-pr-build/SKILL.md), naming the `stack_prs` PR
  numbers and head SHAs.
- `start-with-dep`: post/claim a `build` job against the dep's `design_path` (which
  the walk redirected to); the seed re-enters the queue.
- `no-actionable-design`: the slot stays empty; the cadence records the reason in a
  `progress` entry.

The verdict's `walked_chain` is written into the `progress` entry so the next
cadence's reader (or a future maintainer audit) can see the dependency path the
walk traversed.

## Pitfalls

- **Slug-only dep references.** A design that names its deps as slugs ("depends on
  timer") rather than paths is ambiguous when multiple designs share a slug. Resolve
  by checking the design's package directory; if ambiguous, send a bus message and
  treat the dep as `dep-no-design`. The right long-term fix is the designer
  tightening the dep reference; the walk should not guess.
- **Closed-not-merged PRs.** A PR that cross-references a dep but is
  closed-without-merge is **not** evidence the dep shipped. Treat it the same as no
  PR: the dep is `dep-unstarted-design` unless a different open or merged PR also
  references it.
- **A dep with a stale PR.** An open PR untouched in weeks may be effectively
  abandoned, but still counts as `dep-in-flight-PR` for the walk. Stale-PR adoption
  is separate logic (a triager/poller may post an adopt job for a stale PR); the
  walk's classification is purely structural.
- **A dep on a different upstream repo.** The walk assumes the seed and its deps
  live on the same `<owner>/<name>` repo. Cross-repo dep references are not
  supported by this version; surface as a registry bug via the bus and treat as
  `dep-no-design`. A future revision may extend the walk to cross-repo if the
  maintainer asks.
- **Cycle in the design dep graph.** Real but rare. The cycle-detection rule above
  catches it; the resulting bus message names every chain member so the maintainer
  can pick which edge to break.

## Notes from the field

- _2026-05-15_: skill landed as part of the general-contractor carving. The walk's
  four-verdict shape matches the contractor's *Refill* step's branches.
- _2026-06-24_: migrated into v2. The general-contractor is retired; the walk is
  now the preparation step of a `design`/`build` job. Replaced the
  `active_slot_designs` (contractor in-memory slot table) input with
  `in_flight_designs` read from the job board; replaced the `message → liaison`
  registry-bug channel with the message bus; replaced the contractor *Refill*-step
  caller with the poller/gardener that posts or claims the `build` job. The walk
  logic itself is unchanged.
