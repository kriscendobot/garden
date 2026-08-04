# Design: the staged gauntlet — a PR walked one claim-sized stage at a time

## The problem: the gauntlet does not fit one handler

The gauntlet ([pr-creation-flow](../skills/pr-creation-flow/SKILL.md)) is
**clean → panel review → fix-loop → un-draft**. Today it runs as a **single
claimed job** — the `<build>-gauntlet` job `auto-gauntlet-handoff.sh` posts on a
build's completion edge, or a `run the gauntlet #N` job the comment-watcher posts —
handled by one `claude -p` gardener that supervises the *whole* chain inside one
handler invocation. Its wall-clock is the **sum** of every stage plus every
fix-loop iteration plus every CI wait. That sum does not fit any handler budget,
for two structural reasons:

1. **The fix-loop is unbounded.** Panel findings produce fixes, which require a
   re-panel, an unknown number of times. `panel.sh` already loops internally up to
   `GARDEN_PANEL_MAX_ROUNDS=8`, running the full seat panel *each* round with a
   fixer between rounds. A handler must budget for the worst case of a loop whose
   length it cannot know in advance.
2. **CI waits are unbounded.** `ci-wait-merge.sh` polls GitHub CI, which can take
   tens of minutes per push, several times over a run.

On 2026-07-28 nine jobs doomed on `deadline-overrun`. The decisive one —
`endo-sturdyref-agent-surface-build-gauntlet` — declared `handler-timeout: 14000`
and doomed anyway.

### Why raising the budget cannot be the answer

`reaper.sh` documents the invariant that makes a stale claim safe to reap:

```
GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL   (default 14400)
```

A handler budget of 14000s is already pressed against the ceiling; there is no
headroom without also raising `GARDEN_CLAIM_TTL`, and raising *that* degrades the
reaper's ability to recover genuinely dead claims (the failure that stranded 62
jobs on a broken host the same day). The reaper also dooms a deadline overrun
after **one** cycle, not the usual five (`GARDEN_REAP_OVERRUN_THRESHOLD=1`),
precisely because a job that exceeds its budget "would be killed identically on
every requeue." **The budget ladder is exhausted. Splitting is the only remaining
move.**

## The shape of the fix: stages that each fit 2400s, a driver that sequences them

Decompose the gauntlet into **claim-sized stage jobs**, each a normal, independently
claimable job with its own fresh default `GARDEN_HANDLER_TIMEOUT` (2400s) budget and
its own per-base worktree. A **deterministic, no-LLM driver** advances a PR one stage
per claim, re-arming until the PR un-drafts. No single handler ever spans the loop.

The stages:

| Stage base | Work | Bounded because |
| --- | --- | --- |
| `<g>-clean` | coverage pass, dead-code removal, watch CI converge | one coverage pass on the touched packages; CI-wait is its own bounded poll (below) |
| `<g>-panel-<k>` | run **one** panel round: fan the seats, aggregate, decide `pass`/`must-fix`, post the verdict as a `gh pr review` | one round of `panel.sh` in single-round mode: 28 seats at concurrency 8 ≈ 4 waves ≈ 15 min |
| `<g>-fix-<k>` | apply the must-fix items from the latest panel verdict, push follow-ups, watch CI green | one fixer pass on a known finding list |
| `<g>-undraft` | appellate pass (advisory), then `gh pr ready` | a single API call plus one advisory `claude -p` |

`<g>` is the **gauntlet base**, derived deterministically from the PR (e.g.
`<owner>-<repo>-pr<N>-gauntlet`), so a re-triggered gauntlet on the same PR reuses
the same record and stage bases (idempotent).

### The driver: a per-PR analog of `orchestrate.sh`

The garden already sequences multi-part work with a **deterministic leader-only
watcher over a record outside the claim lifecycle** — `orchestrate.sh` over
`jobs/orch/`, `unblock.sh` over `blocked_on` edges. The staged gauntlet adds one
more of exactly this shape:

- **Record:** `jobs/gauntlet/<g>.md` (a new category alongside `jobs/orch/`,
  outside the claim lifecycle — never claimed, never reaped). Frontmatter:

  ```
  ---
  pr: https://github.com/<owner>/<repo>/pull/<N>
  repo: <owner>/<repo>
  pr_number: <N>
  build_job: <build-base>            # provenance; empty for a `run the gauntlet` origin
  kind: feature | probe              # a probe NEVER un-drafts
  stage: clean | panel | fix | undraft | done | halted
  iteration: <k>                     # the panel/fix loop counter
  max_iterations: 6                  # give-up bound for the loop
  resumes: <n>                       # still-pending re-posts spent on the current stage
  max_resumes: 6                     # give-up bound for the still-pending re-post
  current_child: <stage-job-base>    # the stage job currently in flight
  state: pending | running | done | halted
  created_by: <role>
  created_at: <iso8601>
  ---
  <human description + provenance>
  ```

