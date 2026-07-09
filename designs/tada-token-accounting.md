# Deterministic per-engagement token-spend accounting on the tada report

| Created | 2026-07-09 |
| Author  | designer (job `gardener-tada-token-accounting`) |
| Status  | Accepted (maintainer-commissioned 2026-07-09; builder follow-up expected) |

Every gardener engagement burns tokens; today that spend is visible only in
aggregate (the `usage-meter.sh` trailing-window meter) and never attributed to
the job that spent it. This design makes `gardener.sh` capture the token spend
of **every engagement** deterministically — plain code, **no LLM anywhere in the
capture or annotation path** — record it in a journal-backed, append-only
**usage ledger keyed by job base**, and stamp an authoritative machine footer
onto the `jobs/tada/` report at every doin→tada transition. The ledger is the
source of truth; the footer is a regenerated view. The annotation is never
authored, and can never be destroyed, by an agent rewriting the report body.

Maintainer constraints (2026-07-09), restated as invariants:

1. Capture is **automatic and code-driven** from the `gardener.sh` invocation
   chain — the worker loop and the scripts it calls, never the `claude -p` agent.
2. **Every** handler invocation is captured, not just the one that completes.
3. Spend **accumulates** across engagements of one base — requeue cycles,
   resumes, different gardeners, different hosts.
4. The annotation **survives an agentic rewrite** of the report body.
5. The token record is **externalized** to a file the handler's `claude -p`
   never writes.

## The substrate this builds on (all existing)

- **`scripts/jobs/usage-meter.sh`** — reads Claude Code's per-turn `usage` from
  session JSONL under `~/.claude/projects/**`, **dedups by message id** (a
  message id repeats once per streamed content block), and defines
  **billable = input + output + cache_creation** (cache_read excluded unless
  `GARDEN_TOKEN_COUNT_CACHE_READ=1`). Sourced by `common.sh`, so its helpers
  are in scope in every job-board script. This design reuses that billable
  definition and dedup **exactly** and adds two helpers (below).
- **`scripts/jobs/handlers/gardener-claude.sh`** — runs `claude -p` with
  **cwd = the per-base worktree** `$GARDEN_SCRATCH/gardener-wt-<base>` and a
  **deterministic session id** `uuid5(NAMESPACE_URL, "garden-job:"+base)`.
  Claude Code keys its transcript directory by the launch cwd
  (`~/.claude/projects/<encoded-cwd>/<sid>.jsonl`), so the transcripts of a
  job's session(s) land in directories **derived from the base and shared with
  no other job**. It already probes two cwd encodings (slash-only and
  slash+dot). On genuine completion it spools the transcript
  (`transcript_spool`) and then **deletes it** — an ordering fact the
  measurement contract below is designed around.
- **`scripts/jobs/gardener.sh`** — the single call site that invokes
  `$GARDEN_JOB_HANDLER <base> <jobfile> <report>` under `timeout`, already
  passing per-invocation state through env (`GARDEN_COMPLETION_SENTINEL`,
  `GARDEN_GARDENER_ID`). Its outcome branches (completion /
  exit-0-unsatisfying / non-zero failure) are exactly the engagement outcomes
  the ledger records.
- **`scripts/jobs/complete-job.sh`** — the deterministic doin→tada transition,
  a sync→stage→commit→CAS-push retry loop that already touches only this
  gardener's own basename. The footer stamp and the final ledger row ride this
  existing push.
- **`common.sh` § per-job worktrees** — `job_worktree_heads <base>` already
  derives every per-job worktree path from the base
  (`gardener-wt-<base>`, `project-wt-<base_safe>-*`). The session-dir
  enumeration below is the same derivation, one hop further.

## a. Attribution: the job's own session files, never a time window

**Decision: attribute by session transcript, per job base.** An engagement's
spend is measured as a **before/after delta of the billable sum over the job's
own session JSONL files** — the files under the `~/.claude/projects/` project
directories derived from the job's per-base worktrees. No other job can write
those directories (worktree paths embed the unique base), so **concurrent
gardeners on the shared per-host `~/.claude` cannot cross-contaminate the
measurement**. The time-window approach (sum all log lines in
[handler-start, handler-end]) is **rejected**: with ~100 gardeners interleaving
turns in the same log tree it double-books every concurrent peer's spend and is
wrong by construction, not merely racy.

