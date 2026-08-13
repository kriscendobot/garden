# Liveness + progress over elapsed deadlines

| Created | 2026-08-12 |
| Author  | designer (gardener) |
| Status  | Implemented (2026-08-13) |

Maintainer directive (kriskowal, 2026-08-12), verbatim:

> We may need to look at this problem as one of detecting liveliness and progress
> rather than simply elapsed deadlines. We might want to have a threshold after
> which we do not sweep the [job], but rather assess whether we have run over the
> job's notional token budget and instead park a go-ahead plan to be triggered
> when the token budget refreshes.

## The problem, and the one line that names it

Today a claim's fate is decided by **elapsed wall-clock alone**. `applied_handler_budget`
(`common.sh`) fixes a per-role budget, `gardener.sh` runs the handler under `timeout`,
and `reaper.sh` counts wall-hits and dooms the job at `GARDEN_REAP_OVERRUN_THRESHOLD`
(1) or requeue exhaustion at `GARDEN_REAP_DOOM_THRESHOLD` (5). Nothing on that path asks
whether the job was *doing anything*.

`endojs/endo-but-for-bots` PR #903 — the same review directive, three instances — is the
worked example:

- `…-review-1ec51e37` (review 4871446371) — doomed 2026-08-06, `deadline-overrun`.
- `…-review-6ea43da5` (review 4911019892) — doomed 2026-08-11, `deadline-overrun`.
- `…-review-024fa540` (review 4913075771) — overran 2400s at the wall (rc=124,
  elapsed 2404s) and then COMPLETED on a later cycle, resolving all 5 items,
  replying to 4 inline comments, pushing `a1a18e3f7..78f65eae7`.

The survivor's completion report carries the load-bearing sentence:

> A prior run of this job had done extensive, high-quality work in the persisted
> project worktree but never committed or pushed it (the job had been requeued).

The job was **live and progressing** when the wall killed it. The work survived only
because the per-job worktree happens to persist across a requeue — it was invisible to
the reaper, uncommitted, unpushed, and a later cycle had to spend a *second* full
engagement re-verifying it before it could finish. Two siblings got no such rescue and
sit doomed.

A wall-clock budget cannot separate the three shapes that all look identical at 2400s:

1. a **wedged** handler blocked on a dead socket, burning nothing;
2. a **spinning** handler in a tight retry loop, burning tokens, achieving nothing;
3. a handler **doing exactly the work asked**, on a job that is simply big.

Only the third is common on the expensive roles (designer, builder, review), and it is
the one the current design punishes hardest — because the `deadline-overrun` counter
dooms at the *first* wall-hit unless the job earned a productive-cycle exemption, and
that exemption fires only on a **committed** HEAD advance (`job_cycle_productive`), which
the #903 survivor did not have.

## What the fleet already has (the substrate this design extends)

This design adds no new sampling infrastructure. Everything it needs is already produced:

- **Per-job worktree HEAD snapshots.** `job_worktree_heads`/`job_cycle_productive`
  (`common.sh`) snapshot the per-job worktrees' HEADs before and after every handler
  cycle; a HEAD advance stamps the productive-cycle marker and RESETS the doom counter
  in `reaper.sh`. This is the fleet's *only* existing progress signal, and it is
  commit-gated.
- **Per-engagement token/cost records.** `usage-append.sh` writes one CostRecord row to
  `usage/<base>.jsonl` on **every** requeue/fail cycle (not only on completion), stamped
  with `ts`, `input_tokens`, `output_tokens`, `cache_*`, `elapsed_s`, `outcome`, `host`,
  `role`, `model` (tada-token-accounting / token-cost-ledger). **The reaper does not read
  it today.** It is the missing progress signal, already on `journal2`, already synced.
- **The requeue safety floor.** `reap_age_threshold` = `max(GARDEN_CLAIM_TTL,
  budget + KILL_AFTER + SAFETY_SLACK)` and the live-handler PID guard
  (`_handler_alive_pids`, kill-and-defer) together are the deterministic answer to "may
  this claim be requeued now?" — a pure function of time and process liveness.
- **The deadline-nudge.** `deadline-nudge.sh` already queues an inbox warning at a
  fraction of the budget asking the agent to wrap up, checkpoint safe progress, and
  record follow-ups under `## Follow-ups`.
