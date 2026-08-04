# Design: cleric workers, the factored worker spine, the decentralized bid auction, and dollar-normalized reputation

| Created | 2026-07-13 |
| Updated | 2026-07-13 |
| Author  | designer (job `design-cleric-worker-bid-auction-reputation`) |
| Status  | Proposed (gates the two build children of `orch-cleric-worker-system`) |

The maintainer's directive (2026-07-13, refined the same day with the
dollar-normalization requirement): add a **cleric** — a gardener-script-like
worker service that is identical to the gardener but drives **`codex`** instead
of **`claude`**; **factor the common worker spine** so the two kinds cannot
drift apart under maintenance; make clerics and gardeners **compete in a bid
auction** for new work; and have them **develop independent reputations per
model and per thoughtfulness level, as data in the journal**, where a
reputation encodes **merge-worthiness achieved per aggregate dollar (human +
agentic), qualified by the merge-target bar**.

This design is the gate for two serial build children:

1. `build-cleric-and-factor-worker-spine` — §1 (the cleric) + §2 (the spine).
2. `build-worker-bid-auction-reputation` — §3 (the auction) + §4–§5
   (reputation and the thoughtfulness axis).

## Relationship to the prior designs (what carries, what is revised)

Two Proposed designs already cover much of this ground and are **incorporated,
not duplicated**:

- [`gardener-bid-accept-market.md`](gardener-bid-accept-market.md) — the
  bid/accept lifecycle, bids as per-bidder CAS-safe files, reputation as an
  append-only ledger with derived projections, the AMiX objective/subjective
  acceptance framing, and the race-by-default/shadow-first rollout. **Carries
  forward**, with one structural revision: that design awarded bids through a
  central **broker** (a foreman-run scoring pass). This directive requires the
  auction to resolve **deterministically over the journal CAS with no central
  auctioneer** — so §3 below replaces the broker with a **decentralized award
  rule every worker computes identically**, and the accepted claim push stays
  the one serialization point. The market design's `submitted` lane is
  **deferred**: completion and acceptance ride the existing gauntlet/tada
  machinery unchanged (§4.2).
- [`gardener-reputation-bootstrapping.md`](gardener-reputation-bootstrapping.md)
  — effectiveness as a gate, cost as the free variable normalized to dollars,
  cost-per-accepted-job, Thompson sampling for explore/exploit, bootstrapping
  from journal history, the role refiner/consolidator. **Carries forward
  wholesale**; §3.3 makes its Thompson sampling *decentralized* and §4.4
  extends its dollar axis with the inferred **human-review dollar** the
  maintainer's refinement added.

Also load-bearing, and already landed:

- [`provider-model-catalog.md`](provider-model-catalog.md) — the concrete
  Claude + Codex model ids, per-model effort support, the **unified
  thoughtfulness axis** (`minimal < low < medium < high < xhigh < max <
  ultra`), Claude rate-card pricing, and the flagged gap that Codex under
  ChatGPT-plan auth exposes **no per-token dollar price** (§4.4 resolves how
  we price it anyway).
- [`tada-token-accounting.md`](tada-token-accounting.md) +
  [`token-cost-ledger.md`](token-cost-ledger.md) (both Accepted) — the
  deterministic, no-LLM per-engagement token capture and the per-job
  `usage/<base>.jsonl` CostRecord with CLI-computed notional dollars. §4.4's
  **agentic dollar** is exactly that record; this design adds only the
  per-backend capture adapter (§2.3) and the reputation reducer that consumes
  it.
- The parked plan `design-change-review-tool-with-review-metering` — the
  future **measured** human-review-time instrument. §4.4's human-review schema
  is designed so the measured signal replaces the inference **without churn**
  (a `source: inferred|measured` discriminator, raw observables stored).

---

## 1. The cleric: a codex-backed worker

A **cleric** is a worker instance in the same fleet, same board, same
claim/complete lifecycle as a gardener — differing only in the backend CLI its
job handler drives. Per the directive: *identical to the gardener script
service but using `codex` instead of `claude`*.

### 1.1 The codex handler: `handlers/cleric-codex.sh`

Mirrors [`handlers/gardener-claude.sh`](../scripts/jobs/handlers/gardener-claude.sh)
in contract and hygiene. Invoked by the spine as
`$GARDEN_JOB_HANDLER <base> <job-file> <report-out>`; must fill `<report-out>`
and write `$GARDEN_COMPLETION_SENTINEL` iff the run genuinely completed.