Two new helpers in `usage-meter.sh` (same conventions: never abort the caller,
degrade to failure-return, jq-parse resilient to malformed lines):

- `job_session_dirs <base>` — print the candidate session project directories
  for this base. For each existing per-job worktree path (the same set
  `job_worktree_heads` walks: `$GARDEN_SCRATCH/gardener-wt-<base>` and
  `$GARDEN_SCRATCH/project-wt-<base_safe>-*`), print
  `$HOME/.claude/projects/<encoded>` under **both** cwd encodings
  (`s#/#-#g` and `s#[/.]#-#g`), deduplicated. The `gardener-wt-<base>` entry is
  printed even when the worktree does not (yet/still) exist, so a
  before-snapshot taken before `ensure_worktree` and an after-snapshot taken
  after teardown still address the same primary directory. Including the
  `project-wt-*` dirs captures inner `claude -p` calls the supervised gardening
  state machine makes with cwd in the project checkout.
- `meter_job_session_total <base>` — sum **billable** tokens (the existing
  formula, message-id-deduped, honoring `GARDEN_TOKEN_COUNT_CACHE_READ`) over
  **all** `*.jsonl` in all `job_session_dirs <base>` directories, **no time
  cutoff**. Prints an integer; returns 1 (→ unknown upstream) only on a tooling
  error (no jq, unreadable dir), and prints `0` for absent dirs (a genuine
  zero). Summing whole directories — not just the deterministic sid file —
  deliberately covers `--resume` runs that fork a new session id into the same
  project dir.

**The delta.** `engagement_tokens = clamp(S_after − S_before, ≥0)` where both
snapshots are `meter_job_session_total <base>`. Why a delta rather than a raw
sum: a requeued base resumes with the prior engagements' transcript still on
disk (that presence *is* the resume signal), so the raw sum at engagement end
includes prior engagements; subtracting the start snapshot isolates this
engagement exactly. The delta is also immune to stale leftovers (a forked-sid
transcript lingering from an earlier engagement inflates both snapshots
equally) and to a cross-host re-claim (fresh host → both snapshots start from
whatever is locally present, usually 0). Session JSONL is append-only for the
duration of a run and nothing retires transcripts between the two snapshots
(see the contract next), so the delta is exact, not approximate.

**Who measures — the two-layer contract.** The complication is ordering: on the
completion path `gardener-claude.sh` spools and **deletes** the transcript
before it returns, so a measurement taken afterwards in `gardener.sh`
undercounts to ~zero exactly on the most important path. The contract mirrors
the existing `GARDEN_COMPLETION_SENTINEL` pattern:

1. **Primary — the handler writes `GARDEN_USAGE_FILE`.** `gardener.sh` mktemps
   a path, removes it, and exports it as `GARDEN_USAGE_FILE` alongside
   `GARDEN_COMPLETION_SENTINEL`. `gardener-claude.sh` takes its own
   `S_before = meter_job_session_total "$base"` immediately before launching
   `claude -p`, and immediately after `claude` exits — **before** the
   sentinel/teardown/spool/rm block — computes the delta and writes one line to
   `$GARDEN_USAGE_FILE`: `<tokens>\thandler`. This is plain bash in the
   handler script; constraint 1 is intact — the *agent* never sees or writes
   the file (it is not named in the prompt, and it lives outside the worktree).
2. **Fallback — `gardener.sh` measures itself.** `gardener.sh` also takes its
   own `S_before` snapshot just before invoking the handler. When the handler
   returns and `GARDEN_USAGE_FILE` is missing or malformed — the handler was
   SIGTERM/SIGKILLed by the `timeout` wrapper, crashed before the write, or is
   a handler that does not implement the contract (test stubs) — `gardener.sh`
   computes `meter_job_session_total` again and uses its own delta, tagged
   `fallback`. This is valid precisely on those paths because a killed handler
   never reached its teardown, so the transcripts are still on disk.
