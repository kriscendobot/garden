---
tier: mentat
dispatch: manual
---
Maintainer directive (2026-09-01, liaison session, dispatched as mentat/manual
per the maintainer's explicit tier choice — this is a proposal-authoring task,
not a routine automatic job).

## Background

The liaison ran two ad hoc evaluations this session, each testing whether a
fresh agent — armed with nothing but the `mcp__minion-town__*` MCP tool
descriptions/schemas as documentation, no prior domain knowledge — can
accomplish a genuinely non-trivial task against the live minion.town Endo-daemon
guest surface (`status`, `list`, `listSites`, `publish`, `upgrade`, `unpublish`,
`adopt`, `dismiss`, `resolve`, `send`, `listMessages`, `evaluate`, `writeText`,
`readText`, `has`, `remove`):

1. **Landed** — authenticate a Playwright-controlled browser to
   `https://minion.town/mcp` via Cognito's GitHub federation, for a headless
   MCP client whose OAuth callback doesn't match the registered redirect.
   Captured as `skills/minion-town-mcp-playwright-login/SKILL.md` (commit
   `36360f0ab5` on `main2`). Read it for the deployment facts and the general
   shape of what a good evaluation-derived skill looks like.
2. **In flight at the time this job was posted** — publish a brand-new clip
   (not an upgrade) whose page shows a visitor counter, centered, styled as a
   mechanical odometer, backed by genuine durable server-side state (not a
   client-only fake), verified by `curl` plus a Playwright script confirming
   the count actually increments across repeat loads. Its report was not yet
   available when this job was posted. **Check for it before you start**: it
   will most likely show up either as a further landed skill under `skills/`
   (git log on `main2` since this job was posted) or as a message in the
   liaison's/your inbox on `journal2`. If you truly cannot find any trace of
   it, proceed without it and note the gap in your proposal — do not invent
   its findings.

## Your task

Design and open a pull request against `kriscendobot/garden`, **based on the
`journal2` branch** (a frozen snapshot of `journal2` at your PR-open time, per
the mechanics in [frozen-base-branch](skills/frozen-base-branch/SKILL.md)
— reuse the pattern, not the literal main2 target it was written for). State
this explicitly in the PR body: a PR against `journal2` is a deliberate,
maintainer-directed departure from the garden's normal job-board flow (jobs are
normally posted by a direct CAS push straight into `jobs/todo/` or `jobs/plan/`
— see [job-board](skills/job-board/SKILL.md) — and CLAUDE.md even
says to ignore GitHub's unsolicited "create a PR for journal2" prompt after an
ordinary push). This one campaign gets a review gate because of its scope and
live-infrastructure cost: real MCP calls against a real Endo daemon guest,
real published clips, real spend, run at scale before anyone has reviewed the
plan.

The PR's diff is the concrete artifacts of the proposal, not prose about a
plan: actual planned job files.