- **Watcher:** `gauntlet.sh`, the leader-only `garden-gauntlet` timer (~3m cadence,
  **no `claude -p`**), advancing every active record ONE step per tick against the
  board and the live PR:

  1. Read `current_child`'s board state: `done` (in `jobs/tada/`), `active` (in
     `todo/`/`doin/`), or `failed` (in NONE — promoted but vanished without a
     `tada/` report: the reaper doomed it, or its report carries
     `orchestration-failed: true`). This is byte-for-byte the state read
     `orchestrate.sh` already performs.
  2. `active` → wait (do nothing this tick).
  3. `failed` → **halt**: set `state: halted`, sweep nothing (there is no fan-out),
     surface to the maintainer inbox. A stranded PR mid-gauntlet halts loudly; it
     never silently stalls.
  4. `done` → read the child's `tada/` report for its **stage-result marker** and
     compute the next stage (below), post/promote it, update the record, CAS-push.

### The stage-result marker: how a stage tells the driver what happened

Each stage report ends with a deterministic marker the driver greps (no LLM in the
driver):

```
<!-- gauntlet-stage-result: <stage>=<result> -->
```

- `clean=done`
- `panel=pass` | `panel=must-fix`
- `fix=done`
- `undraft=done`

The transition table the driver applies:

| completed stage | result | next |
| --- | --- | --- |
| clean | done | `panel-1` |
| clean / fix-k | still-pending | re-post the SAME stage; if it has already spent `max_resumes` re-posts → **halt** ("CI never reached a terminal state") |
| panel-k | pass | `undraft` (feature) / `done` (probe) |
| panel-k | must-fix | `fix-k` |
| fix-k | done | `panel-(k+1)`; if `k+1 > max_iterations` → **halt** ("did not converge in N rounds") |
| undraft | done | `done` — write `jobs/tada/<g>.md`, remove the record |

A stage report that is `done` but carries **no** parseable marker is treated as a
**failure** (halt + surface), never guessed at — the same fail-closed discipline
`panel.sh`'s disposition parse already uses.

## The hard part: the fix-loop iteration answer, with trade-offs

The job names three ways to express the unbounded loop. Weighing them:

### Option A — a stage that re-posts its own successor

The panel stage, on `must-fix`, posts the fix stage; the fix stage, on completion,
posts the next panel stage; a counter in each body caps iterations.

- **For:** no new watcher; each stage is self-driving.
- **Against:** the loop-control and give-up logic are **scattered across two stage
  handlers**, each of which must *remember* to post its successor — precisely the
  "loose pile of sub-jobs, forgotten follow-up" failure the standing orchestration
  directive (kriskowal 2026-07-01) exists to prevent. Worse, a stage `claude -p`
  that dies **after** doing its work but **before** posting the successor silently
  strands the PR; the reaper requeues the *stage*, but the successor-post is a side
  effect the resumed run must reproduce idempotently — fragile, and exactly the
  class of bug we are trying to leave behind.

### Option B — a fixed-child orchestration that re-promotes

Model the loop with `orchestrate.sh` over `jobs/orch/`.

- **For:** reuses the existing watcher wholesale.
- **Against:** `orchestrate.sh` promotes a **fixed child list once**; it has **no**
  notion of "re-promote the panel/fix pair until a panel returns clean." The loop
  count is unknown at record-creation time, so a fixed list cannot express it. Bending
  `orchestrate.sh` to re-promote would fork its semantics for one caller.

### Option C — a per-iteration child minted by the previous iteration's report

Each iteration's report dynamically names and posts the next.

- **For:** flexible.
- **Against:** same scattering as Option A, plus an **unbounded set of
  dynamically-named children** that makes the board hard to reason about and the
  give-up bound hard to enforce centrally.

### Chosen: a deterministic driver that recomputes the owed stage each tick (a refined Option B)

Keep the orchestration *philosophy* — a deterministic leader-only watcher owns
succession, so determinism (not an agent that could forget) makes the follow-up
reliable — but give it its own record type and driver (`gauntlet.sh` over
`jobs/gauntlet/`) so it can express the loop that `orchestrate.sh` cannot. The
driver re-posts a fresh `panel-(k+1)` after each `fix-k`, bounded by
`max_iterations` with a maintainer give-up path, and recomputes the owed stage from
the completed child's marker (and, as a cross-check, from live PR state) every tick.

**Why this wins:** succession lives in **one** deterministic place, not scattered
across stage handlers. A dead stage is simply requeued by the reaper; the driver
re-observes board state next tick and re-posts nothing it already posted (basename
idempotence) — **self-healing**, no lost follow-up. The give-up bound is enforced
centrally in the record, not re-derived by each handler. And the loop's *substance*
(which findings, which fixes) lives on the PR itself as panel verdicts and fixer
pushes — consistent with pr-creation-flow's rule to read *next-stage-owed from
GitHub, not from journal entries that lag*.

