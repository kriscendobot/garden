# Garden telemetry, metric surfacing, and autonomous anomaly response

| Created | 2026-08-04 |
| Author  | designer (job `design-garden-telemetry-and-anomaly-response`) |
| Status  | Proposed (maintainer-commissioned, kriskowal 2026-08-04; changes no runtime behavior — this job lands the document only) |

The garden has a rich detection substrate — `watchdog-notice.sh`, `usage-meter.sh`,
`root-repo-guard.sh`, `identity-drift-guard.sh`, the per-repo watchers, the
`mentor.sh` self-healing responder — and **still went blind repeatedly** over
2026-08-01/04 (the ten incidents in the directive, cited below as `#1`…`#10`). The
gap is not more detectors. The gap is that the garden has no **derived, quantified,
published view of its own vital signs**, no **deterministic threshold layer** over
them, and no **coalesced response ladder with a ceiling**. Every existing detector
watches one condition in isolation; none of them can say "completions went to zero
while claims continued" (#1), "a third of panels reviewed the wrong repo" (#5), or
"this host has been dead for three days" (#6), because those are *ratios and
liveness deltas across the garden*, not single-unit failures.

This design adds that layer. It is deliberately built as **derived views over the
substrate that already exists**, never a parallel metrics store — the directive's
central warning, and the lesson of every telemetry system that drifted from the
thing it measured.

---

## Decision

1. **Metrics are DERIVED, not a new write path.** The vital signs are recomputed
   from the existing fact tables — `usage/*.jsonl` (the CostRecord ledger),
   `reputation/`, the `jobs/` board, `sysop-log/`, and host-local process state —
   by a deterministic, LLM-free reducer, exactly as `cnf-backlog-triple.py` derives
   the backlog measure from the board and never persists a counter. Production
   consumes **zero agent tokens**: the reducer must not invoke an agent, construct
   a prompt, call a language-model API, or receive model credentials. **No new
   per-event metric records are written to the journal.** This is the single most
   important decision; it is what keeps the system from becoming the incident it is
   meant to catch.

2. **Collection is a standing systemd timer, NOT a gardener job.** The one thing a
   telemetry system must never do is go blind exactly when the pipeline it measures
   dies. Because `gardener.sh` exits on the drain check *before* its bus read, any
   collector built as a claimed job observes nothing on a drained or collapsed host
   — the precise failure mode of #1. Collection therefore rides its own
   `garden-vitals` timer (the `sysop.sh` precedent: a standing per-host daemon,
   independent of the job pipeline, that keeps running under drain).

3. **Three tiers, one published shape.** Per-tick raw metrics stay **host-local and
   unpublished** (a local ring buffer). Each host publishes ONE small
   rewrite-in-place **heartbeat** file to the journal. The **leader** aggregates all
   heartbeats into ONE **`vitals/garden.json`** snapshot. Total journal footprint:
   `N heartbeats + 1 snapshot`, each overwritten in place on a coarse cadence — a
   bounded cost, not per-tick bloat.

4. **Detection is deterministic threshold code; response coalesces and has a
   ceiling.** A leader-only evaluator applies fixed thresholds to `garden.json` and
   drives the existing `watchdog-notice.sh` coalescing path (one updating notice per
   condition, `notice_count`, not N messages). Autonomous *action* is confined to
   the **closed `sysop` vocabulary** on the garden's own workers (scale, drain,
   reset, restart) plus notices. Everything that touches **code, an external
   surface, the deployed tree, or identity** is **detect-and-page only** — the
   boundary drawn in § What must NOT be automated.

5. **Surfacing extends `docs/bulletin/`.** The bulletin already renders `journal2`
   state without auth; a "Vitals" panel reading `vitals/garden.json` is one more
   read-only view, not a new app or backend.

The build is larger than one increment. § Build phasing proposes a four-phase split;
phases 3–4 (detection and response) are the risky part and deserve their own review
before implementation.

---

## What already exists — the reconciliation

Before proposing anything, the explicit accounting the directive demands: which
existing artifact becomes substrate, and which (if any) is superseded.