- **A weekly token window with a reset.** `usage-meter.sh` meters weekly token spend
  against `GARDEN_TOKEN_WINDOW_SECS` and `provider_quota_reset_clause` parses the
  provider's own "resets …(utc)" refusal clause. This is the real, implemented notion of
  "when the budget refreshes."
- **Budget-bounded dispatch (design family).** `budgeted-campaign-dispatch.md` +
  `recurring-budget-calibration.md` (the `budget/bucket.json` token bucket) bound
  *campaign dispatch*; `083cfb95ff` enforces it. The bucket is **design-only today** (no
  `bucket.json` in `scripts/`), so this design anchors "refresh" on `usage-meter.sh`'s
  window, and names the bucket as the clean eventual carrier once it lands.

The design's thesis in one sentence: **keep requeue-safety a pure time+PID function
(untouched), and replace the elapsed-only *doom decision* with a progress-and-budget
disposition that reads signals the fleet already writes.**

## 1. Liveness and progress as first-class signals

The detector runs in the **same plain-code spine as the reaper — no LLM, no new API
calls per tick.** Each candidate is judged on what it costs to sample, what it proves,
and how it is spoofed or goes stale. *A progress signal a wedged job can keep emitting is
worse than none*, so that test decides whether a signal may gate a doom or is advisory
only.