1. **A comprehensive set of evaluation child jobs**, parked in `jobs/plan/`
   with `gate: orchestrated` (the shape `post-plan.sh --orchestrated
   --orchestrated-by <campaign-base> <child> [body]` would produce — construct
   the equivalent files directly since you're not pushing live). Cover the
   breadth of the tool surface, not just what's already been tried. At
   minimum, design distinct evaluations probing:
   - Static publish (a clip with no dynamic behavior) as a baseline/control.
   - Dynamic, durable, server-authoritative state in a published clip (the
     odometer counter is one instance of this shape; consider a second,
     differently-shaped one — e.g. a guestbook, a shared tally two different
     visitors both increment — to see if the finding generalizes).
   - `evaluate`'s sandboxing boundary: what capabilities are and are not
     reachable from evaluated source, and how clearly the tool's own
     description communicates that boundary to a fresh agent.
   - The ocap message-passing primitives as a *pair*, not a single guest
     talking to itself: `send`/`listMessages`/`adopt`/`resolve`/`dismiss`
     between two distinct guest identities exchanging a value or answering a
     request — this is the part of the surface neither prior evaluation
     touched at all.
   - `writeText`/`readText`/`has`/`remove` as a durability/persistence
     evaluation (does a value survive what it claims to survive; what does
     "clean 'no such name' result, not an error" actually look like in
     practice).
   - The `unpublish`/`upgrade` lifecycle, including deliberately hitting
     `upgrade`'s documented "not yet available when publishing is served
     live" case and evaluating whether that error is legible to a fresh
     agent.
   - Deliberate error/edge-case probes: a reserved `gateway/`/`.well-known/`
     content path, a `publish` naming a power the guest doesn't hold, a
     malformed request — evaluating error-message quality as documentation.

   Each child's body should mirror the shape of the two prior evaluations: a
   fresh, context-free brief; one concrete, non-trivial, checkable deliverable;
   a **required** verification method appropriate to that deliverable (curl
   and/or Playwright, or a direct second-guest MCP check for the message-
   passing scenario); and a required documentation-quality report section
   (what was clear from the tool schema alone, what needed trial and error,
   what a future skill should tell the next agent).

2. **One orchestration record** sequencing the children. The existing
   primitive ([orchestration](skills/orchestration/SKILL.md),
   `designs/orchestration-jobs.md`) is one-level: pure serial (one child at a
   time) or pure parallel (all at once) — it has no native "fan out, then
   converge on one final step" shape, which is what this campaign needs
   (the evaluations can likely run independently, but the review below must
   wait for ALL of them). Investigate `scripts/jobs/orchestrate.sh` and
   `scripts/jobs/common.sh`'s `blocked_on`/unblock-watcher mechanics directly
   before deciding: is there a supported way to block a job on an
   *orchestration record* reaching `done` (not just a plain job reaching
   `tada/`)? If yes, use it. If not, the reasonable fallback is two chained
   orchestration records (evaluations parallel in the first; the review+design
   step as the sole child of a second, posted `blocked_on` the last evaluation
   child or on the first orchestration's completion marker, whichever you find
   actually works) — or a single serial chain if you conclude the shared-guest
   state makes true parallelism unsafe anyway (a real question: do concurrent
   evaluation jobs share ONE Endo guest and its one pet-name directory, or does
   each `claude -p`/gardener invocation get an independently-provisioned guest?
   `status`'s own description — "the caller's own Endo daemon guest" — doesn't
   settle this for two *different* callers. Resolve this before choosing
   parallel; a naming collision between two evaluations racing to `publish`
   under guessed-similar pet names would confound the whole campaign's
   findings.) Document whichever choice you make and why in the PR body.

3. **The final converging step**: after every evaluation child completes, a
   job that reads all their `tada/` reports, synthesizes the documentation-
   quality findings across the whole set (what's clear, what's a genuine gap,
   what's a missing capability versus a documentation problem), and then
   authors a **design** proposing concrete improvements — better tool
   descriptions, missing capabilities, clearer error messages, whatever the
   evidence actually supports — aimed at `endojs/endo`, `kriscendobot/minion.town`,
   or both, whichever the findings implicate. That design should itself land
   as a normal PR against the target repo(s), per [designer](roles/designer/AGENT.md)
   and the garden's usual design-to-PR conventions — this campaign's own PR
   ends at *posting* that final job, not at writing the endo/minion.town design
   yourself.

## Constraints

- Do not push anything to the live `jobs/todo/` or `jobs/plan/` on `journal2`
  directly; everything lives on your PR's head branch until a human merges it.
- Keep each child basename short, descriptive, and — since none of this is a
  recurring verb against a fixed target — bare (no date suffix needed) per
  [job-board](skills/job-board/SKILL.md) § Basename shape.
- State your reasoning for parallel-vs-serial and for the fan-out-then-converge
  mechanism explicitly in the PR body; a reviewer needs to be able to check
  your engineering judgment, not just trust it.
- If, in the course of investigating the orchestration primitives or the
  guest-sharing question, you find the honest answer is "this campaign as
  envisioned needs a small primitive extension that doesn't exist yet" — say
  so plainly in the PR body as an open question rather than forcing a fit.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-01T19:28:40Z