| Existing | Role in this design |
| --- | --- |
| `usage/*.jsonl` (CostRecord ledger, [token-cost-ledger.md](token-cost-ledger.md)) | **Primary fact table.** Every throughput/cost/doom vital derives from it. Widened by two fields (§ The one write-path change). Not superseded. |
| `reputation/` (2145 per-arm outcomes) | **Fact table** for yield-per-family (#9). Read-only input. Not superseded. |
| `panel-runs/`, `review-misses/` | **Fact table** for review-quality vitals. Read-only input. Not superseded. |
| `sysop-log/`, `cursors/` | **Liveness input** (#6): a host's sysop-log freshness and cursor advance are liveness signals. Not superseded. |
| `watchdog-notice.sh` (coalesced, `notice_count`, `--recovered`) | **Rungs 0–1 of the response ladder verbatim.** The evaluator calls it; it is not reimplemented. |
| `usage-meter.sh` (weekly quota gate) | **Untouched.** It *gates*; this system *measures*. The ledger already feeds the gate; the vitals reducer reads the same tokens for a different view. Not superseded. |
| `root-repo-guard.sh` (origin / HEAD / gc.log invariants, 30 min) | **Extended, not replaced:** add worktree-cleanliness as a fourth invariant (#4) and export deploy-lag as a vital. Its three current invariants stay. |
| `identity-drift-guard.sh`, `upgrade-monitor.sh`, per-repo watchers | **Liveness/lag inputs.** Their signals become vitals; the scripts stay. |
| `mentor.sh` + `handlers/mentor-claude.sh` (LLM self-healing, 30 min) | **Complement, not replaced.** mentor reacts to *log warnings* with a model and can propose code fixes; vitals reacts to *quantified thresholds* deterministically and never proposes code. A persistent vitals anomaly may *post a mentor-targeted job*; vitals never does mentor's diagnostic work, and mentor never does vitals' measurement. (§ Division of labor with mentor.) |
| `docs/bulletin/` (auth-free Pages reader) | **The surfacing surface.** One new panel. |

A design that invents `metrics/*.jsonl` alongside all of the above is the failure
mode the directive names. This design writes **no new fact records**; it writes one
heartbeat and one snapshot, both derived and both rewrite-in-place.

---

## The vital signs

A small, defensible set. Each is justified by naming the incident it would have
caught and how fast. Resisting a large dashboard is itself a design goal: every
metric below is one someone would act on, and the ones that are merely *interesting*
were cut.

Windows are trailing (1 h / 6 h) with **debouncing** — a threshold must hold for N
consecutive publish ticks before it escalates, so a single 3 a.m. zero does not page.

| # | Vital sign | Derivation (all deterministic, no LLM) | Catches | Threshold shape |
| --- | --- | --- | --- | --- |
| V1 | **completion_rate** | `tada` rows in `usage/` per hour, 1 h & 6 h | **#1** silent throughput collapse | `0` completions **while claims > 0** over 1 h ⇒ *collapse* (page). This alone names #1 in one tick. |
| V2 | **claim→completion conversion** | `tada` ÷ claims over 6 h (claims from board claim frontmatter / journal claim entries) | **#2** claimable-but-unrunnable board | conversion `≈ 0` with claims `> 0` ⇒ *handler-refusing-claims* (notice→page). |
| V3 | **doom_rate by signature** | park + poison notices per signature ÷ claims, 6 h, grouped by park signature | **#3**, **#8** | any single signature > X% of outcomes ⇒ named-failure notice keyed on that signature. |
| V4 | **elapsed / applied-budget distribution** | p50/p95 of `elapsed_s ÷ applied_budget_s` from the widened ledger row (§ below) | **#3** the lying `deadline-overrun` | a mass near `0` (deaths in seconds) tagged `deadline-overrun` ⇒ *misclassified-cap-death* notice. |
| V5 | **deploy_lag_commits** + **root_worktree_dirty** per host | `root-repo-guard` exports commits-behind and a dirty-tree bool | **#4** stalled deploy reported "healthy" | lag > K commits **or** dirty for > T hours ⇒ *deploy-stalled* notice→page. |
| V6 | **host_liveness** | age of each host's published heartbeat; sysop-log tick age; **board-credited workers vs heartbeat-reported live workers** | **#6** a host dead 3 days still credited 9 gardeners | heartbeat stale > 2× publish interval ⇒ *host-presumed-dead*; credited≠live ⇒ *ghost-workers*. |
| V7 | **backend_probe_streak** | the scaler's per-backend consecutive-probe-failure counter, surfaced | **#8** Fireworks suspended, streak 1855 unseen | streak > S ticks ⇒ *backend-down* notice→page. |
| V8 | **board_depth by gate + plan-family composition** | counts per `todo/doin/blocked/plan`; plan grouped by role/basename-prefix | **#9** board swamped, general depth | any family > F% of `plan/` ⇒ *board-family-flood* notice. |
| V9 | **yield_per_family** | landed/accepted outcomes ÷ jobs posted, per family, from `reputation/` over a long window | **#9** 85 retro jobs, ~85% dismissed | yield < Y over ≥ N jobs ⇒ *family-yield-low* notice recommending the maintainer throttle that producer (recommend, never auto-retire — § non-goals). |

**Adjacent, not a garden vital: synthetic external probes (V10).** #10 (a TLS change
that passed its own 5/5 DoD but took GitHub-login and SIWE down) is *not* observable
from the garden's internal state — nothing the garden does produces a signal, because
the break was in a production surface the garden merely *hosts*. It needs a distinct
mechanism: a small **synthetic-check registry** of named external assertions
("GitHub-login on `*.minion.town` returns 200", "SIWE handshake completes"), each a
deterministic probe on a timer. A failing probe is **page-only** and **never
auto-remediated** (§ non-goals): the responder must not touch a live external
surface. This is deliberately scoped as its own small mechanism, adjacent to the
garden vitals, because it watches *what the garden operates*, not *how the garden
runs*.

**Why not more.** Rejected as dashboard-not-action: per-role token histograms (the
ledger already answers this on demand via `cost.sh`); per-juror agreement matrices
(a `panel-runs` analysis, not a real-time vital); queue-wait latency percentiles
(interesting, but no incident turned on it). The rule applied: *if no 2026-08-01/04
incident turned on the metric, it is a report, not a vital.*

### The panel-repo bug (#5) is a consistency assert, not a threshold

#5 — `gardening/panel.sh` naming seats "PR #<n>" so ~9/28 juror seats resolved the
number against the ambient garden repo — is a **correctness bug**, not a metric that
drifts. No threshold catches it; a **deterministic invariant assert** does. This
design adds a small class of **configuration-consistency checks** (run in the
detector self-verification pass, § below): assert that every juror seat in a live
panel resolves its PR reference against the *project* repo, that every scheduled
unit that should be leader-only is gated, that every expected detector heartbeat is
fresh. These asserts are the same shape as `root-repo-guard`'s invariant checks —
plain code, no threshold, no LLM — and they are where "a third of every panel
reviewing the wrong repository, with no signal" becomes a signal. The *fix* to
`panel.sh` is a separate follow-up; this design makes the class of bug detectable.

---

## The one write-path change: widen the CostRecord (#3)

The single addition to any write path. The CostRecord in `usage/<base>.jsonl` today
records wall-clock but not the **budget actually in force**, so #3's lie —
`deadline-overrun` asserting "elapsed≈GARDEN_HANDLER_TIMEOUT=2400s" for a job that
declared 7200 and died in 1.5 s to a cap rejection — is *unrecoverable from the
data*. Two fields close it, added to the row `complete-job.sh` / `usage-append.sh`
already write (no new file, no new cadence):

- `applied_budget_s` — the `GARDEN_HANDLER_TIMEOUT` value **actually in effect** for
  that engagement (not the documented default).
- `park_signature` — the signature the job was parked under, when the outcome is
  `requeue`/`fail`.

With both recorded, V4's `elapsed_s ÷ applied_budget_s` distribution makes the lie
self-evident: a cluster at ratio ≈ 0 tagged `deadline-overrun` *is* the
misclassification. Correcting the signature classifier itself (so a 1.5 s cap death
is no longer labeled `deadline-overrun`) is a **follow-up job**, out of scope here;
this design's job is to make the misclassification *measurable*. Fail-open discipline
carries over from the ledger: accounting never blocks a completion.

---

## Storage, cadence, retention

The directive's hard constraint: the journal is public, append-ish, already 7961
entries; per-tick writes bloat it and every host pays on every sync.

**Tier 1 — host-local raw (unpublished).** Each `garden-vitals` tick writes the
host's raw per-tick sample to `$GARDEN_STATE/vitals/samples.ndjson`, a **local ring
buffer** (bounded lines, oldest dropped). Never synced, never in the journal. This is
where high-frequency detail and short-term trend live; it dies with the host, which
is fine — the published aggregate carries what matters.

**Tier 2 — per-host heartbeat (published, rewrite-in-place).** On a **coarse
cadence** (default 15 min) each host overwrites ONE journal file
`vitals/hosts/<GARDEN>.json`: a small fixed-shape object — `published_at`, live
worker counts by kind, this host's V5/V6/V7 locals, and a rolling **24×1 h bucket
array** of its completion/claim/doom counts (bounded: 24 numbers, not 24 rows). Git
history holds the time series for free; the tracked file stays tiny and constant-size.

**Tier 3 — garden snapshot (leader-only, rewrite-in-place).** The leader's evaluator
reads every `vitals/hosts/*.json`, computes the garden-level ratios (V1–V4, V8, V9),
folds in each host's V5–V7, and overwrites ONE `vitals/garden.json`. This is the
single artifact the bulletin and the maintainer read.

**Footprint.** `N + 1` tracked files, each overwritten on a 15 min cadence. Commits
grow, but slowly and compactly — comparable to one watcher's tick rate, far below
per-event records. **Retention** needs no janitor: rewrite-in-place means "current"
is always small; deep history is git history, which we deliberately do **not** mine
for the dashboard (that would need a full log walk on every page load). Trend the
maintainer actually reads comes from the 24-bucket arrays embedded in the current
snapshot — bounded by construction.

**Privacy — what a hostile reader learns.** The journal is public; these files
publish the instant they land. A hostile reader of `vitals/` learns: approximate
garden size and host liveness, throughput magnitude, which backend is currently
degraded, and board depth. Mitigations, following the 2026-08-02 subscription-digest
precedent:

- **No dollars in absolute.** Spend on flat Max plans is notional anyway
  ([true-cost-vs-notional-ledger]); publish **indices and ratios** (spend-per-landed
  as a unitless index vs a rolling baseline), never raw `total_cost_usd`.
- **No account identity, no provider account, no email, no credentials** — ever.
  Host identity is already the semi-opaque `<hostname>-…-hash8` GARDEN id; anything
  finer-grained is published as a **SHA-256 digest** with the pseudonymity limitation
  recorded, exactly as `subscriptions/` does.
- **Accept the residual.** A targeted actor learns *when the garden is degraded*
  (backend down, throughput collapsed). That is operationally low-value and the
  unavoidable price of the auth-free-public-read model that makes the bulletin work.
  We state it rather than pretend it away; the alternative — a private metrics store
  — breaks the bulletin's no-backend contract and the garden's deterministic-public
  precedent, and is rejected on those grounds.

---

## Surfacing

The primary surface is a **Vitals weblet on minion.town**. It reads the garden's
public `journal2` telemetry and fetches `vitals/garden.json`, then renders:

- the nine vitals as a compact status row (green / soft / hard / ceiling), each with
  its 24 h sparkline from the embedded bucket array;
- a **host liveness strip** (one cell per host: last heartbeat age, live vs credited
  workers, deploy lag);
- the **open-incidents list** (§ below) so the maintainer sees, in one place, every
  condition currently firing and its `notice_count`.

The weblet is deliberately *thin* — status and trend, not analytics. Deep questions
("where did last week's spend go by role") stay in the on-demand `cost.sh` /
`reputation.sh` CLI tools, which already answer them; duplicating those into a
dashboard nobody reads is the anti-goal.

Rendering also consumes **zero agent tokens**. The weblet is fixed browser code
that formats bounded structured fields from `garden.json`; it must not invoke an
agent, construct a prompt, call a language-model API, or receive model credentials.
Both production and rendering are deterministic and cheap: bounded local compute
and I/O, fixture-testable results, and no cost that varies with model token prices
or agent availability.

This frontend choice also exercises the minion.town weblet-gateway system with a
real consumer of garden telemetry and motivates improvements to that system. Two
companion designs define the minion.town side: the
`minion-town-git-content-substrate-design` job covers the general capability for a
weblet to source content from a git branch (the garden's public `journal2` here),
rather than only the existing tarball/S3/SSM deployment pipeline; the
`minion-town-vitals-weblet-design` job covers the concrete Vitals weblet built on
that substrate and consuming this document's `vitals/garden.json` shape.

Extending `docs/bulletin/` with the same Vitals panel remains a live interim and
fallback if the git-content substrate or minion.town weblet is not yet available.
It is no longer a co-primary long-term target: once the weblet is operating, the
Pages panel is superseded so the garden does not maintain two copies of the view
and so normal use continues to exercise the weblet gateway.

Forward direction, outside this design's scope for now: migrate the garden's entire
existing GitHub Pages bulletin, not only Vitals, to minion.town in due course. This
design neither specifies nor builds that migration, but the Vitals surface must not
foreclose it.

---

## The response ladder

Five rungs, each with an explicit threshold and — critically — an escalation
**ceiling**. Rungs 0–1 reuse `watchdog-notice.sh` verbatim (one coalesced,
`notice_count`-bearing notice per condition); nothing here reintroduces the
per-event flood that forced the 108→84 board consolidation on 2026-08-04.

**Rung 0 — Record.** Every tick leaves its trace in `vitals/garden.json`. A metric in
its *soft* band is annotated in the snapshot, not alerted. Most anomalies never leave
this rung. Cost: zero messages.

**Rung 1 — Coalesced notice.** A metric crosses its *hard* band for N debounced
ticks ⇒ `watchdog-notice.sh <condition-key>` amends the single maintainer-inbox
entry for that condition (`notice_count++`, `first_seen` preserved, `last_seen`
refreshed), and `--recovered` closes it when the band clears. **Ceiling: one entry
per condition, by construction** — the mechanism cannot flood.

**Rung 2 — Post a bounded remediation job.** Only for anomalies with a *known,
deterministic, safe* remediation, and only when the fix is *work* rather than a
host-op (below). **Idempotent and rate-limited: at most one open remediation job per
condition key**, deduped by a deterministic basename (the orchestration-basename
discipline). Before posting, the producer consults the **open-incidents registry**
(§ below) so eight gardeners do not each post the same fact (#7). Example: V2's
`handler-refusing-claims` posts one tier-audit job, not one per doomed claim.

**Rung 3 — Host-directed corrective via the `sysop` channel.** For conditions whose
remediation is in the **closed `sysop` vocabulary** on the garden's own workers, the
evaluator sends a `host/<GARDEN>` op via `send-host-op.sh`. It may originate **only
the non-destructive ops** — `set-workers`, `drain`, `reset-failed`, `restore` — and
only when the evaluator's host is on `config/sysop-issuers` (default: the leader).
The **destructive ops** (`unit`, `deploy`, `local-model`, `maintain`) require
`authorized_by` on `maintainers/allowlist` and are **never** originated by the
responder — they stay a human act. Example: V6's `ghost-workers` on a live-but-idle
host can drive a `set-workers` correction; a *dead* host gets a notice, not an op
(you cannot host-op a host whose sysop is not ticking). This rung reuses the existing
issuer-gate + attestation trust model unchanged; it widens *who calls* `send-host-op`
(the evaluator, from the closed non-destructive set), not *what the vocabulary is*.

**Rung 4 — Page the maintainer.** Reserved for the **ceiling conditions**: V1
collapse (#1), V5 deploy-stalled (#4), V6 host-dead (#6), V7 backend-down (#8), V10
synthetic-probe failure (#10). "Page" is a distinct high-priority notice class
(still coalesced — one entry, escalating `notice_count`) and, where the maintainer
has armed it, a `PushNotification`. There is nothing above rung 4: the garden's top
escalation is *tell the human loudly, once, and keep the count*. It never, at any
rung, edits code, touches an external surface, mutates the deployed tree, or switches
identity.

### The open-incidents registry (#7)

The wedged `gc.log` was independently rediscovered and reported by **eight**
gardeners because there is no shared "what's already known-broken" surface. This
design makes the set of open conditions **worker-readable**, not just
maintainer-readable: `incidents/open/<condition-key>.md` is the canonical open-incident
file — the *same* key `watchdog-notice.sh` already uses. The registry is a thin,
deterministic mirror the watchdog path and the vitals evaluator both write, and any
worker reads before escalating a fact:

- a worker about to report condition X first checks `incidents/open/<key>` — if open,
  it bumps the count and moves on rather than spending a whole run to re-report;
- the file carries `first_seen`, `last_seen`, `notice_count`, and a one-line status,
  nothing more (public-safe by the same rules as the vitals set);
- it clears via the existing `--recovered` path.

This turns the 8-run rediscovery into one report plus seven cheap increments, and
gives the bulletin its open-incidents list for free.

### Division of labor with `mentor.sh`

`mentor.sh` already reads `journalctl` warnings across garden units every 30 min and
posts LLM-authored improvement jobs. The overlap must be stated so the two do not
double-post. **Clean split:** the vitals evaluator detects *quantified threshold
crossings* deterministically and responds within the closed ladder above (no code, no
model); `mentor.sh` diagnoses *novel log-level failures* with a model and may propose
*code* fixes for human review. A **persistent** vitals anomaly (open > M ticks with
no deterministic remediation) may post **one** mentor-targeted job — handing the
"why, and what to change" question to the LLM responder — but the vitals evaluator
never itself authors a diagnosis or a code change. mentor stays the only path to a
proposed code fix; vitals stays the only path to a quantified-threshold response.

---

## Detector self-verification (#4, #6)

The failure that let `root-repo-guard` report "root repo healthy" every 30 min while
the deploy stalled for three days (#4), and that let `ps23` die silently for three
days (#6), is the same failure: **a silent detector is indistinguishable from a
healthy garden.** The system cannot trust its own green.

Three defenses, all deterministic:

1. **Every detector publishes a `last_ran` heartbeat.** The `garden-vitals` timer,
   `root-repo-guard`, the scaler probe, each watcher — each stamps a freshness
   timestamp (host-local, folded into the host heartbeat). A **watchdog-watchdog**
   (leader-only, part of the evaluator) asserts every *expected* detector's heartbeat
   is fresh; a **stale detector is itself an anomaly** at rung 1+. This is what makes
   "healthy for three days because nothing was checking" impossible: the *checker's*
   silence is now a signal. It also subsumes #6 — a dead host's detectors stop
   stamping, so `host-presumed-dead` fires from the *absence* of freshness, not from
   any positive report the dead host can no longer send.

2. **Extend `root-repo-guard`'s invariants (#4).** Add **worktree cleanliness** as a
   fourth invariant beside its three current ones (canonical origin, HEAD detached at
   a `main2` ancestor, maintainable object store). A deployed tree dirty for > T
   hours — which is exactly what blocked the 3→27-commit deploy while the guard
   reported healthy — becomes a fourth thing the guard *cannot* call healthy while
   ignoring. The guard **detects and surfaces**; it does **not** auto-clean the tree
   (§ non-goals — that is the corruption class the guard exists to prevent).

3. **Synthetic anomaly canary.** On a slow cadence the evaluator injects a **known-bad
   synthetic sample** into a scratch copy of the pipeline and asserts it flags —
   proving the threshold path still fires. A canary that stops flagging the injected
   fault is a rung-1 anomaly ("the detector detects nothing"). This is the cheapest
   guard against the whole class of "the alarm was unplugged."

---

## Leader/follower correctness and drain-safety

Stated explicitly, because two collectors double-count and two responders double-act.

| Component | Placement | Reason |
| --- | --- | --- |
| `garden-vitals` collector (Tier 1 + host heartbeat) | **Every host**, own file only | rewrite-in-place of the host's OWN `vitals/hosts/<GARDEN>.json` — no double-count possible; a follower must publish its own liveness or #6 recurs. |
| Garden aggregator (`vitals/garden.json`) | **Leader-only** (`is_main_host`) | two aggregators overwrite each other's snapshot / double the ratios. |
| Anomaly evaluator (rungs 1–4, watchdog-watchdog, canary) | **Leader-only** | two evaluators double-post notices and double-drive host-ops. |
| Synthetic external probes (V10) | **Leader-only** | avoid N identical probes hammering the external surface. |
| `root-repo-guard` worktree invariant | **Every host** (as today) | each host's deployed tree is its own. |

**Drain-safety.** The collector runs as a **systemd timer, not a gardener job**, so
it keeps sampling on a drained host — the design's second decision, and the direct
fix for "a drained host's workers observe nothing" (`gardener.sh` exits before its
bus read). Under drain the ladder degrades sanely:

- **Rungs 0–1 (record, notice) and rung 4 (page) still fire** — you most want to
  *observe* a drained/degraded host, and #1's collapse must still page even when the
  board is drained.
- **Rung 2 (post remediation job) is suppressed under drain** — you cannot
  remediate-by-job a host that is not claiming; posting would just deepen a board the
  drain is trying to quiet.
- **Rung 3 (host-op) still functions** — the `sysop` daemon deliberately ticks under
  drain, so `drain off` / `set-workers` / `restore` remain deliverable; this is how
  an operator un-wedges a drained host, and the anomaly responder rides the same
  channel.

---

## What must NOT be automated

The boundary, argued — because several 2026-08-01/04 incidents are exactly where an
autonomous responder would have done *damage*, not repair.

- **The deployed root's uncommitted work (#4).** An autonomous responder must **never**
  `git reset` / stash / commit / clean the deployed tree. That is the precise
  corruption class `root-repo-guard` exists to prevent (the 2026-07-17/07-21
  HEAD-moved and origin-rewritten incidents). The responder **detects** (dirty tree +
  deploy lag) and **pages**; the human commits or discards. `deploy` stays behind the
  manual, attested `sysop` op.

- **Production / external surfaces (#10).** The responder must never revert, apply, or
  touch a live external surface (TLS, DNS, a running service). #10's break was in a
  surface the garden *hosts*; an autonomous "fix" there is an outage-amplifier. V10
  synthetic probes are **detect-and-page only**.

- **Retiring a job family (#9).** V9 low yield produces a *recommendation to throttle*,
  never an auto-retirement. Whether the retrospective producer earns its spend is a
  policy judgment (its 15% hit rate may still be worth catching one real regression);
  the garden surfaces the number and lets the maintainer decide.

- **Code fixes.** The evaluator classifies *that* something is wrong, never *what to
  change in code*. Code changes route to `mentor.sh` or a posted job for a
  human-reviewed builder — never auto-applied.

- **Ferry / identity switch.** Permanently out of every automated path, as they
  already are for `sysop` — restated here so no future rung reintroduces them.

**The line, in one sentence:** *autonomous action is confined to the closed `sysop`
vocabulary on the garden's own workers — scale, drain, reset, restart — plus coalesced
notices and pages; everything that touches code, an external surface, the deployed
tree, or identity is detect-and-page only.* That line is defensible precisely because
the sysop vocabulary is already closed, already issuer-gated, already host-scoped, and
already refuses the destructive ops without maintainer attestation.

---

## Non-goals

- **No parallel metric fact store.** No `metrics/*.jsonl`. Vitals are derived views
  over `usage/`, `reputation/`, the board, and host state. (The one write-path change
  is two fields on the *existing* CostRecord.)
- **No agent or model in production, rendering, or detection.** Collection,
  reduction, rendering, thresholds, self-verification, and the ladder are plain
  code — the `sysop.sh` precedent. These paths consume zero agent tokens and receive
  no model credentials. A model call per tick is itself an anomaly. (The only LLM
  touchpoint is the *optional handoff* of a persistent,
  no-known-remediation anomaly to the existing `mentor.sh`.)
- **No per-event journal writes.** N heartbeats + 1 snapshot, rewrite-in-place, coarse
  cadence.
- **No new alert channel.** Reuse `watchdog-notice.sh`; do not reintroduce the
  per-event flood the 108→84 consolidation removed.
- **No auto-remediation of code, external surfaces, the deployed tree, or identity.**
- **No analytics dashboard.** The bulletin panel is status + trend; deep queries stay
  in the existing CLI tools.
- **No cross-host history mining for the dashboard.** Trend comes from bounded
  in-snapshot bucket arrays, not a git-log walk.

---

## Considered and rejected

- **A dedicated append-only `metrics/` event log.** Rejected: it is the exact
  parallel-store the directive warns against, it bloats the public journal per-tick,
  and it drifts from `usage/` the moment the two disagree. Deriving from `usage/`
  keeps one source of truth.
- **Collection as a claimed gardener job.** Rejected: `gardener.sh` exits on the drain
  check before its bus read, so a job-based collector goes blind on exactly the
  drained/collapsed hosts that most need observing (#1). A systemd timer is the only
  correct placement.
- **A Prometheus/Grafana or external TSDB sidecar.** Rejected: it breaks the
  auth-free-public-read model, adds a credentialed backend to a public-journal
  substrate, and is a second system to keep alive (a new silent-detector risk). The
  bulletin already reads the journal without auth; extend it.
- **LLM-scored anomaly detection.** Rejected: non-deterministic, per-tick model cost,
  and unauditable — the opposite of the `sysop.sh` precedent. Thresholds are boring,
  cheap, and reproducible by any outside observer, which is the point.
- **Auto-cleaning the deployed tree / auto-reverting the TLS change.** Rejected on the
  boundary argument above: these are where autonomy causes the damage.
- **One giant vitals dashboard.** Rejected: the directive's "resist a large dashboard
  nobody reads." Nine action-bearing vitals, cut to the ones an incident turned on.

---

## Build phasing (proposed split)

Larger than one increment. Four phases; each lands independently and is useful alone.
Phases 3–4 are the risky part (they *act*) and should get their own design review
before implementation.

1. **Foundation (read-only, no response).** Widen the CostRecord with
   `applied_budget_s` + `park_signature` (#3). Build the `garden-vitals` timer:
   Tier-1 host-local sampling, the per-host heartbeat, the leader `garden.json`
   aggregate. This alone makes #1, #6, #8 *observable* — the metrics exist even before
   anything reads them. No thresholds, no notices.

2. **Surfacing.** The minion.town Vitals weblet + host-liveness strip +
   open-incidents list, with the GitHub Pages Vitals panel as an interim fallback.
   Read-only; still no autonomous action.

3. **Detection.** The deterministic evaluator: thresholds → rungs 0–1 via
   `watchdog-notice.sh`; the `incidents/open/` registry (#7); detector
   self-verification (watchdog-watchdog, the `root-repo-guard` worktree invariant #4,
   the synthetic canary); the config-consistency asserts (#5). Coalesced notices only
   — no jobs, no host-ops yet.

4. **Bounded response.** Rung 2 (idempotent remediation jobs, one-per-condition), rung
   3 (closed-vocab non-destructive `sysop` ops), rung 4 (paging). Each gated,
   drain-aware, and leader-only. This is the phase that *acts*; land it last, behind
   its own review, with the non-goals boundary as its acceptance test.

**Acceptance test for the whole system** (the directive's framing — *would it have
caught this, and how fast?*): replay each of #1–#10 against the phase that owns it and
confirm the vital fires within one publish cadence (#1 V1, #2 V2, #3 V4, #4 V5, #5
consistency-assert, #6 V6, #7 registry, #8 V7, #9 V9, #10 V10) — and that no rung
touches code, an external surface, the deployed tree, or identity.