## The enabling primitive: single-round mode for `panel.sh`

`panel.sh` today owns the whole panel/fixer loop internally (the `while :` over
`GARDEN_PANEL_MAX_ROUNDS`, calling `run_fixer` between rounds and `undraft` at the
end). That internal loop is a primary structural cause of the overrun. The staged
gauntlet needs `panel.sh` to run **exactly one round** and report its disposition
without fixing or un-drafting.

Add `GARDEN_PANEL_SINGLE_ROUND=1`: fan the seats → aggregate → decide disposition →
**emit `pass` or `must-fix` on the terminal line and exit**, skipping `run_fixer`,
the appellate, and `undraft`. The panel stage handler runs `panel.sh` in this mode,
posts the aggregate as a `gh pr review` (the existing panel-verdict shape the
next-stage-owed heuristic already recognizes), and writes
`<!-- gauntlet-stage-result: panel=<disposition> -->` into its report. This change
is **inert** until the driver uses it (nothing else sets the flag), so it lands
safely ahead of the driver. It is covered by a unit test that stubs the seat and
decider hooks and asserts exactly one round runs and no fixer/undraft hook fires.

## Constraints, satisfied

- **Session continuity.** Every stage base is deterministic and stable across a
  requeue (`<g>-clean`, `<g>-panel-<k>`, `<g>-fix-<k>`, `<g>-undraft`), so a
  requeued stage derives the same session id and `--resume`s its transcript
  (`handlers/gardener-claude.sh` § session continuity). Crucially the base carries
  the iteration `k`, so a requeued `panel-2` resumes *panel-2*'s session, while a
  fresh `panel-3` correctly starts a *new* session — no cross-iteration bleed. The
  gauntlet **record** is not a claimed job, so it is never subject to a handler
  timeout at all.

- **Auto-gauntlet invariant.** `auto-gauntlet-handoff.sh` changes from posting one
  monolithic `<build>-gauntlet` job to **creating a gauntlet record**
  (`post-gauntlet.sh <g> <pr-url> --build-job <base> [--probe]`) the driver picks
  up. A build's draft PR still auto-runs the (now staged) gauntlet with no separate
  maintainer step; the comment-watcher's `run the gauntlet #N` path creates a record
  the same way. A **probe** creates a `kind: probe` record whose driver never
  reaches the `undraft` stage — it stays draft by design.

- **CI waits stay claim-sized.** The `clean` and `fix` stages watch CI with
  `ci-wait-merge.sh <repo> <N> --no-merge`, which is itself bounded
  (`GARDEN_CI_DEADLINE_SECS`, default 5400s). On its rc=4 (CI still pending at the
  deadline) the stage exits reporting `still-pending` **without** the stage-result
  marker's terminal value; the driver reads the absent/`pending` result and simply
  **re-posts the same stage** next tick (a fresh 2400s claim) rather than letting one
  handler block on CI indefinitely. rc=3 (CI red) fails the stage → halt. Because the
  stage base is stable, a re-posted CI-wait stage resumes its own session.

  That re-post is **bounded** (`max_resumes`, counted per stage and reset on every
  advance). Unbounded, a PR whose CI never goes terminal re-posted the same stage
  forever — a whole CI deadline and one gardener claim per round, silently, with no
  notice. The reachable case is not a hung check but a **checkless repo**:
  `ci-wait-merge` treats an empty rollup as not-green (correctly — right after a push
  the rollup is `[]` for about a minute), so a repo whose only workflow is
  push-triggered attaches **no** check to a PR head, times out at every deadline, and
  reports `still-pending` every round. `kriscendobot/minion.town` is exactly that
  shape. Spending the bound turns the silent forever-loop into the same loud halt
  every other non-convergence takes, naming `ci-wait-merge`'s own
  `GARDEN_CI_ALLOW_NO_CHECKS=1` opt-out.

- **Idempotence.** Re-running a completed stage is a no-op because each stage checks
  **live PR state** first: `undraft` no-ops if the PR is already ready; `clean`
  no-ops if coverage is already pushed and CI is green at the current head; a
  `panel-k` whose verdict already exists at the current head re-posts nothing. The
  driver's record writes are CAS-retried and basename-idempotent, and
  `post-gauntlet.sh` is a no-op if a record already exists (mirroring
  `post-orchestration.sh`). A requeue mid-chain therefore never redoes merged work
  or double-posts a comment.

- **Failure policy.** Any stage that genuinely fails (its job vanishes without a
  `tada/` report, or reports `orchestration-failed: true`) **halts** the chain
  (`state: halted`) and surfaces to the maintainer inbox — never a silent strand.
  Non-convergence at `max_iterations` halts the same way, with a distinct message, as
  does a CI-blocking stage that spends `max_resumes` re-posts without CI ever going
  terminal.