3. **Last resort — `unknown`.** If the meter itself fails (no jq, unreadable
   log dir) on both layers, the engagement is recorded with tokens `unknown`.
   Never a blocker (§ f).

A `claude -p` invoked by the supervised job with a cwd outside the per-job
worktrees (e.g. `/tmp`) escapes attribution — a documented, fail-open
undercount, not a correctness hazard for anyone else's ledger.

## b. Engagement boundary

**One engagement = one `$GARDEN_JOB_HANDLER` invocation by `gardener.sh`** —
the single `timeout … "$GARDEN_JOB_HANDLER" …` call site — regardless of
outcome. Each claim (todo→doin) leads to exactly one engagement ending in one
of: **tada** (completion), **requeue** (exit-0-unsatisfying, transient failure,
external kill, wall-clock timeout — the job stays in doin for the reaper), or
**fail** (real-failure classification; also left in doin today). Every one of
those appends its own ledger row: tokens were spent whether or not the job
finished. A base that cycles todo→doin→requeue five times and completes on the
sixth accrues six rows; a base worked on host A, reaped, and finished on host B
accrues rows from both hosts. A **re-posted** base after completion keeps
appending to the same ledger file — the ledger records the lifetime spend of
the base, and the engagement count in the footer makes multi-posting visible
rather than hidden.

## c. The externalized store: `usage/<base>.tsv` on `journal2`

**Path.** `usage/<base>.tsv` at the journal top level — a sibling of `jobs/`,
`inbox/`, `hosts/`. Deliberately **not** under `jobs/`: the `jobs/` lanes have
lifecycle semantics (`complete-job.sh` removes `doin/`, `work/`, and the inbox
at completion; `sync_clone` runs `git clean -fd jobs`), and the ledger must
**outlive** the job's board presence — it is the durable record the tada footer
is derived from, and it survives re-posts. Journal-backed means shared across
hosts, serialized by the same CAS push as every other board write, and it
survives any single host.

**Row format.** Append-only TSV, one row per engagement, written only by
`gardener.sh`/`complete-job.sh` (via the shared helpers below), never by the
handler and never by an agent:

```
<epoch>\t<host>\t<gardener-id>\t<elapsed-s>\t<tokens>\t<source>\t<outcome>
```

- `epoch` — engagement end, seconds (`date +%s` at record time).
- `host` — `$GARDEN` (the shard identity, not raw hostname).
- `gardener-id` — the worker index (`$id`).
- `elapsed-s` — handler wall-clock seconds (`SECONDS − handler_start`,
  already computed).
- `tokens` — non-negative integer, or the literal `unknown`.
- `source` — `handler` | `fallback` | `none` (which layer of § a produced it).
- `outcome` — `tada` | `requeue` | `fail`.

**Running total: derived, never stored.** The total is
`awk` over column 5 summing numeric values (rows with `unknown` contribute 0
to the sum and 1 to an `unknown`-row count, both reported). A
cumulative-to-date column is **rejected**: it is derived state that every
CAS-rebase retry would have to recompute against the freshly synced file, and
any divergence (a hand edit, a lost race) would make two rows disagree about
history. Sum-on-read over a per-base file (tens of rows) is trivially cheap
and has a single source of truth.

**Writers.**

- A new shared staging function in `usage-meter.sh` (in scope everywhere via
  `common.sh`): `usage_ledger_stage_row <clone-dir> <base> <elapsed>
  <tokens> <source> <outcome>` — appends the row to
  `<clone-dir>/usage/<base>.tsv` (creating `usage/` as needed) and
  `git add`s it. Stage-only, no sync/commit/push; the caller owns the loop.
- A new `scripts/jobs/usage-append.sh <base> <elapsed> <tokens> <source>
  <outcome>` — the standalone CAS writer for **non-completion** engagements:
  `ensure_clone` + bounded retry loop of `sync_clone` →
  `usage_ledger_stage_row` → `commit_and_push` (same shape as
  `complete-job.sh`, small bounded attempt count — this write is best-effort,
  § f). `gardener.sh` calls it **subshell-isolated** (`( … ) || log …`), the
  established pattern for hint stamping, so a `sync_clone` offline-exit can
  never kill the worker loop.