| Signal | Cost to sample | What it proves | How it is spoofed / goes stale | Role |
| --- | --- | --- | --- | --- |
| **HEAD advance** (`job_cycle_productive`) | 1 `git rev-parse` per worktree; already computed | A commit landed = **durable** progress | Empty/trivial commits each cycle (rare; requires a misbehaving handler). Stale for real-but-uncommitted work — the #903 hole | **Strong** — already resets doom; keep |
| **Token-spend delta** (sum `output_tokens` over this cycle's `usage/<base>.jsonl` rows) | read a small JSONL already on the synced clone | The model was engaged and generating: **not wedged** (rules out case 1) | A spinning retry loop (case 2) also burns output tokens — cannot rule case 2 in or out. A wedged socket burns **zero** → correctly reads "not progressing" | **Strong for liveness** (case 1 vs 3), **blind to case 2** |
| **Turn / tool-call count** this cycle (parse the session transcript already read for the token delta) | one transcript scan | The agent took actions | Same as tokens: a retry loop takes turns | Redundant with token-delta; optional richer log only |
| **Worktree working-tree mutation** (most-recent mtime under the per-job worktree, excluding `.git`) | one `find -newermt`/`stat` | *Files changed* — catches real-but-uncommitted work (#903) | **Trivially spoofed**: a wedged handler writing its own log keeps mtime fresh. A wedged-but-logging job passes | **Advisory only** — never gates a doom; used solely as a "there is unsaved work here, checkpoint before killing" hint |
| **PR / API side effects** (commits pushed, review replies) | a GitHub API call **per job per tick**, rate-limited | Real external progress | — | **Rejected** as a routine signal: too costly fleet-wide, non-deterministic; it is the *outcome* completion already records |
| **Handler heartbeat / PID liveness** (`_handler_alive_pids`) | already computed | The process exists | A handler blocked on a dead socket is "alive" yet progressing nothing — **this is the trap the directive is about** | Used only for the requeue-safety guard, never as progress |

**The honest limit, stated up front.** *No cheap deterministic signal distinguishes
case 2 (spinning, burning tokens, no durable output) from case 3 (working).* Both burn
tokens and take turns; the only thing case 2 lacks is **durable output** (a commit, a
pushed side effect). Therefore the design leans on **durable-progress (HEAD advance) as
the strong reset signal**, **token-spend as the "at least not wedged" liveness signal**,
and — crucially — **the notional token budget as the bound on case 2.** We do not try to
detect spinning directly; a spinner burns tokens, crosses its notional budget, and gets
parked (§2). The budget is precisely the backstop for the case progress-detection cannot
catch. mtime is advisory only, exactly because a wedged-but-logging job can keep it fresh.

**Composite `progress_verdict(base)`** (pure code, in `common.sh`, read by the reaper):

- `advancing` — HEAD advanced this cycle (already the productive-cycle marker), **or**
  the cycle's `output_tokens` delta ≥ `GARDEN_PROGRESS_MIN_OUTPUT_TOKENS` (default a few
  thousand — a genuine engagement, not a 1–2s cap-rejection). Rules out cases 1.
- `wedged` — zero token delta this cycle **and** no HEAD advance. The socket-dead case.
- `unknown` — the usage ledger is unreadable or absent for this cycle. **Fails to the
  conservative disposition** (§3/§5): treated exactly as today.

## 2. The threshold, and what replaces the sweep

Past the doom threshold the reaper stops treating "still running" as "broken" and
instead runs a **three-way disposition** in place of the single doom action. This is the
directive's "assess the notional token budget and park a go-ahead plan" made concrete.

**The notional token budget per job.** A role-keyed default, in the same family as
`role_default_handler_timeout`: a new `role_default_token_budget` (designer/builder/
review large; mentor/minion small), overridable by an explicit `token-budget: <N>`
header, exactly as `handler-timeout:` overrides the wall. Ship with static defaults
first; **calibrate them later from the cost ledger** the same way `handler-timeout`'s
7200s default was calibrated from what the board had already converged to by hand — take
the per-role p90 of completed-job `output_tokens` from `usage/*.jsonl`. Budget is
measured in **output tokens** (the scarce, generative quantity; cache reads excluded,
matching `campaign-spend.sh`). A job's spend-to-date is `sum(output_tokens)` over all its
`usage/<base>.jsonl` rows — already aggregated by `usage_footer`.

**The disposition, replacing the doom branch of `reaper.sh`:**

| Condition at the threshold | Action | Signature |
| --- | --- | --- |
| `progress_verdict = advancing` **and** spend < notional budget | **Requeue to `todo/`** (keep working) — do **not** doom | — (ordinary requeue) |
| spend ≥ notional budget (regardless of progress) | **Park a `--go-ahead` plan in `plan/`**, held, promoted on budget refresh | `over-token-budget` |
| `progress_verdict = wedged` **and** requeue cycles ≥ `GARDEN_REAP_DOOM_THRESHOLD` | **Doom-park held** (today's behavior — genuine defect) | `requeue-exhausted` |
| `progress_verdict = unknown` (signal unavailable) | **Fall through to today's behavior** (doom at existing thresholds) | as today |

The `over-token-budget` park is a **new held state distinct from doom**: same mechanism
as the doom park (parked in `plan/` under `gate: go-ahead`, work preserved, keyed on the
job spine so a re-park overwrites), but its notice reads *"parked pending budget refresh,
not doomed"* and it carries the fields a promoter needs: `token_budget:`, `token_spend:`,
`parked_for_budget_at:`, and the observed `budget_resets_at:` when the provider named one.

**What "refreshes" means, concretely, and the deterministic trigger.** "The token budget
refreshes" = the weekly Max-subscription window rolls over. Two anchors, both already in
the tree:

- The **`usage-meter.sh` weekly window** (`GARDEN_TOKEN_WINDOW_SECS`): the fleet already
  knows when its metered window resets.
- The **provider's own reset clause** (`provider_quota_reset_clause`) when a refusal
  named one — stamped onto the parked plan as `budget_resets_at:`.

A new **leader-only `garden-budget-refresh` tick** (deterministic, no LLM — a sibling of
the orchestrate/unblock watchers) scans `plan/` for `over-token-budget` plans and
promotes each back to `todo/` (stripping the hold, resetting the cycle markers, exactly
as `promote-plan.sh` does) once **either** the plan's `budget_resets_at:` has passed
**or** the current `usage-meter.sh` window has rolled past the `parked_for_budget_at:`
mark. This is the same "deterministically promote-when-the-board-reaches-a-state"
substrate as `blocked_on` + `unblock.sh` and the orchestrate watcher — a new promoter,
not a new budget system.

**Composition with the existing token-bucket work — no duplication.** This design bounds
*a single job's resumption*; `budgeted-campaign-dispatch`/`083cfb95ff` bound *campaign
dispatch*; both measure the same quantity (output tokens, cache excluded) from the same
ledger (`usage/*.jsonl`). When the `budget/bucket.json` token bucket lands
(`recurring-budget-calibration.md`), the `garden-budget-refresh` promoter should gate on
**the bucket's balance** instead of the raw window — a parked plan promotes when the
bucket has refilled enough to fund its notional budget — so the two schemes share one
balance and cannot double-spend. Until the bucket exists, the window/reset-clause anchor
is the honest, implemented stand-in.

## 3. Preserving the invariant the wall-clock budget actually protects

The wall-clock budget is not only a liveness heuristic. `job_handler_budget_base`'s
comment is explicit: gardener and reaper must compute the **same** budget, or the reaper
requeues a base onto a second gardener while the first still runs — **two live handlers
writing one persisted worktree** (the corruption class). Any progress scheme must keep an
unambiguous, conservatively-safe answer to *"may this claim be requeued now?"*

**It does, because requeue-safety and disposition are two separate decisions and only the
second changes.**

- **Requeue-safety stays a pure time+PID function, byte-for-byte as today.** A claim is
  safe to move out of `doin/` iff `age ≥ reap_age_threshold(f)` **and**
  `_handler_alive_pids(base)` is empty on this host. **No progress or budget signal ever
  makes a claim reapable earlier, and none ever keeps a live handler's claim from being
  requeue-safe after its wall.** The progress/budget assessment runs *only after* a claim
  is already proven safe to move, and only chooses the **destination**.
- **We never invent a "leave it in `doin/` but treat it as alive" state.** That is the
  one thing that would break the invariant — a second gardener could claim it. Every
  disposition (§2) is a **terminal move out of `doin/`**: requeue → `todo/`, budget-park
  → `plan/` (held, out of the race until a promoter re-posts), doom-park → `plan/`
  (held). The handler is already dead — `timeout` killed it at the wall; the gardener
  owns that and it is **unchanged**. "Do not sweep" in the directive means *do not doom*
  (do not treat elapsed as broken); the dead claim still leaves `doin/`, so nothing is
  ever stranded there.
- Because a budget-park and a doom-park are both **held** (`gate: go-ahead`, which no
  auto-promoter selects — only the new refresh promoter selects `over-token-budget`, and
  only a human/the liaison selects a doom), neither can re-enter the race concurrently
  with anything. Duplicate concurrent execution is impossible by construction, exactly as
  today.

So the load-bearing sentence for the invariant is: **this design changes only the reaper's
choice of destination for an already-requeue-safe, already-dead claim; it changes neither
the timing of that safety nor the handler's wall-clock kill.**

## 4. Losing less work at the boundary

The #903 rescue was luck: the work survived only because the worktree persisted, and a
later cycle paid to re-verify it. Two fixes, both riding machinery that already exists,
turn that luck into a guarantee:

1. **A final-checkpoint nudge that earns the exemption.** `deadline-nudge.sh` already asks
   the agent to wrap up and checkpoint. Add a **second, insistent nudge very close to the
   wall** (a small fraction, e.g. remaining ≤ `2·interval`) whose text is specifically:
   *"Commit and push WIP NOW, even if incomplete — a requeue resumes from your commit;
   uncommitted work is invisible to the reaper and may be re-done."* This closes the #903
   hole mechanically: a WIP commit **advances HEAD**, which fires the existing
   productive-cycle marker, which **already resets the doom counter**. So a job that
   checkpoints is spared automatically — the preservation and the exemption are the same
   act. No new reaper logic needed for this half; it is a nudge-text + threshold change.
2. **A legible requeue state.** The nudge already directs next work to `## Follow-ups`
   (consumed by `garden-follow-up`). Keep, and have the checkpoint commit message be the
   agent's own one-line "what I established / what remains," so a resumed cycle inherits a
   summary rather than an archaeological dig.

Note the two rescues are **independent**: even a job that ignores the nudge is now kept
alive by the §2 `advancing` disposition (token-spend > 0 → requeued, not doomed), and a
job that heeds it is kept alive by the productive-cycle reset. #903's survivor would have
been saved by *either*.

## 5. Migration — no flag day, fail toward conservative

Staged so each phase is independently revertible and the progress signal, if it breaks,
fails toward **today's conservative doom**, never toward "never reap."

- **Phase 0 — observability, zero behavior change.** The reaper reads `usage/<base>.jsonl`
  and computes `progress_verdict`, and **logs what it *would* decide** (shadow), and
  stamps a `progress:` line onto every doom notice: *"spent N output tokens this cycle;
  HEAD advanced y/n; verdict advancing/wedged/unknown."* Ships first. Pure logging;
  operators can watch the shadow disagree with the live doom before anything flips.
- **Phase 1 — notional budget, still no behavior change.** Add `role_default_token_budget`
  + `token-budget:` header + spend-to-date read from the ledger. Log "over/under notional
  budget" alongside the shadow verdict. Calibrate defaults from the cost ledger's per-role
  p90.
- **Phase 2 — flip the disposition.** Replace the doom branch's single action with the §2
  three-way table. Guarded by a kill-switch env `GARDEN_PROGRESS_DOOM` (`on` = new
  behavior, `off`/unset during rollout = today's pure-elapsed doom), and by a journal flag
  for fleet-wide arming (mirroring `config/kimi-takes-opus-work`). The wall-clock doom
  stays as the **backstop** for `wedged` and `unknown`. The final-checkpoint nudge (§4)
  ships here too.
- **Phase 3 — the refresh promoter.** Add the leader-only `garden-budget-refresh` tick
  that promotes `over-token-budget` parked plans on window rollover / reset-clause expiry.
  Until Phase 3 lands, an `over-token-budget` park behaves like a held doom (a human
  promotes it) — strictly no worse than today, so Phases 2 and 3 can ship separately.

**Failure mode of the signal itself.** If `usage/<base>.jsonl` is unreadable, absent, or
malformed, or the worktree is gone, `progress_verdict = unknown` → the reaper takes
**today's exact behavior** (doom at the existing thresholds). If `jq` is missing, same.
The signal can only *spare* a job it can positively read as advancing/under-budget; it can
never *prevent* a doom it cannot assess. There is no path where a broken signal yields
"never reap."

**Backstops that never leave.** The age floor + live-PID guard (§3) are untouched. The
`requeue-exhausted` doom at cycles ≥ 5 stays — but now only genuine no-progress loops
reach it, because an `advancing` job requeues without incrementing toward it (as a
productive cycle already does today). And `GARDEN_PROGRESS_DOOM=off` reverts the whole
disposition to pure elapsed instantly.

**Operator diagnosis.** (a) Every doom/park notice names the signals that decided it
(tokens this cycle, HEAD advanced, notional budget, over/under). (b) A new read-only
`progress.sh <base>` (a sibling of `cost.sh`, no LLM, no gating) dumps the per-cycle
spend/progress history for one job. (c) The Phase-0 shadow log lets an operator confirm
the new verdict tracks reality before Phase 2 flips it, and diff shadow-vs-live after.

## The #903 case, walked end to end under this design

- **`…-review-024fa540` (the survivor).** Overran 2400s, real review work, uncommitted.
  Under Phase 2: the reaper finds this cycle's `output_tokens` delta large (a genuine
  engagement) → `progress_verdict = advancing`; it is a `review` role, spend still under
  its notional budget → **requeue to `todo/`, do not doom.** Kept alive
  **deterministically — no luck.** Independently, the §4 final-checkpoint nudge would have
  had it commit WIP → HEAD advance → productive-cycle reset → same outcome. Two rescues,
  either sufficient.
- **`…-review-1ec51e37` / `…-review-6ea43da5` (the two doomed).** The design gives the
  right answer whichever they actually were, and names the observable that decides:
  - If they were **live and progressing** (nonzero token delta, under budget) — as the
    third instance proves this directive's work is — they are **requeued, kept alive**,
    exactly like the survivor. The two dooms would not have happened.
  - If one were **genuinely wedged** (zero token delta, no HEAD advance, mtime cold) it is
    **correctly still doomed** — the design kills the genuinely dead and keeps the
    genuinely live. From the evidence we cannot know which; the point is the design
    decides on the observable rather than on the clock.
- **A review that legitimately exceeds its notional budget** (a genuinely enormous PR):
  parked `over-token-budget`, surfaced to the maintainer as *"parked pending budget
  refresh, not doomed,"* and auto-promoted by `garden-budget-refresh` when the weekly
  window rolls — the honest state, and never a silent loss.

## What this does NOT solve, and where it is more permissive

- **It does not distinguish a spinner (case 2) from a worker (case 3).** No cheap
  deterministic signal can. It **bounds** the spinner with the notional token budget
  instead of detecting it: a spinner burns tokens, crosses budget, and is parked.
- **It does not add PR/API side-effect sampling.** Too costly fleet-wide; the outcome is
  what completion already records.
- **It does not change the handler's wall-clock kill.** `timeout` still kills at the wall;
  this is about the reaper's *disposition of the dead claim*, not runtime.
- **It does not make mtime a doom gate** — a wedged-but-logging job could keep mtime
  fresh, so mtime is advisory (checkpoint hint) only.

**Where it is more permissive than today, and why that is acceptable.** A job that is
`advancing` (or merely under budget) but is *actually spinning* will now be **requeued
instead of doomed at the first wall-hit**, so it can burn up to its **full notional token
budget** before being parked, versus dooming after one wall-hit today. Three reasons this
trade is right, and it is exactly the maintainer's ask:

1. The extra spend is **bounded, not unbounded** — the notional budget is a hard ceiling
   and the `over-token-budget` park is the enforced stop.
2. The current threshold-1 doom's **false-positive rate on legitimately-big, expensive
   jobs is high** (the #903 evidence — a 3-instance review, 2 killed), and those are
   precisely the costly-to-restart roles (designer/builder/review). Trading a bounded
   token overspend on rare spinners against not-dooming-live-work on the expensive roles
   is the correct direction.
3. **Human review dominates machine cost by ~50–190× at the median** (garden memory:
   *human-review-dominates-machine-cost*). A bounded extra token burn on a rare spinner is
   cheap against the human cost of a falsely-doomed review that a person must notice,
   diagnose, promote, and re-drive. The design optimizes the dominant term.

## Staged jobs for the liaison to post

1. **`build-progress-verdict-observability`** (Phase 0) — reaper reads `usage/<base>.jsonl`,
   computes `progress_verdict`, shadow-logs the would-be disposition, stamps `progress:`
   onto doom notices. No behavior change.
2. **`build-notional-token-budget`** (Phase 1) — `role_default_token_budget` +
   `token-budget:` header + spend-to-date read; log over/under budget. Calibrate defaults
   from the cost ledger p90.
3. **`build-progress-disposition-flip`** (Phase 2) — the three-way disposition replacing
   the doom branch, behind `GARDEN_PROGRESS_DOOM` + a journal arming flag; the
   final-checkpoint nudge; `progress.sh` read tool.
4. **`build-budget-refresh-promoter`** (Phase 3) — leader-only `garden-budget-refresh`
   tick promoting `over-token-budget` plans on window rollover / reset-clause expiry;
   gate on `budget/bucket.json` if it has landed by then.

Suggested shape: an **orchestration job** (`orch-liveness-progress-reaping`, serial,
`on-child-failure: halt`) with the four above parked as children, so Phase N+1 promotes
only after Phase N reaches `tada/` — the standing multi-part decomposition pattern.

## Implementation note (2026-08-13)

The implementation landed the phases together because the deadline-handoff job
required an end-to-end park and refresh test. `GARDEN_PROGRESS_DOOM` therefore
defaults to `on`; setting it to `off` is the immediate rollback. No separate journal
arming flag was added. The destination decision is local to the already-synced reaper
clone and has the environment kill switch, while a second flag would let hosts
disagree during a mixed-version rollout.

The shipped role defaults are static starting values (100,000 ordinary and 250,000
large-role output tokens). Calibration from completed-job percentiles remains an
operator tuning task. The refresh promoter uses a parseable `budget_resets_at` when
present. Otherwise it waits the recorded rolling window and requires the local quota
meter not to report backoff. Provider refusals are represented by the existing
absolute `garden-provider-quota-backoff` marker after the provider's reset clause is
parsed; deadline nudges report that typed exhausted state and reset directly.

Promotion stamps a fresh `token-budget-epoch`. Later disposition sums output tokens
from that epoch, not from the job's first lifetime engagement. Without a new epoch,
a resumed job would remain over its old notional cap and park again at the next wall,
making quota refresh unable to grant a usable new work allowance.