- **Invocation.** Non-interactive:

  ```sh
  codex exec \
    --dangerously-bypass-approvals-and-sandbox \
    --skip-git-repo-check \
    -m "$model" \
    -c model_reasoning_effort="$effort" \
    --output-last-message "$report" \
    --json \
    "$prompt"
  ```

  `codex exec` is the headless mode (no approval prompts by construction).
  `--dangerously-bypass-approvals-and-sandbox` is the posture parity of the
  claude handler's `--dangerously-skip-permissions`: the fleet's container is
  the sandbox, and codex's own sandbox would otherwise deny the `git push`,
  `gh`, and network calls a job needs. `--output-last-message` captures the
  final agent message as the report — the analogue of `claude -p`'s stdout.
  The `--json` event stream goes to the handler's stdout capture for
  diagnostics and for the usage adapter (§2.3). Exact flag names verified
  against codex-cli 0.144.3 on `endolin-garden` by the builder before landing
  (the catalog warns the CLI surface is server-resolved and living).
- **Auth.** Via `~/.codex/auth.json` (ChatGPT-plan login, already present on
  the host per the catalog's provenance). The handler preflights
  `codex login status` cheaply on first run per boot and dies with a clear
  diagnostic when unauthenticated — an auth gap must read as a host defect,
  not a job defect.
- **Prompt.** Byte-identical role brief + job spec + worktree note + messaging
  discipline + completion-marker instruction as the claude handler — the
  prompt text is **factored into the spine as a shared template** (§2.2) so
  the two backends cannot drift on injection hygiene or the completion
  contract. External text is data on both paths.
- **Completion signal.** Same contract: `codex` exit 0 **and** the report's
  final line is `$GARDEN_COMPLETION_MARKER` → strip the marker, write the
  sentinel. Exit-0-without-marker requeues, exactly as for claude.
- **Model/effort selection.** From the job's `model:` frontmatter via a codex
  tier map (§2.4), else the role default, else the cleric fleet default
  (`gpt-5.6-terra` at `medium`, the catalog's effective default). Once the
  auction lands, the winning bid's committed arm (§3.2) overrides both.
- **Session resume.** Codex assigns its own session UUID (no
  deterministic-session-id analogue of claude's `--session-id uuid5(base)`).
  The handler parses the session id from the `--json` stream's initial event
  and persists it in a per-base sidecar
  (`$GARDEN_STATE/clerics/sessions/<base>`, survives worktree teardown races,
  removed on completion); a requeue with a live sidecar resumes via
  `codex exec resume <sid>` with the same "you are RESUMING" prompt shape the
  claude handler uses. If resume proves unreliable on the installed CLI, the
  fallback is a fresh session over the preserved per-base worktree (the
  uncommitted work carries the state) — the spine's requeue semantics do not
  depend on backend resume. The builder probes this live and documents which
  branch shipped.
- **Worktree discipline.** Identical: the shared spine helper creates/reuses
  the per-base worktree `$GARDEN_SCRATCH/gardener-wt-<base>` and the handler
  launches codex with cwd inside it. `kill_stale_worktree_handlers` covers the
  codex process tree too (it keys on the worktree path, not the binary name;
  the builder verifies the match pattern catches `codex`).

### 1.2 The cleric service, scaling, and mixed hosts

- **Units.** `garden-cleric@.service` — rendered from the **same source
  template** as `garden-gardener@.service` (§2.2), differing only in the
  substituted worker-kind. Same self-heal wrapper, `KillMode=mixed`, memory
  confinement, and `TimeoutStopSec` drain math.
- **Count.** The journal `hosts/<host>` file gains a `clerics: N` line beside
  `gardeners: N`. `set-workers.sh <kind> <N> [host]` writes it
  (`set-gardeners.sh` becomes a one-line back-compat wrapper for
  `set-workers.sh gardener`). Absent/unparsable `clerics:` is a no-op exactly
  like the gardener rule — only an explicit `clerics: 0` scales to zero.
- **Scaler.** The one `gardener-scaler.sh` tick reconciles **both** pools by
  iterating the kind registry (§2.1): read `gardeners:`/`clerics:` from
  `hosts/<host>`, delegate to `install-units.sh scale <kind> <N>`. No second
  scaler service.
- **Mixed hosts.** A host runs any mix; the pools are independent instance
  namespaces (`garden-gardener@1..N`, `garden-cleric@1..M`) with per-kind
  state dirs (`$GARDEN_STATE/clerics/<id>/journal`, busy/identity markers
  under the kind's namespace). Both kinds claim from the same `jobs/todo/`;
  the push CAS already makes cross-kind racing safe. Deploy quiesce and the
  drain/restore fleet operations enumerate both kinds' busy markers via the
  shared helper (§2.2).
- **Recommended initial sizing:** `clerics: 4` on the leader host (enough to
  accrue reputation data without materially competing for board throughput),
  tunable by the maintainer like any worker count.

### 1.3 Pre-auction claim eligibility (the interim rule)

Between the two build children, clerics claim from the same board by the
existing race. One deterministic filter is needed so a cleric never claims a
job it cannot honor: a job whose `model:` frontmatter resolves in the
**Claude** tier map is gardener-only; one naming a **codex** slug/tier is
cleric-only; an unpinned job is claimable by either kind. This is a small
predicate in `claim-job.sh`'s candidate loop keyed by worker kind (§2.1), and
it is the seam the auction later replaces: under the auction, backend fit is
priced into the bid instead of hard-filtered.

---

## 2. The factored worker spine

The gardener loop is **already** handler-pluggable (`GARDEN_JOB_HANDLER`), so
the spine mostly exists; the factoring makes the remaining incidental
gardener-isms explicit parameters so nothing is duplicated and nothing drifts.

### 2.1 The worker-kind registry

One table, in `common.sh` (the same place `resolve_model_tier` lives), is the
**single point a new kind touches**:

```sh
# worker_kind_field <kind> <field> — the registry. Fields:
#   handler   default job handler path        gardener → handlers/gardener-claude.sh
#                                             cleric   → handlers/cleric-codex.sh
#   provider  reputation/rate-card provider   gardener → anthropic
#                                             cleric   → openai
#   unit      systemd instance template        gardener → garden-gardener@
#                                             cleric   → garden-cleric@
#   count_key hosts/<host> count line          gardener → gardeners
#                                             cleric   → clerics
#   state_ns  $GARDEN_STATE namespace          gardener → gardeners
#                                             cleric   → clerics
```

### 2.2 What is shared (the spine) vs per-kind (the plugs)

**Shared — one copy, parameterized by kind, never forked:**

- `gardener.sh` — the whole loop: claim, per-job `handler-timeout:` budget,
  the `timeout` wrapper and its invariants, transient-vs-real classification,
  elapsed-constancy and deadline-overrun escalation, fleet brake, busy/identity
  markers, graceful SIGTERM drain, the completion-sentinel gate, productive-
  cycle stamping. It grows one knob, `GARDEN_WORKER_KIND` (default
  `gardener`), from which the handler default, clone path, tag, and marker
  namespaces derive via the registry. The filename stays `gardener.sh` (it is
  referenced from units, docs, and tests everywhere; "gardener" remains the
  spine's historical name — a comment at the top says so).
- `claim-job.sh` / `complete-job.sh` / `reaper.sh` / `self-heal-run.sh` — the
  board protocol, kind-agnostic. `claim-job.sh` gains the §1.3 eligibility
  predicate and stamps `worker_kind:` into the claim metadata (so tada
  reports, usage rows, and reputation events know who did the work).
- The **systemd template source**: `scripts/systemd/garden-worker@.service.in`
  with a `@WORKER_KIND@` placeholder, rendered by `install-units.sh` (which
  already substitutes `@GARDEN_ROOT@`) into `garden-gardener@.service` and
  `garden-cleric@.service`. The two checked-in unit files are deleted in favor
  of the one source; the rendered names keep the per-kind instance namespaces.
- The **handler prompt template** — the role brief + job spec + worktree note
  + messaging discipline + completion-marker text, today inlined in
  `gardener-claude.sh`, moves to a shared builder function
  (`worker_job_prompt <base> <jobfile> [resume]` in `common.sh` or a
  `handlers/prompt-common.sh` sourced by both). The injection-hygiene and
  completion-contract text exists in exactly one place.
- The per-base worktree lifecycle (`ensure_worktree`,
  `kill_stale_worktree_handlers`, teardown-on-completion, transcript spool
  hook) — extracted from `gardener-claude.sh` into shared helpers both
  handlers call.
- Scaler + `install-units.sh scale <kind> <N>` + `set-workers.sh` (§1.2).

**Per-kind — the whole backend surface, behind the handler contract:**

- The handler script itself: CLI invocation, model/effort flag mapping,
  session-resume mechanics, completion-marker check (via the shared helper).
- The **usage adapter** (§2.3).
- The provider's rate-card rows and tier map (§2.4).

**Adding a third backend** (say a `friar` on some future CLI) is then: one
handler script implementing the contract, one registry row, one rate-card
block, one tier map, `hosts/<host>` gains `friars: N`. No spine file is
copied or forked.

### 2.3 The handler contract, extended with usage output

The contract today: `handler <base> <jobfile> <report-out>`, sentinel via
`$GARDEN_COMPLETION_SENTINEL`. It gains one output so the spine stays
backend-agnostic about token accounting:

- The spine exports `GARDEN_USAGE_OUT=<path>`; the handler writes one JSON
  object of **normalized usage**: `{provider, model, thoughtfulness,
  input_tokens, output_tokens, cached_input_tokens, reasoning_tokens?}`.
- `gardener-claude.sh` fills it from the claude session-transcript delta the
  accepted [tada-token-accounting](tada-token-accounting.md) design already
  specifies (this *is* that design's `GARDEN_USAGE_FILE` primary, renamed to
  the kind-neutral contract; the gardener-side snapshot fallback stays
  claude-specific inside the handler).
- `cleric-codex.sh` fills it from the `codex exec --json` event stream's token
  usage events (`turn.completed` usage counts), falling back to the
  `~/.codex/sessions/**/rollout-*.jsonl` files. The builder verifies field
  names on the installed CLI.
- The spine (and `complete-job.sh`) treats the file as opaque normalized
  usage: it appends the CostRecord row to `usage/<base>.jsonl` per
  [token-cost-ledger](token-cost-ledger.md), computing dollars from the rate
  card (§4.4). Fail-open: absent/unparsable usage never blocks completion; the
  row records `usage: unknown` and the reputation reducer treats the sample as
  cost-censored (§4.5).

### 2.4 Model selection per kind

`resolve_model_tier`/`role_default_model` are Claude-shaped. They become
provider-scoped:

- `resolve_model_tier anthropic <tier>` — today's map unchanged.
- `resolve_model_tier openai <tier>` — new: `terra → gpt-5.6-terra`,
  `luna → gpt-5.6-luna`, `frontier → gpt-5.5`, `mini → gpt-5.4-mini`
  (ids per the catalog §2; re-verified live before pinning).
- `role_default_model <kind> <role>` — per-kind role defaults. Gardener side
  unchanged (designer/builder → opus). Cleric side: designer/builder →
  `gpt-5.6-terra` at `high`, all other roles → `gpt-5.6-terra` at `medium`.
  Mirrored in [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md),
  which remains the canonical prose map.

Thoughtfulness (`effort:` job frontmatter, optional) resolves on the unified
axis (catalog §3) and each handler maps it to its CLI's flag, normalizing an
unsupported level down to the model's nearest supported one **and recording
the normalized level** in the usage output — the catalog's keying rule, so
arms stay apples-to-apples.

---

## 3. The bid auction

### 3.1 Requirements, restated as invariants

1. **Deterministic and CAS-safe on the existing substrate.** Every transition
   is a fast-forward push to `origin/journal2`; the accepted claim push stays
   the single serialization point. No lock service, no central auctioneer, no
   process whose death can strand or double-award a job.
2. **No double-award** — structurally impossible, not merely unlikely.
3. **Degrades to the current race** when zero or one worker bids, and is
   bypassable per job for latency-critical work.
4. **No starvation / rich-get-richer**: cold arms (new models, new
   thoughtfulness levels, new kinds) still get work; idle capacity is used.

### 3.2 The mechanism: open bidding window, deterministic award rank, staged claim eligibility

The auction inserts a **bounded bid-collection window** between post and
claim, then resolves by a rule **every worker computes identically from the
same committed data** — so "who awards" is *everyone and no one*: the award is
a pure function of the journal, and the claim push enforces it.

**Posting.** A job opts in via `market: bid` frontmatter (producers add it per
the rollout phase, §6). It carries `bid_window: <seconds>` (default from
journal config `config/auction.md`, recommended **120 s**). A job without
`market: bid` — including everything `priority: urgent` — is claimed by
today's race, untouched.

**Bidding.** A worker's between-claims loop, on seeing an open-window `bid`
job it is eligible for, writes **its own bid file** —
`jobs/bids/<base>/<kind>-<host>-<id>.md` — and pushes. Per-bidder filenames
mean bids never contend with each other (the market design's §1.1 argument);
contention with unrelated journal pushes is the ordinary retry-with-backoff.
A bid is cheap (no LLM: computed by the deterministic bid function below) and
carries:

```yaml
---
bidder: <kind>-<host>-<id>          # e.g. cleric-endolin-garden-3
kind: gardener | cleric
arm:                                 # the arm this bid COMMITS to run
  provider: anthropic | openai
  model: <concrete id>
  thoughtfulness: <unified level>
work_class: <the job's class, as the bidder computed it (§4.3)>
posterior:                           # the arm's reputation summary at bid time
  n: <samples>  accepts: <n>  mean_dollars: <x>  m2: <sum of squared deviation>
bid_dollars: <expected aggregate dollars, point estimate>
bid_at: <iso8601>
---
```

The `posterior` block is **verified, not trusted**: it must match the arm's
committed projection (§4.5) at the bid's parent commit, or the bid is ranked
as if cold. A worker bids its **best arm** for the job's work-class — it
evaluates each `(model, thoughtfulness)` it can run through the bid function
and submits the strongest single bid (one bid per worker instance).

**The award rule (pure function, computed by everyone).** At window close
(`posted_at + bid_window` — `posted_at` is in the job file, so the deadline is
a shared constant; workers compare against their own clocks, and skew is
tolerated by the staged eligibility below), every worker sorts the bid set
by **deterministic Thompson draw**:

1. For each bid, draw one sample from the arm's cost posterior
   (normal-approximate from `n/mean/m2`, floored variance for thin arms; a
   cold arm — `n` below `config/auction.md`'s `cold_n`, default 5 — uses the
   wide cold-start prior from
   [gardener-reputation-bootstrapping §4](gardener-reputation-bootstrapping.md)).
   The draw is seeded by `hash(base ‖ bidder ‖ arm)` — no `Math.random`; the
   same journal state yields the same draw on every host, so the ranking is
   **reproducible and auditable** from the journal alone.
2. Rank ascending by drawn expected aggregate dollars; break exact ties by
   `hash(base ‖ bidder)` — which also spreads load uniformly across instances
   of the same arm, since same-arm bids are otherwise identical.

**The claim (the award made real).** The rank-1 bidder performs the ordinary
`claim-job.sh` push (todo→doin), stamping `awarded_bid: <bidder>` and the
committed arm into the claim metadata. The CAS is untouched: whoever's push is
accepted owns the job, exactly once. Protocol discipline — only rank 1 pushes
at close — is what makes the award land on the intended winner; the CAS is
what makes even a protocol violation safe (a rogue early push is a mis-award,
never a double-award or a lost job).

**Liveness (a dead winner must not strand the job).** Eligibility widens in
stages: at close, rank 1 may claim; at close + `grace` (default 30 s), ranks
1–2; at close + 2·grace, ranks 1–3; at close + 3·grace, **anyone** — the
auction has fully degraded to the race, so the worst case for a
fully-distracted fleet is today's behavior plus a bounded delay. Each stage is
computed from the same shared timestamps, so no coordination is needed; the
reaper needs no new state (an awarded-then-orphaned claim is an ordinary stale
`doin/` entry).

**Degeneration.** One bid → it is rank 1 by construction and claims at close
(effectively today's claim with a `bid_window` delay). Zero bids → the first
worker to notice an expired window claims race-style (the anyone stage,
reached immediately since there is no rank list). `market: race` or absent →
the window never exists.

**Cleanup.** `complete-job.sh` sweeps `jobs/bids/<base>/` when it retires the
job's other board state; the winning and losing bid summaries are folded into
the reputation event (§4.5) as the audit trail.

### 3.3 Why this preserves explore/exploit and prevents starvation

The award rule *is* Thompson sampling, decentralized: exploitation because a
confidently-cheap arm almost always draws low; exploration because a cold or
uncertain arm's wide posterior occasionally draws lowest and wins a real job —
in proportion to uncertainty, with no hand-tuned bonus and no broker. The
rich-get-richer failure is structurally countered: a new model or a new cleric
arm starts wide, wins its share of measurements, and either sharpens into a
winner or fades. Two guards from the bootstrapping design carry over: the
exploration budget throttles toward pure exploit when `usage-meter.sh`
approaches the quota cap, and replay seeding (§4.6) pre-warms arms so
exploration spends less on hopeless draws.

Worker-instance starvation (as opposed to arm starvation) is handled by the
tie-break hash: instances advertising the same arm win uniformly at random per
job. Idle capacity self-serves: a worker that lost an auction goes straight
back to the board — the loop's next tick sees the next job.

### 3.4 The cost, stated honestly

The window adds `bid_window` (+ grace stages if the winner is dead) of latency
per opted-in job, and one extra push per bidder per job. That is the price of
selection; it is why `market: bid` is per-job opt-in with `race` remaining for
urgent and mechanical work (the market design's §1.4 analysis stands). Bids
are deterministic and LLM-free, so the bidding phase costs no tokens.

---

## 4. Reputation as journal data

### 4.1 What a reputation encodes

Per the directive: **merge-worthiness achieved per aggregate dollar (human +
agentic), qualified by the merge-target bar.** Formally, per arm and
work-class: the posterior over **aggregate dollars to a merge-worthy
artifact**, where effectiveness is the acceptance gate (gauntlet pass /
un-draft / merge — binary at the margin, per the bootstrapping design §1.1)
and the dollars amortize failed attempts:

```
E[aggregate $ to merge-worthy | arm, work_class, target]
   ≈ (mean aggregate $ per attempt) / (acceptance rate)
```

**The bid follows from this** (§3.2's `bid_dollars` is exactly this
expectation): the auction selects the combination cheapest-to-merge in true
dollars — human plus agentic — not cheapest per token.

### 4.2 The arm key

```
(worker_kind, provider, model, thoughtfulness) × work_class × target
```

- `worker_kind` and `provider` are nearly redundant today (gardener⇔anthropic,
  cleric⇔openai) but are kept distinct: the *kind* carries the harness
  (prompting, resume mechanics, tool discipline) and the *provider/model*
  carries the cognition; a future kind could drive either provider.
- `thoughtfulness` is the **normalized** unified level actually honored
  (catalog §3 keying rule) — independent reputations per level, per the
  directive.
- `target` is the merge bar the acceptance was judged against: `llm`,
  `master`, `main2` (garden-internal work), etc. The `llm` bar is cheaper than
  upstream `master`; a reputation is only comparable within a bar, so the key
  includes it (cross-ref the parked
  `design-change-review-tool-with-review-metering` plan, which meters review
  cost per target).

### 4.3 Work-class: classifying each job posting

Reputation is learned per work-class so "cheap at fixes" and "cheap at
designs" are different facts. Classification is **deterministic, no LLM, at
post/claim time** from data the job already carries:

```
work_class = <role-or-verb class> [ ":" size ]
  class: design | build | fix | shepherd | weave | triage | doc | ops | other
         (from the job's `role:` frontmatter, else the recognized imperative
          verb the comment-watcher already extracts, else `other`)
  size:  s | m | l   (byte-length buckets of the job body; a crude but
         deterministic complexity proxy — refine later, never with an LLM in
         the claim path)
```

A producer may override with an explicit `work-class:` header. A finer
LLM-assisted classifier (risk, novelty) is a deferred enhancement and would
run at **post time by the producer** (off the claim path) so the auction stays
deterministic.

### 4.4 The dollar model (the maintainer's 2026-07-13 refinement)

Every reputation event's cost is **aggregate dollars = agentic $ + human $**,
each recorded with its raw observables so the derivation can be re-run.

**Agentic dollars — measured.** The per-engagement CostRecord
(`usage/<base>.jsonl`, [token-cost-ledger](token-cost-ledger.md)) already
carries the four token classes and notional dollars for claude; §2.3's usage
adapter extends capture to codex. Dollars = Σ tokens × the provider's
rate-card price, summed over **every engagement of the base** (requeues and
resumes included — sunk cost is real cost). The rate card
(`reputation/rate-card.md`, journal config, dated/versioned) holds:

- Anthropic rows: the catalog §1 prices (Fable $10/$50, Opus $5/$25,
  Sonnet $3/$15, Haiku $1/$5 per MTok in/out; cache classes per the ledger
  design).
- OpenAI rows: **notional API list prices** for the codex models. The ChatGPT
  plan meters no per-token dollars (catalog §2), so — exactly as the
  bootstrapping design resolved for the flat Claude Max subscription — we
  price tokens at the provider's public API rates to keep arms *comparable*,
  and the same axis settles real invoices if a metered arm ever bids. The
  concrete gpt-5.x prices are sourced by the builder from OpenAI's published
  API pricing at build time and recorded (dated) in the rate card; **absent a
  published price for a plan-only model, the maintainer sets a provisional row
  and the ledger marks those dollars `price_basis: provisional`** (open
  decision D5).

**Human-review dollars — inferred at ~$125/hr, until measured.** The interim
proxy: infer the reviewer's **active review time from the depth of reviewer
commentary in aggregate** across every review the change received, then price
at the configured rate. The reducer (§4.5) computes, per change (PR), from the
GitHub data the fleet already reads:

```
observables (stored raw, per review round, per target):
  rounds          review rounds (reviews + change-request cycles)
  comment_words   Σ words across reviewer comments/threads (maintainer-authored)
  threads         distinct review threads opened
inferred_active_minutes = base_min × rounds + comment_words / words_per_min
                          (defaults: base_min 5, words_per_min 20 — a reviewer
                           reads far more than they write; both are rate-card
                           config, not code)
human_dollars = inferred_active_minutes / 60 × hourly_rate   (default $125/hr)
```

The event stores `human_review: {source: inferred, observables…, minutes,
dollars, rate, formula_version}`. When the review-metering tool (the parked
plan) ships, it writes the same shape with `source: measured` and its own
observables; the reducer **prefers measured over inferred for the same change**
and nothing else changes — the swap-in-without-churn the directive requires.
Maintainer-attention events outside formal review (inbox interventions,
clarifying rounds — already journaled) are counted as rounds at `base_min`
each, per the bootstrapping design's maintainer-attention-is-a-cost
resolution.

**Not counted against the arm:** panel-juror and auction overhead (the
market's cost of judging/selecting, per the market design's §3.4 separation) —
booked, but to the market, not the bidder.

### 4.5 Journal schema and CAS-safe update

The prior designs' event-log + derived-projection split carries forward; every
write surface is single-writer:

```
reputation/rate-card.md                       config: per-provider token prices,
                                              review-inference constants, $125/hr
config/auction.md                             config: bid_window default, grace,
                                              cold_n, exploration throttle
reputation/events/<base>.md                   ONE event per completed base —
                                              written by complete-job.sh (own-
                                              basename single writer, rides the
                                              existing completion push)
reputation/pending/<base>.md                  written at completion when the
                                              acceptance verdict is not yet known
                                              (PR still in gauntlet/review);
                                              finalized by the reducer
reputation/arms/<kind>/<provider>/<model>/<thoughtfulness>/<work_class>@<target>.md
                                              derived projection: n, accepts,
                                              mean_dollars, m2, last_event —
                                              recomputed by the reducer ONLY
```

- **The event** (`reputation/events/<base>.md`) records: the arm, work-class,
  target, `accepted: true|false|pending`, the agentic-dollar rollup (from
  `usage/<base>.jsonl`), the human-review block (§4.4), attempts/requeues,
  duration, the winning + losing bid summary (audit trail), `source:
  live|replay|historical`.
- **The reducer** is a **leader-only timer** (`garden-reputation-reducer`,
  sibling of the foreman): it finalizes `pending/` events by reading the
  acceptance outcome (PR merged/un-drafted/closed; gauntlet verdict in the
  journal; maintainer override messages), computes the human-review
  observables from the GitHub review data, and recomputes the touched arm
  projections. It is the **only writer of `arms/`**, so projections never
  contend; it is deterministic plain code (its only external reads are `gh`
  API data already gated by the monitoring safety constraint — reviewer text
  is *counted*, never fed to an LLM). Bidders read `arms/` directly; a bid's
  self-asserted posterior is verified against it (§3.2).
- **Acceptance signals**, in precedence order: maintainer override (a journal
  message naming the base/PR) > merge/un-draft of the PR at its target >
  gauntlet/panel verdict > reap-doomed/abandoned (counts as rejected, with
  its sunk cost). A garden-internal job with no PR (like this design) is
  accepted on un-doomed tada plus, when contested, maintainer word.
- **Cost-censored samples** (usage capture failed): count toward the
  acceptance rate, excluded from the dollar mean, flagged in the projection
  (`censored: n`) so a systematically-censoring backend is visible. The two
  measurements are independent, and the projection keeps them apart: `attempts`
  / `accepts` count **every** event, while `mean_dollars` / `m2` summarize only
  the `attempts - censored` **cost samples**. `mean_dollars` stays
  cost-per-accepted by dividing the cost-observed per-attempt mean by the
  full-population acceptance rate. The bid draw is gated on **cost** samples,
  not attempts: an arm with fewer than `cold_n` of them is cold however many
  attempts it has, so a never-priced arm draws the wide prior (amortized by its
  measured acceptance rate) rather than reading its zeroed mean as a $0
  posterior and winning every auction on price. Today that is nearly the whole
  fleet — only the `claude -p` handler captures a provider-computed
  `total_cost_usd`; codex, Kimi and Ollama runs are all cost-censored — so
  keeping acceptance learnable under censoring is what the arms actually
  measure until the ledger widens.

### 4.6 Bootstrapping

Per [gardener-reputation-bootstrapping §2](gardener-reputation-bootstrapping.md),
unchanged in substance:

- **Historical seeding** (free): walk existing `tada/` + `usage/` +
  transcript records; every past job yields `(work_class, arm, accepted,
  dollars?, duration)` with `source: historical`. Claude arms only — clerics
  have no history, which is correct: they start cold and wide, and the auction
  explores them.
- **Replay seeding** (paid, bounded): the contemporary-replay harness warms
  specific thin arms (notably each codex model × thoughtfulness on `build`
  and `fix` classes) before the auction goes live, `source: replay`, weighted
  below live evidence.

---

## 5. The thoughtfulness axis

- **Range:** the unified ladder from the catalog §3; per-arm reputations at
  each level are independent by construction (§4.2).
- **Who chooses:** under the auction, **the bid does** — a worker evaluates
  its candidate `(model, thoughtfulness)` pairs against the job's work-class
  and bids the strongest, committing to run at that level (§3.2). The market
  thereby *learns* the cheapest adequate thoughtfulness per work-class instead
  of anyone hand-tuning it: if `medium` merges as reliably as `xhigh` on
  `fix:s` jobs, its arm is strictly cheaper and wins.
- **Pre-auction / race jobs:** the job's optional `effort:` header, else the
  role default (`high` for designer/builder, `medium` otherwise), normalized
  per model support and recorded as-honored.

---

## 6. Rollout, degradation, and safety

Phased, additive, race-preserving — the market design's §6 discipline:

1. **Build child 1** lands the cleric + spine. Behavior change: clerics exist
   and race-claim eligible jobs (§1.3 filter). Rollback: `clerics: 0`.
2. **Shadow reputation** (start of build child 2): `complete-job.sh` writes
   events, the reducer builds projections, the bulletin surfaces per-arm
   `E[$ to merge-worthy]` — **no behavioral effect**. Historical seeding runs
   here.
3. **Auction opt-in**: producers stamp `market: bid` on `design` and
   `doc`/`triage`-class jobs first (differentiation matters, latency doesn't).
   Watchers/urgent/mechanical jobs stay `race`.
4. **Widen by evidence**: flip more producers to `bid` where the shadow data
   shows selection buying real dollars. `race` remains permanently for urgent
   work and as the degradation floor of every auction (§3.2 liveness).

Safety properties preserved at every phase: the push CAS is the only
serialization point; the reaper's requeue/doom machinery is untouched (an
awarded claim is an ordinary claim); a wedged auction degrades to the race in
`bid_window + 3·grace`; reputation is append-only data that is harmless if
ignored.

---

## 7. Open decisions (surfaced to the maintainer, with recommendations)

Posted to the maintainer inbox alongside this design; the build children
proceed on the recommended defaults unless overridden.

- **D1 — Replace or augment the race?** *Recommend augment (opt-in `market:
  bid`, race default, widen by evidence; race permanent for urgent work).*
  Replacing outright adds `bid_window` latency to every watcher-posted job and
  removes the degradation floor.
- **D2 — Bid window and award mode.** *Recommend 120 s window + 30 s grace
  stages, deterministic-Thompson award.* Alternatives: instant award (first
  eligible bid wins — cheaper latency, no selection) or pure argmin (no
  exploration → rich-get-richer).
- **D3 — Reputation acceptance signal.** *Recommend the §4.5 precedence:
  maintainer override > merge/un-draft per target > gauntlet verdict >
  doom/abandon = rejected.* Alternative: gauntlet-only (cleaner but blind to
  post-gauntlet review cost, which is exactly the human-dollar signal).
- **D4 — Human-review inference constants.** *Recommend base 5 min/round +
  words/20 wpm at $125/hr, all in `reputation/rate-card.md`.* These are
  admittedly crude; they are config, not code, and the measured signal from
  the review-metering tool supersedes them per-change on arrival.
- **D5 — Codex dollar basis.** *Recommend notional OpenAI API list prices in
  the rate card (dated, `price_basis: list|provisional`).* Alternative:
  amortize the ChatGPT-plan fee over measured plan usage — truer to the bill
  but unstable and incomparable across arms.
- **D6 — Starvation / exploration budget.** *Recommend Thompson's natural
  exploration, throttled toward exploit near the `usage-meter.sh` quota cap
  (bootstrapping §4.2); no per-arm quota floor.* Alternative: a guaranteed
  minimum award share per cold arm (simpler to reason about, wastes jobs on
  hopeless arms).
- **D7 — Initial cleric count.** *Recommend `clerics: 4` on the leader host.*
- **D8 — Work-class granularity.** *Recommend the deterministic
  role/verb × size classes (§4.3) now; LLM-assisted risk/novelty classing at
  post time later.*

## 8. What this decides, and what it defers

**Decides:** the cleric as a registry-row worker kind on a single factored
spine (§1–§2, build child 1); the handler contract extended with normalized
usage output (§2.3); the decentralized deterministic-Thompson bid auction over
the unchanged push-CAS, with staged degradation to the race (§3, build child
2); reputation as journal data keyed
`(kind, provider, model, thoughtfulness) × work_class × target`, valued in
**aggregate dollars (measured agentic + inferred human at ~$125/hr,
measured-swaps-in)** per merge-worthy artifact (§4); thoughtfulness chosen by
the bid (§5); the phased race-preserving rollout (§6).

**Defers:** the `submitted` lane and formal competitive builds (market design
§5); the role refiner/consolidator activation (bootstrapping §5–§6 — the arm
space here is bounded by the model catalog, so the cap is not yet binding);
LLM-assisted work-classing (D8); the measured review-time instrument (the
parked review-metering plan); subcontracting and the meta-machine (market
design §5.1–§5.2).

## References

- [`gardener-bid-accept-market.md`](gardener-bid-accept-market.md),
  [`gardener-reputation-bootstrapping.md`](gardener-reputation-bootstrapping.md)
  — the incorporated market + measurement designs (broker superseded by §3).
- [`provider-model-catalog.md`](provider-model-catalog.md) — models, effort
  ladders, prices, the unified thoughtfulness axis.
- [`tada-token-accounting.md`](tada-token-accounting.md),
  [`token-cost-ledger.md`](token-cost-ledger.md) — the agentic-dollar capture.
- [`job-board.md`](job-board.md), [`skills/job-board/SKILL.md`](../skills/job-board/SKILL.md)
  — the CAS substrate the auction rides.
- `scripts/jobs/gardener.sh`, `scripts/jobs/handlers/gardener-claude.sh`,
  `scripts/jobs/gardener-scaler.sh`, `scripts/jobs/set-gardeners.sh`,
  `scripts/systemd/garden-gardener@.service` — the spine being factored.
- Journal plan `design-change-review-tool-with-review-metering` — the future
  measured human-review signal §4.4 is shaped to receive.