- The **completion** engagement's row does not use `usage-append.sh`: it rides
  `complete-job.sh`'s existing commit (next section), so the happy path adds
  **zero** extra journal pushes.

Per-base write races cannot arise semantically: the claim single-owner
invariant (handler timeout + kill-after < claim TTL) guarantees at most one
live engagement per base, and the journal CAS serializes everything anyway.

## d. Reaching the tada report: a re-stamped machine footer (option i)

**Decision: (i) — `complete-job.sh` deterministically (re)stamps a delimited
machine footer onto the tada file on every doin→tada transition**, derived
from the ledger. A pointer-only report (option ii) was rejected because the
maintainer's stated goal is that *the tada report carries* the running cost —
a reader of `jobs/tada/<base>.md` should see the number without a second
lookup. The sidecar remains the **source of truth**; the footer is a view that
is recomputed, never edited.

Inside `complete-job.sh`'s existing retry loop, after `sync_clone` and before
`commit_and_push`, with the report already copied to `$JOBS_TADA/$base.md`:

1. **Append the final engagement's row** via `usage_ledger_stage_row`, taking
   the engagement measurements from env (`GARDEN_ENGAGEMENT_ELAPSED`,
   `GARDEN_ENGAGEMENT_TOKENS`, `GARDEN_ENGAGEMENT_SOURCE`) that `gardener.sh`
   exports before calling `complete-job.sh`; outcome `tada`. **Guard for
   idempotence:** append only when `doin/<base>.md` still exists in the synced
   clone — i.e. this run is performing the actual transition. A re-run against
   an already-completed base (the rc=2 "nothing to commit" path today) must
   not append a duplicate row. When the env is unset (a non-gardener caller),
   skip the row; the footer still stamps from whatever ledger exists.
2. **Strip any existing footer block** from the tada copy — a range delete
   from the begin marker to the end marker. This is what makes the stamp
   idempotent and makes the annotation survive an agent: if the agent's report
   body somehow contains a stale or fabricated footer block (a resumed session
   that copied one, a prompt-injected imitation), it is deleted wholesale
   before the authoritative one is appended.
3. **Append the fresh footer**, computed by a helper
   `usage_footer <clone-dir> <base>` reading the just-synced (and
   just-appended) `usage/<base>.tsv`:

```markdown
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/<base>.tsv; not agent-authored — do not edit -->

---
**Token spend** (billable = input + output + cache_creation, deduped; source of truth: `usage/<base>.tsv` on `journal2`):
total **<TOTAL> tokens** over <N> engagement(s) on <H> host(s)<, plus <U> engagement(s) unmetered>.
<!-- garden-usage-end -->
```

Every field is machine-derived; the `<, plus …>` clause appears only when
`unknown` rows exist, so an undercount is always visibly flagged rather than
silently absorbed. The footer stays small (totals, not the row table — the
TSV itself is one `git show` away) so re-stamping never bloats the report.

Because steps 2–3 run on **every** doin→tada transition, a re-posted base that
completes again gets a fresh footer reflecting the grown ledger. A future
role that rewrites tada bodies in place (a journalist, a retconner) either
preserves the delimited block or loses only the *view* — the ledger is intact
and the next deterministic re-stamp (or a trivial re-run of the stamp helper)
restores it. Constraint 4 is satisfied at the data layer, not by trusting any
rewriter.

## e. Multi-host accumulation

Host-additive by construction: each host's `gardener.sh`/`complete-job.sh`
appends rows measured from its **own** `~/.claude` to the **shared** journal
ledger, each row tagged with `$GARDEN`. The total is the column sum across all
rows regardless of host; no host ever needs another host's session logs. This
sidesteps `usage-meter.sh`'s documented single-host assumption entirely — that
assumption constrains the *trailing-window quota meter*, not this ledger. (As
a side effect the ledger is also a journal-backed spend record that a future
multi-host quota aggregator could sum, the exact shape usage-meter.sh's
`TODO(multi-host)` sketches — noted, not in scope.)

## f. Fail-open, always

The job completing is load-bearing; the annotation is best-effort. Concretely:

- All new helpers follow `usage-meter.sh` conventions: never abort the caller
  (`set -e`-safe), degrade to a failure return, swallow write errors with a
  `log` line.
- A meter failure at both layers of § a records `unknown\tnone` — a row is
  still appended (constraint 2: the engagement itself is never unrecorded
  merely because its cost is).
- `usage-append.sh` retries its CAS push a small bounded number of times, then
  gives up with a logged warning. A lost row (e.g. appended while offline —
  the same outage that already left the job in doin) is a logged undercount,
  never a wedge. `gardener.sh` invokes it subshell-isolated so even an
  offline `exit` inside `sync_clone` cannot kill the worker.
- In `complete-job.sh`, steps 1–3 of § d are individually guarded
  (`|| log "usage: …"`): a missing/corrupt ledger, an unset env, or a failed
  footer computation stamps nothing (or stamps a footer with what it has) and
  the doin→tada commit proceeds. The transition **never** fails, blocks, or
  loses the report on account of token accounting.
- The measurement adds one jq scan of (usually) one small directory per
  snapshot — negligible against a multi-minute engagement; no scan failure
  mode can reach the claim loop.

## Builder task list (no further design decisions required)

1. **`scripts/jobs/usage-meter.sh`** — add `job_session_dirs`,
   `meter_job_session_total`, `usage_ledger_stage_row`, `usage_footer`
   (per §§ a, c, d). Reuse `_meter_session_total`'s jq/awk dedup pipeline,
   generalized to explicit directories with cutoff 0.
2. **`scripts/jobs/handlers/gardener-claude.sh`** — snapshot before the
   `claude -p` launch; after it exits and **before** the sentinel/teardown
   block, write `<delta>\thandler` to `$GARDEN_USAGE_FILE` when that env is
   set (§ a step 1).
3. **`scripts/jobs/gardener.sh`** — mktemp/rm/export `GARDEN_USAGE_FILE` next
   to the sentinel; take the fallback before-snapshot; after the handler,
   resolve `(tokens, source)` per the § a ladder; on the completion branch
   export `GARDEN_ENGAGEMENT_{ELAPSED,TOKENS,SOURCE}` before calling
   `complete-job.sh`; on the exit-0-unsatisfying and failure branches (and the
   offline-during-completion branch) call `usage-append.sh` subshell-isolated
   with outcome `requeue`/`fail`; clean up the temp file on all paths.
4. **`scripts/jobs/usage-append.sh`** — new standalone CAS appender (§ c).
5. **`scripts/jobs/complete-job.sh`** — inside the retry loop: guarded final
   row append + strip + stamp (§ d). Note the rc=2 idempotence guard.
6. **Tests** — extend the harness's fake `claude` to write session-JSONL
   fixtures (assistant turns with `usage`, duplicated message ids across
   lines): delta correctness across a simulated requeue/resume;
   fallback-layer measurement when the handler is killed; ledger row shape
   for each outcome; footer stamp idempotence (run `complete-job.sh` twice —
   one row, one footer); stripping of a pre-seeded fake footer in the agent
   report; fail-open when `GARDEN_CCUSAGE_LOGDIR` is unreadable and when jq is
   absent (row says `unknown`, completion succeeds).

## Alternatives considered and rejected

- **Time-window delta over the whole log tree** — double-books concurrent
  peers on the shared per-host `~/.claude`; kept only as the *concept* the
  session-scoped delta replaces. (The job spec allowed it as a documented-race
  fallback; session attribution is feasible, so it is not needed.)
- **Agent-authored annotation** (prompt the worker to include its own usage) —
  violates constraints 1/4/5; an agent can misreport, and a rewrite loses it.
- **Cumulative column in the ledger row** — derived state with divergence
  hazards under CAS-rebase retries; sum-on-read is cheap (§ c).
- **Host-local ledger with flush-at-completion** — loses rows when a base is
  engaged on host A but completed on host B; direct journal appends keep the
  ledger complete across hosts at the cost of one bounded best-effort push per
  non-completing engagement (the completing one rides the existing push).
- **Ledger under `jobs/`** — collides with lane lifecycle semantics
  (completion cleanup, `git clean -fd jobs`) and would couple the durable
  record to board state (§ c).