## Migration of the nine doomed jobs

The nine are **not** all gauntlets, and the honest migration treats them by shape.

**Gauntlet/panel-shaped (become staged runs, not promoted as-is):**

- `endo-sturdyref-agent-surface-build-gauntlet` (deadline-overrun; PR #871) — the
  canonical case. Re-post as a **gauntlet record** for #871 via `post-gauntlet.sh`;
  the driver walks it in stages. Do **not** promote the parked monolithic job
  as-is — that just reproduces the overrun.
- `endojs-endo-but-for-bots-pr755-review-a0778b2e` — a maintainer-review directive
  that overran running the panel/fix by hand. **Live special case:**
  `endojs-endo-but-for-bots-pr755-gauntlet` is still in `jobs/doin/` (mid-flight,
  14000s budget, head advanced, checks green). Let it finish; if it completes only
  the un-draft remains — pick that up as a narrow `<g>-undraft` stage rather than a
  fresh full gauntlet. If it overruns, create a gauntlet record for #755 pinned to
  its current stage (its head is advanced and green, so the driver starts at
  `panel` or `undraft`, not `clean`).
- `finbot-pr5-panel-20260727` (kriscendobot/finbot #5) — a bare "run the panel"
  directive that overran because 28 seats ran inside one handler. Re-post as a
  gauntlet record; the panel becomes its own `<g>-panel-1` stage (single-round
  `panel.sh`), which fits.

**Not gauntlet-shaped (out of scope for this design; flagged, not silently
promoted):**

- `ebfb-reconcile-xsnap-pending-jobs-861-864` — a reconcile-two-PRs build task that
  overran on heavy build work, not on the gauntlet chain. It needs its own
  decomposition (or a bigger budget for the *build*), not the staged gauntlet.
- `endojs-endo-but-for-bots-pr867-dependabot` — a botanist Dependabot review that
  overran on review depth. Its own decomposition problem.
- The remaining named jobs that are already **absent** from `jobs/plan/`
  (`…-form-data-advisory`, `…-pr705-fixer-changes-requested`,
  `finbot-progress-20260728-065010`, `fu-…-pr825-8840fcdb-2`) were promoted,
  re-doomed under a different key, or renamed since the report; re-triage each by
  shape when it resurfaces.

The migration is **executed by the build child** (below), not by this design doc:
each gauntlet-shaped doomed job is re-posted as a gauntlet record once the driver
is live, and each non-gauntlet job is left parked with a one-line maintainer note
that it needs its own decomposition.

## Delivery plan

This design is large enough that it lands with an **enabling primitive** and an
**orchestrated build child** for the rest, per the job's own escape hatch:

1. **Landed with this design:** `panel.sh` single-round mode
   (`GARDEN_PANEL_SINGLE_ROUND=1`) + its unit test
   (`scripts/jobs/test/panel-single-round-test.sh`, 14 assertions, hermetic) —
   inert until the driver uses it.
2. **Orchestrated build child** (`staged-gauntlet-build`, serial, halt-on-failure):
   - `post-gauntlet.sh` + the `jobs/gauntlet/` record format;
   - `gauntlet.sh` deterministic driver + its unit test (modeled on
     `scripts/jobs/test/orchestrate-test.sh`, reusing `child_state` /
     `promote-plan.sh` / `finish_orch` / `set_orch_state` from `common.sh` /
     `orchestrate.sh`);
   - the `garden-gauntlet` leader-only timer+service (systemd templates +
     `install-units.sh` + `is-main-host.sh` gate);
   - the stage handlers (`clean`/`panel`/`fix`/`undraft`) as thin `role: gardener`
     job bodies that call the existing `panel.sh`/coverage/CI scripts and emit the
     stage-result marker;
   - switch `auto-gauntlet-handoff.sh` and the comment-watcher `run the gauntlet`
     path to create a record instead of a monolithic job;
   - demonstrate end-to-end on one real PR (each stage inside 2400s, chain reaches
     un-draft);
   - execute the migration of the gauntlet-shaped doomed jobs.

## Notes

- The driver is **leader-only** (like `orchestrate.sh`) so a halt surfaces to the
  maintainer exactly once; stage-job promotion is CAS-deduped and safe on any host.
- The record's `stage`/`iteration`/`current_child` are the *sequencing* state; the
  *substance* (findings, fixes) lives on the PR. The driver never needs an LLM.
- For a PR that needs no fixes, the loop is `clean → panel-1 (pass) → undraft` —
  three claim-sized stages, no fixer round, exactly the "no must-fix on first panel
  round" variant of pr-creation-flow.
</content>
</invoke>
