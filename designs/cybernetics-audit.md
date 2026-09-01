# Cybernetic audit of the garden automation

| | |
| --- | --- |
| Created | 2026-09-01 |
| Author | researcher (gardener, job `audit-garden-automation-cybernetics`) |
| Status | Report (audit; changes no runtime behavior) |
| Scope | every standing feedback loop: `scripts/jobs/`, `scripts/systemd/`, the `journal2` board, and the humans in the loop |

This audit treats the garden as a control system. The unit of analysis is the
feedback loop: sensor, setpoint, controller, actuator, the world, sensor again.
For each loop it asks what is measured, how well that corresponds to the
quantity actually being regulated, how fast and how hard the loop acts, what
happens when the sensor is wrong or absent, and what prevents oscillation,
saturation, or fights with neighboring loops.

The calibration set is the nine pathologies measured on 2026-08-31/09-01 (the
commissioning directive). Each is explained below as a property of a loop, not
a local bug, and each general finding predicts where the same shape recurs.
Three causal investigations were live on the board while this audit ran and own
their respective root causes: `diagnose-budget-meter-overreport-ece02cb4`,
`diagnose-panel-fix-loop-oscillation`, and `diagnose-panel-seat-error-rate`.
This document is the systemic view; it does not duplicate their work.

Evidence discipline: every claim below cites a file, commit, or journal path.
Line numbers are against `main2` at the audit worktree's checkout
(`36360f0ab5`). Journal counts were re-measured on 2026-09-01 and are marked
where they differ from the directive's day-earlier figures.

## 1. Loop inventory

Grouped by the plant each loop regulates. "Posture" is the behavior when the
loop's sensor is unreadable, absent, or stale.

### 1.1 Capacity loops (how many workers run, and whether they may claim)

| Loop | Sensor | Setpoint (provenance) | Actuator | Period | Posture |
| --- | --- | --- | --- | --- | --- |
| `budget-level.sh` (leader) | metered weekly token spend per pool: local session JSONL fold, or a remote host's published snapshot `budget/live/<host>`, or the journal `usage/` ledger | pool cap from journal `config/budget-pools` (seeded by an unwired placeholder TSV); high-water 0.85 hardcoded (`usage-meter.sh:78`); band 1..4 hardcoded (`budget-level.sh:14-15`) | writes the `hosts/<host>` count line (locally via `set-workers.sh`, remotely via a sysop op) | inline in the scheduler tick, 15 min | fail-open: unreadable pool or absent config levels nothing; but see § 2.2 for the blind-sensor-reads-zero path |
| `gardener-scaler.sh` (every host) | the declared `hosts/<host>` count line, plus a live backend probe per kind | the declared count itself (pure reconciler) | `install-units.sh scale`: systemd instance start/stop; sole writer of worker units (`gardener-scaler.sh:16`) | 60 s | fail-safe on the count (missing or unparsable line never tears down; only an explicit 0 does); fail-open on the budget-snapshot publish |
| `backend_effective_count` (inside the scaler) | `worker_backend_probe`, bounded 8 s, token-free | the declared count, gated | the effective instance count; host-local state only, never written back to the journal (`common.sh:1363-1365`) | 60 s | the fleet's only hysteresis: ramp up after 1 pass, down after 2 consecutive fails (`common.sh:1348-1352`) |
| `claim-job.sh` admission gate | `fleet_draining`, then `pool_admits` over the same meter chain | pool cap times 0.85 | refuses the claim tick (exit 3); changes no counts | per claim attempt | fail-open: only a confirmed `backoff` refuses; `off` and `unknown` admit (`usage-meter.sh:529-536`, `claim-job.sh:149-150`) |
| `foreman.sh` pump (leader) | board depth `todo+doin`, settle clock, quota and fleet-budget status | `GARDEN_FOREMAN_ACTIVE_TARGET`, hardcoded to 0 in the unit since 2026-07-14 (`garden-foreman.service:20`): the pump is quiesced | promotes deferred plans up to the open-slot count, or generates one new job per tick | 5 min | fail-safe on drain/brake and on an unreadable journal; fail-open on an unreadable meter (`foreman.sh:220-224`) |
| `drain-fleet.sh` | existence of a host-local marker file | binary, operator-set | claim refusal plus roughly 20 watcher short-circuits; enforcement is distributed | none (operator act) | fails open toward running: an unreadable `$GARDEN_STATE` reads as not draining; no expiry, no confirmation handshake |
| `brake-foreman.sh` | existence of journal `config/foreman-brake` | binary, operator-set, journal-backed so it follows a leader handoff | stops only the foreman pump | read per foreman tick | fail-safe toward braked: an unreadable journal exits the foreman tick before the read (`common.sh:499-505`) |
| `budget-refresh.sh` (leader) | plans parked `over-token-budget`, and the weekly reset anchor | Friday 21:00 America/Los_Angeles, hardcoded (`usage-meter.sh:82-84`) | `promote-plan.sh` per due job | 5 min | drain-gated; an `unknown` meter still promotes (fail-open) |

Notes. The budget subsystem is inert until `config/budget-pools` exists in the
journal; with it absent every verdict is `off` and no admission decision is
made anywhere. The two Anthropic pools were calibrated (one deliberately
unblocked, not calibrated) on 2026-09-01; the config file's own header narrates
both acts and delegates the real calibration to the diagnose job.

### 1.2 Lifecycle loops (claim, supervise, reap, compose)

| Loop | Sensor | Setpoint | Actuator | Period | Posture |
| --- | --- | --- | --- | --- | --- |
| claim CAS | `jobs/todo/` listing in a private clone | one owner per basename, enforced by the accepted push (`claim-job.sh:10-13`) | `git mv` todo to doin plus claim block, one push | per worker tick | lost race backs off to the next candidate, never retried on the same base |
| `reaper.sh` (leader) | claim age vs a re-derived budget floor; host-local process liveness; a progress verdict from per-job output-token spend; gardener-stamped cycle markers | `GARDEN_CLAIM_TTL=14400`, doom thresholds 5 (requeue), 1 (overrun), 2 (constancy), 0 (policy refusal); provenance is incident-quoted in-file | requeue to todo, or doom-park to `plan/` gated `go-ahead` (which no auto-promoter selects); batched, capped at 8 per tick | 10 min | largely fail-safe: never reaps earlier than the age floor, kills-and-defers a live handler, spools undeliverable doom notices for re-delivery |
| `gauntlet.sh` driver (leader) | the current child's board location plus its `gauntlet-stage-result` marker | `max_iterations 6`, `max_resumes 6`, `max_stage_retries 2`; no caller overrides | posts and re-posts stage jobs; terminal tada | 3 min | fail-closed on every unparseable state; since `d28a2d5f76`, retries a doomed stage only on reaper-certified transience or vanish-without-evidence |
| `orchestrate.sh` (leader) | child board state, mirroring the reaper's productive-cycle predicate exactly | `order`, `on-child-failure`, stall requeue limit 2 | promotes orchestrated children; halt or continue per policy | 3 min | fail-safe: any unreadable snapshot defers a tick |
| `unblock.sh` (every host) | `gate: blocked` plans and their blocker artifact (PR state or tada presence) | blocker complete and not declined | `promote-plan.sh`, or flip to `blocked-failed` plus one notification | 5 min | fail-safe: unreadable PR state leaves the plan parked, loudly |
| `scheduler.sh` (leader) | `schedules/` frontmatter and `last_dispatched` | per-schedule cadence; anchored stamps are DST-aware | writes `jobs/todo/` directly, stamp and post in one CAS commit | 15 min | preflight gate fails open (a broken gate never starves a schedule, escalated once); see § 3.4 for what else this path skips |
| `deadline-nudge.sh` (every host) | doin claim age vs the applied budget | warn at one quarter of budget remaining, capped 900 s | advisory inbox message only | 1 min | fail-open, defer-on-error; cannot extend, kill, or requeue |

### 1.3 Producer loops (what puts work on the board or messages in an inbox)

The full per-producer table (trigger, dedup, drain posture) is in the evidence
appendix of this audit's job trail; the load-bearing summary:

- Event watchers (`comment-`, `ci-`, `dependabot-`, `mention-`, `issue-inbox-`,
  `pages-watcher`, `approval-reconciler`): durable cursors or state-derived
  basenames for dedup, drain-gated, head-of-line safe. None reads board depth
  before posting; caps are API-side (activity windows, source timeouts), not
  board-side.
- LLM-mediated producers (`triager`, `follow-up`, `mentor`, the foreman pump):
  circuit breakers on failure (fail streaks, rejection thresholds, transient
  wall-clocks), but only the foreman bounds volume by downstream state.
- `repo-watcher.sh` is a meta-producer: one `comment-repos/` entry arms four
  producer families per 60 s reconcile, uncapped, and
  `fork-watch-provisioner.sh` can add entries autonomously.
- `ironhorse-fuzz.sh` (paused 2026-08-31 via `install-units.sh:57-70`
  `EXCLUDED_UNITS`): capture capped at 8 findings per tick, release serialized
  to one live repair per generation via `repair_is_live`
  (`ironhorse-fuzz.sh:363-369`).
- The scheduler and `repo-watcher` are the two producers that keep producing
  under drain (neither calls `fleet_draining`); every other producer is gated.

### 1.4 Keeper and guard loops (resources, integrity, deploy, alerting)

| Loop | Regulates | Key property |
| --- | --- | --- |
| `clone-keeper.sh` (30 min) | freshness of tracked bare clones | strictly fast-forward CAS; refuses to clobber; escalates instead of silently logging |
| `state-clone-keeper.sh` (hourly; landed `830a4b299b`, 2026-08-30/31) | leaked per-identity journal clones (the inode leak) | four liveness guards plus a 6 h idle floor and a 200-per-tick sweep cap; contains zero filesystem measurement (see § 2.4) |
| `journal-worktree-keeper.sh` (30 min) | the shared `journal/` worktree vs `origin/journal2` | lossless self-heal (patch and byte backups before any reset); pages only for unpreservable work-in-progress |
| `root-repo-guard.sh` (30 min, every host) | root repo origin, HEAD, object store, free inodes; stalled deploy at 3 days | inode invariant D is alert-only, with no actuator (§ 4.2); unparseable `df` leaves alert state unchanged silently (`root-repo-guard.sh:589-590`) |
| deploy loop (`upgrade-monitor.sh` 5 min; `deploy-garden.sh`) | deployed tree vs `origin/main2` | the actuator is a human-attended liaison session; the candidate gate now probes its unpack root for exec before trusting it (`3411c580d3`, 2026-09-01) |
| `sysop.sh` (20 s, every host) | host-directed ops off the bus | closed vocabulary; deliberately ticks under drain so `drain off` stays reachable (`sysop.sh:77-81`) |
| `self-heal-run.sh` (wrapper) | unit failure diagnosis | diagnoses, never retries; throttled 1800 s and capped 12/day per (context, rc) |
| `watchdog-notice.sh` / `doom-notice.sh` | maintainer alert volume | keyed amend-or-post while unread; occurrence counting under a 1 h per-key delivery throttle |
| reputation (`reputation-reduce.sh`, 5 min leader) | per-arm cost/acceptance estimates | sensor and estimator are live; the actuator (bid-market claim selection) is unwired: no producer stamps `market: bid` (`skills/bid-auction/SKILL.md:132-135`) |
| telemetry/anomaly ladder (`designs/garden-telemetry-and-anomaly-response.md`) | fleet vital signs | designed 2026-08-04, zero of it implemented (no `vitals`, no `incidents/open` in `scripts/`) |

## 2. Sensor validity

### 2.1 The spend sensor is a proxy chain, and the actuator cannot tell which link it is standing on

The quantity being regulated is "how much of the provider's weekly allowance
remains". No loop measures that. The chain of proxies, in decreasing fidelity:

1. Claude Code session JSONL fold: `input + output + cache_creation`,
   cache-read excluded because it "would otherwise dominate the sum and trip
   the back-off far too early" (`usage-meter.sh:35-37`). Deduped by message id,
   windowed by file mtime then line timestamp.
2. A remote host's published snapshot of (1), up to 30 min stale
   (`usage-meter.sh:95,320,331`).
3. The journal `usage/` CostRecord ledger (per-job engagement deltas).

The provider's own figure (`claude /usage`) is not machine-readable and is not
in the chain; `usage-meter.sh:71-75` says so and asks for it to be surfaced as
an open question. That is the structure behind the calibration incident: on
2026-09-01 chain link (1) read 120.1M against a 149M cap (80.5%, throttling
`ece02cb4` to 1 gardener) while `/usage` on the same host read 0% of the week.
Two measurements of one quantity, and the controller has no representation of
which one it is trusting or how much to trust it. The journal config
(`config/budget-pools`, 2026-09-01 header) records the maintainer's response: a
deliberate unblock to 385M with the real calibration delegated to the diagnose
job. The same class recurs in reporting: `campaign-spend.sh:132` prices
notional dollars from a hardcoded `$400/mo` literal, which
`designs/recurring-budget-calibration.md:43` explicitly forbids.

Prediction from the class: any future pool (OpenRouter, a metered API key)
added to `config/budget-pools` inherits the same blindness unless its row
carries provenance ("calibrated from X on date Y") that the controller can
check.

### 2.2 "No signal" reads as "zero spend", and zero spend means maximum workers

Two paths return a confident 0 when the sensor is actually blind:

- `usage-meter.sh:196`: a log directory with no in-window files prints `0`
  ("genuine 0" per its own comment). True for a genuinely idle host; equally
  produced by a fresh host, a relocated `$HOME`, a wrong `GARDEN_CCUSAGE_LOGDIR`,
  or restored-from-backup mtimes (the fold pre-filters by mtime).
- `usage-meter.sh:302`: an existing but empty journal `usage/` directory prints
  `0`, despite the adjacent comment (`usage-meter.sh:296-297`) claiming the
  remote path never invents a zero.

Zero spend then drives `budget-level.sh:129-139` to headroom 1, which is the
band maximum (4 workers). The failure direction is inverted: a blind spend
sensor scales the fleet up to its ceiling. The directive's principle that a
loop must distinguish "no signal" from "signal of zero" fails here exactly
where it is most expensive. (The opposite error is bounded: the 0.85 mark and
the band floor of 1 cap how hard an over-reading sensor can throttle, which is
why the `ece02cb4` incident cost half a host, not a fleet.)

### 2.3 Uncalibrated setpoints wired to full-authority actuators

The leader host sat in permanent backoff for days against the 5M placeholder
cap whose own header says "PLACEHOLDER CAPS — NOT CALIBRATED"
(`budget-pools-placeholder.tsv:1`). The controller treats every cap identically:
there is no field for "this setpoint is a seed", so the actuator applies full
authority against a number the config itself disclaims. Related setpoint
provenance is thin across the capacity loops: of the five numbers that size the
fleet (cap, 0.85, min 1, max 4, foreman target 0), only the cap is
operationally configurable, and it is the one that shipped uncalibrated.
`designs/recurring-budget-calibration.md` (Proposed) and
`designs/live-budget-admission.md` open question 1 already specify the
calibration mechanism; neither is implemented (`weekly-capacity-calibration.sh`
does not exist).

### 2.4 Sensors valid only outside the environment the fleet runs in

- The deploy candidate gate unpacked to `${TMPDIR:-/tmp}` and executed there;
  `/tmp` is `noexec` on these hosts, so the gate failed rc=126 and presented as
  a code regression, silently blocking deploys. Fixed hours before this audit by
  `3411c580d3` (exec-probe the unpack root, fall back to
  `$GARDEN_SCRATCH/tmpexec`). Two residuals: the gate still measures the
  candidate in a scratch tree rather than the deployed mount, so anything
  conditioned on the deployed path or mount options stays unsensed; and the
  same hazard had already bitten the gate's own test fixtures six weeks earlier
  (`f1d161107b`, `532584e036`, 2026-07-29) without the gate root being checked,
  which is the recurrence signature to watch for.
- Every sensor keyed on `systemctl --user` (`state-clone-keeper.sh:141-146`,
  `deploy-garden.sh:340-343`, the sysop's async-op polls) returns a uniformly
  negative answer when the user manager is wedged. The keepers handle it
  explicitly; the deploy path sweeps and logs.
- The container guard's sensor is authoritative inside the container and only
  presumptive outside it, and its automated trigger (the SessionStart hook)
  cannot propagate by deploy because `.claude/settings.json` is gitignored.

### 2.5 A review sensor that is noise one time in five

87 of 444 panel runs ended `disposition: error` in the directive's measurement;
re-measured 2026-09-01: 88 of 465 records (18.9%) under journal `panel-runs/`.
An all-seats-erroring panel is not a disposition the loop reasons about: the
run dies at the first non-ok seat in the join (`panel.sh:545-554`), before any
aggregation. The gauntlet's stage brief then instructs the supervising gardener
to complete with `orchestration-failed: true` when `panel.sh` exits non-zero
(`gauntlet.sh:315-316`), and a tada carrying that marker takes the explicit
decline branch, which never retries (`gauntlet.sh:569-570`). Net effect: a
transient provider blip inside a panel halts the whole gauntlet on first
occurrence, while a panel job that dies outright gets two retries. The sensor
noise is being routed into the one branch the retry budget cannot reach.

### 2.6 Specification errors pass silently and succeed by luck

`job_tier` (`common.sh:5743-5747`) recognizes exactly
`mentat|mentor|minion|myrmidon` and returns rc 1 for any other non-empty value
with no log. No producer validates a body-supplied `tier:` (only the canary
path in `post-job.sh:130` checks the vocabulary). The handler budget never
consults `tier:` at all (`job_handler_budget_base`, `common.sh:6230-6247`); it
derives from `role:`, defaulting to 2400 s. So `tier: builder` (the observed
mis-specification) silently costs the intended 7200 s budget, the job overruns
the 2400 s wall, and the reaper's deterministic overrun doom (threshold 1) is
correct on its own terms while the actual defect is upstream at admission. Two
sibling jobs finishing under 2400 s hid it. The general class: frontmatter is
an interface with a closed vocabulary on the read side and no validation on the
write side. The same shape exists for `handler-timeout:` (a non-integer value
is silently ignored; only `set-schedule.sh:75-83` validates the ceiling at
write time).

### 2.7 Silent detectors

A detector whose failure is indistinguishable from health is a hole in the
sensor fabric. Confirmed instances: `guard_inode_headroom`'s unparseable-`df`
branch leaves alert state unchanged with only a log line
(`root-repo-guard.sh:589-590`); `guard_object_store` skips-with-success when it
cannot resolve the git common dir (`root-repo-guard.sh:393-395`);
`upgrade-monitor.sh` exits 0 silently on fetch or resolve failure (its only
backstop is the 3-day stall alert); the budget-snapshot publisher no-ops
silently on every soft failure, so an unpublished snapshot is indistinguishable
from an unconfigured pool (`usage-meter.sh:343-348`). The telemetry design
(2026-08-04, Proposed, unimplemented) names this exact failure: "a silent
detector is indistinguishable from a missing one".

## 3. Backpressure

### 3.1 Where it exists

Exactly two shipped producers bound their output by downstream state: the
foreman (`inflight >= GARDEN_FOREMAN_ACTIVE_TARGET` gate plus a 240 s settle
window and a one-new-job-per-tick cap, `foreman.sh:177-200`) and the fuzz
lane's release serialization (at most one live repair per generation,
`ironhorse-fuzz.sh:363-369`). The foreman's is moot while its target is 0; the
fuzz lane is paused. Everything else that reads the board before posting reads
it for idempotency, not depth.

### 3.2 The fuzz lane: a producer whose quarantine counted as liveness

The observed flood (73 quarantined at pause, 77 in `plan/` on 2026-09-01, the
bulk doomed `policy-refusal` with `requeue_cycles: 5`) is not the absence of
serialization; `repair_is_live` counts `plan/` as live, so each quarantined
repair correctly blocked its successor and the board never flooded. What was
missing is triage between capture and release, and any feedback from the
reaper's doom classification to the producer: the reaper wrote
`doom_signature: policy-refusal` 60-plus times and the producer had no reader
for it. `designs/ironhorse-fuzz-triage-and-batch.md` (Proposed, 2026-08-31)
already specifies the correct controller, including the only hysteretic
band in the repo (high water 24 total or 8 per target stops fuzzing; resume
below 12 and 4). None of it is implemented; verified by grep for its record
paths and fields.

The correct backpressure signal here is not queue depth but the composition of
the quarantine: N consecutive same-signature dooms from one target is a
producer-side stop signal regardless of depth.

### 3.3 The maintainer inbox: an unbounded queue whose consumer is a human

The directive measured roughly 100 messages per 9 undrained hours, and a full
muster shrank the backlog by one. The write side has two disciplined paths
(`watchdog-notice.sh` and `doom-notice.sh`: keyed, amend-while-unread,
occurrence-counted under a 1 h throttle; both born from incident counts of 94
and 37 duplicate messages) and one unlimited path: `inbox-send.sh` mints a
random message id unless the caller supplies one (`inbox-send.sh:99-102`), so
every call is a new file. Callers with no dedup of their own include
`message-user.sh` (every gardener's channel), `orchestrate.sh:426`,
`gauntlet.sh:188`, and the follow-up liaison handler. The drain being the only
lever that shrank the backlog is exactly what the loop diagram predicts: inflow
is proportional to fleet activity, the consumer is fixed-rate, and there is no
coalescing on the dominant path.

The correct backpressure signal is not queue depth (messages must not be
dropped) but per-sender, per-episode coalescing: the proven `watchdog-notice`
discipline extended to the raw path, plus stable ids so a re-send amends. A
digest/priority split is the designed rung in the telemetry ladder.

### 3.4 The scheduler bypasses the one fleet-wide admission gate

`post-job.sh:210-232` routes every posted job to `plan/ --budget-hold` when all
bounded pools are at high water. The scheduler does not go through
`post-job.sh`: it writes `jobs/todo/` directly (`scheduler.sh:403-404`), never
calls `budget_fleet_status` (grep: no match), and has no `fleet_draining` gate
(grep: no match, § 1.3). Recurring schedules also have no occupancy dedup: the
basename is unconditionally timestamped (`scheduler.sh:425`), so a schedule
whose job outlives its cadence accumulates one instance per period; only the
`once:` path checks the board (`scheduler.sh:396`). The press-job families in
the live inbox listing (four `endo-*-press-*` generations of each family
concurrently alive on 2026-09-01) are this shape in the wild.
`designs/live-budget-admission.md:174` records the same bypass in
`gauntlet.sh` and `auction.sh` stage posts.

### 3.5 Producer fan-out is itself unregulated

`repo-watcher.sh` arms four producer families per `comment-repos/` entry every
60 s with no cap, and `fork-watch-provisioner.sh` adds entries without a human
(by design, sender-gated). This is a gain knob on total production with no
loop watching it; today it is bounded socially (the watch set is small and
maintainer-authorized). Worth naming, not yet worth a controller.

## 4. Loop interactions

### 4.1 Five writers, one count line, no arbitration

`hosts/<host>`'s per-kind count line is written by `budget-level.sh`, the sysop
`set-workers` op, human `set-*.sh`, and (journal-mediated) whoever wins the CAS
last; it is read by the scaler, which then applies its own probe-gated
effective count. There is no ownership field, lease, or precedence: the only
documented precedence table in the fleet is drain-vs-brake
(`brake-foreman.sh:16-22`), which does not cover counts. Consequences:

- `budget-level` re-asserts its computed target every 15 min, so a manual
  `set-gardeners.sh 8` on a leveled pool is silently reverted to at most 4
  within a tick. The design's stated restraint ("only ever narrows the gap",
  `designs/live-budget-admission.md:296-298`) is not implemented.
- `budget-level` never consults `fleet_draining`, so it will keep writing
  counts (and raising per-change maintainer alerts) on a drained host.
- Declared vs effective are unreconciled: the probe gate can hold a pool at 0
  while `budget-level` levels the declared line between 1 and 4, alerting on
  each change of a number that controls nothing.
- Kind drift: `budget-level` senses and writes the legacy `gardeners:` line
  (hardcoded awk, `budget-level.sh:147`) while `anthropic_active_kind` can arm
  `monk` and shadow `gardener` (`gardener-scaler.sh:83-86`). On a cut-over host
  the leveling loop is open: it steers a line nothing reads.

### 4.2 A sensor and an actuator for the same resource, unwired

The inode-exhaustion incident class (two near-zero-inode events, journal-clone
leak) now has both halves of a closed loop: `root-repo-guard` invariant D
measures free-inode percent (`df -Pi`, threshold 5%) and alerts;
`state-clone-keeper` deletes clones. They do not reference each other. The
keeper sweeps at a fixed rate (hourly, at most 200) whether the filesystem is
at 99% or 1% free, and every one of its failure branches keeps clones,
including the branch where the journal is unreachable, which is precisely the
symptom of the exhaustion it exists to prevent (its own header concedes the
offline path's protection is `sync_clone`'s exit, `state-clone-keeper.sh:104-111`).
The failure suppressed its own alarm once already; the current design would do
so again, only slower.

### 4.3 Correct guard, emergent stall: the cap-consistency coupling

`meter_remote_snapshot_total` refuses a snapshot whose recorded cap or window
differs from the controller's (`usage-meter.sh:329-332`). Sound: a stale cap
must not be trusted as a lower bound. The coupling: a cap change invalidates
every host's snapshot until each republishes (15 min bucket), during which
`budget-level` falls back to the journal ledger and, if that also fails,
levels nothing (fail-open). Observed live during this audit: an hour-plus after
the `config/budget-pools` raise to 385M, `budget/live/endolin-garden-ece02cb4`
still recorded `cap: 149000000` (sampled 19:00Z), so the guard was rejecting
it. The dead time is bounded (one snapshot bucket plus one leveling tick) and
the posture during it is the safe one. Verdict: correct but surprising; the
fix, if any is wanted, is to document the propagation delay next to
`set-workers`-class operations, not to loosen the guard.

### 4.4 Doom classification flows to exactly one consumer

Since `d28a2d5f76` the reaper stamps `failure_classification` and the gauntlet
driver reads it; that is the fleet's only classification-carrying edge, and it
is the right direction (it ended the 70-of-89 whole-gauntlet halts from single
doomed stages). No producer reads any doom field (§ 3.2); `orchestrate.sh`
collapses every doom to an undifferentiated `failed`
(`orchestrate.sh:355-368`); `promote-plan.sh` deliberately strips doom
provenance and cycle counters on promotion (documented as "run this again"
semantics, `promote-plan.sh:19-38`). The strip is correct for a human
promotion; it also means any future automated promoter would silently zero the
loop's accumulated memory, which is worth remembering before one is built.

### 4.5 The human as controller

Three loops have a human as an in-band element, with different time constants:

- The deploy actuator is a liaison session (deliberate-deploy design). A
  bot-only host accumulates upgrade-ready markers until a session exists; the
  only ambient sensor for "the actuator is absent" is the 3-day stall alert.
- The maintainer inbox consumer (§ 3.3): fixed-rate human against
  activity-proportional inflow.
- Setpoint maintenance: caps, worker counts, the watch set, and promotion of
  doomed work are all maintainer acts. The 2026-09-01 budget entry shows the
  human doing setpoint repair the loops cannot (raising a disputed cap while
  recording why), which is the right division of labor; the failure mode is
  only that the loops give the human no confidence signal to work from (§ 2.1).

### 4.6 Timer topology as an implicit coupling

The lifecycle loops are phase-offset by minute digit (orchestrate :01/3,
gauntlet :02/3, reaper :03/10, foreman :04/5, scheduler :05/15) to keep
journal-CAS contention low: a deliberate, working decoupling. Two starvation
incidents (orchestrate 2026-07-03, unblock 2026-07-14..16) were caused by
relative timers sliding under daemon reloads; both are fixed by absolute
anchors, but `garden-watchman.timer` still uses the relative shape its
neighbors' comments warn against.

## 5. Gain, delay, saturation, oscillation

### 5.1 budget-level acts with full authority on a sensor up to 45 minutes stale

The controller is memoryless proportional with a single-tick jump to target:
the awk at `budget-level.sh:129-139` maps spend/mark bands directly to counts
{4,3,2,1} and writes the target immediately; 4-to-1 and 1-to-4 both happen in
one 15-minute tick. There is no deadband, no dwell, no per-tick step clamp; the
only chatter suppression is exact equality (`budget-level.sh:155`). Remote dead
time stacks to roughly 30-45 min (15 min snapshot bucket, 15 min tick, plus
actuation). A pool hovering at a band boundary flips counts every tick, each
flip costing a journal commit, a sysop message, systemd churn, and a
maintainer alert. The weekly reset produces a guaranteed 1-to-4 step on the
first tick after Friday 21:00. Nothing has oscillated destructively yet only
because the bands are wide and the fleet small; the loop's gain is out of
proportion to its sensor's confidence, which is the same imbalance as § 2.2
seen from the other side. The inner probe loop shows the house pattern to copy:
`backend_effective_count` requires consecutive confirmations in both
directions (`common.sh:1348-1352`).

### 5.2 The panel/fix loop oscillates because nothing in it is monotone

Must-fix counts across rounds do not descend (directive: `#1018` 14, 14, 17,
14, 3, 5; `#231` 17, 16, 16, 7, 14, 7; journal `panel-runs/` for #1018 also
holds a 0 among seven records). The loop's termination condition is a round
count, not a convergence measure, so it halts without converging at
`max_iterations=6`. The mechanical causes are already established in
`designs/gauntlet-panel-fix-nonconvergence.md` (Report, awaiting maintainer
choice): a single-blocker disposition over a 7-seat jury with no severity
floor, no cross-round memory of what was previously raised or deferred, and
panel-kind flips from stale base refs; on top of that sits the 19% seat-error
noise floor (§ 2.5), so roughly one round in five measures nothing at all.
This is a sensor-quality and plant-model problem, not a gain problem: raising
`max_iterations` would spend more without converging (the nonconvergence
report's cost figure: roughly $51 per gauntlet). The halt itself is
well-behaved: it leaves the PR improved and un-merged, and one halted PR
(#995) later merged on human review.

### 5.3 Reaper and gauntlet gains are calibrated and bounded

For contrast: the reaper's thresholds are each anchored to a named incident,
its per-tick requeue cap (8) prevents burst re-claims, its progress verdict
resets counters on real advancement (anti-windup in the correct direction),
and the gauntlet's three retry axes are independent and reset on stage
advance. These loops act no harder than their sensors justify.

## 6. Loops that are sound

Findings of health, stated as findings:

- **The reaper** is the best-engineered loop in the fleet: never-reap-earlier
  invariant, host-local liveness sensing acknowledged as host-local,
  incident-anchored setpoints, doom-notice spooling so its own alert channel
  failing cannot lose a doom, and deterministic-failure refusal to requeue.
  The directive's fuzz finding is not a reaper defect; the reaper's signal was
  correct and unread.
- **The sysop ticking under drain** (`sysop.sh:77-81`) is the single most
  important anti-deadlock property in the fleet and must survive any refactor.
- **The drain/brake pair** with its written truth table
  (`brake-foreman.sh:16-22`) is the model for how two controllers sharing a
  plant should document precedence.
- **The alert coalescers** (`watchdog-notice`, `doom-notice`,
  `alert_maintainer`'s count-what-you-suppress throttle) are correct and
  incident-proven; the inbox problem (§ 3.3) is the path that bypasses them.
- **The gauntlet stage-retry fix** (`d28a2d5f76`) is the correct direction:
  retry only on certified transience, fail closed otherwise.
- **`journal-worktree-keeper`'s lossless self-heal** (backup before reset,
  writer probe, page only for unpreservable work) is the right resource-keeper
  posture, as is `clone-keeper`'s refusal to clobber.
- **The claim CAS and the anti-herd offset** need no lock manager; the push is
  the serialization point and losing a race is cheap.
- **`post-job.sh` idempotency** with the identity index and the loud tada-WARN
  is a reasonable settlement of the re-post/dedup tension; its sharp edges
  (recurring verbs swallowed by stale basenames) are documented in the job-board
  skill and mitigated by date suffixes.

## 7. Ranked recommendations

Each is tagged with its class: **missing loop**, **wrong sensor**, or
**correct but couples badly**. None proposes layering a new controller over a
broken one; each corrects or completes an existing loop, or arms a design that
already exists.

1. **Make the spend sensor's blindness visible, and make blindness hold, not
   maximize.** [wrong sensor] Distinguish "no in-window logs" / "empty usage
   directory" (`usage-meter.sh:196,302`) from measured zero: return the
   existing failure rc (the safe skip path `budget-level.sh:118-121` already
   handles) unless a positive liveness marker says the host genuinely idled.
   Evidence: § 2.2; the failure direction today is maximum workers on a blind
   sensor. Smallest correct change in the fleet relative to harm avoided.
2. **Do not actuate on setpoints the config disclaims.** [wrong sensor] Give
   `config/budget-pools` rows a provenance field (calibrated-from, date) and
   make `budget-level.sh` treat an uncalibrated or placeholder-marked cap as
   config-absent (level nothing, alert once). Then implement the already
   designed calibration (`designs/recurring-budget-calibration.md`,
   `weekly-capacity-calibration.sh`). Evidence: § 2.3, the 5M-cap permanent
   backoff, and the 2026-09-01 config header doing this by hand in prose.
3. **Give budget-level the restraint its design already claims.** [correct but
   couples badly] Four bounded corrections to the existing controller, no new
   loop: a per-tick step clamp (move at most one count per tick, implementing
   `live-budget-admission.md:296-298`); a dwell/deadband copied from
   `backend_effective_count`'s confirm-before-move; skip leveling while
   `fleet_draining`; and read the active kind via `anthropic_active_kind`
   instead of the hardcoded `gardeners:` line. Evidence: § 4.1, § 5.1.
4. **Arm the fuzz lane's designed backpressure before un-pausing it.**
   [missing loop, already designed] `designs/ironhorse-fuzz-triage-and-batch.md`
   contains the triage stage, the doom-signature feedback (a policy-refusal
   cluster stops release), and the only hysteretic band in the repo. The lane
   stays paused until it exists; the 77 quarantined jobs migrate per that
   design's journal CAS op. Evidence: § 3.2.
5. **Close the inode loop that already has both halves.** [missing loop]
   `state-clone-keeper` reads the same `df -Pi` measurement
   `root-repo-guard` invariant D already computes; below the 5% threshold it
   tightens (shorter idle floor within the liveness guards, more ticks) and
   alerts if a full sweep cannot recover headroom. Also fix the silent
   `INODE-CHECK-UNKNOWN` branch to alert after consecutive failures
   (§ 2.7). Evidence: § 4.2, two near-zero-inode incidents whose failure
   suppressed its own alarm.
6. **Route panel seat-error into the retry budget, not the decline branch.**
   [wrong sensor] A `panel.sh` non-zero exit caused by seat/decider error is a
   sensor failure, not a review verdict: have the panel stage report it
   distinctly (a `panel-error` stage result rather than
   `orchestration-failed: true`) so the gauntlet's existing
   `max_stage_retries` covers it, exactly as it now covers a doomed transient
   stage. Do not touch `max_iterations` or the disposition rule here; the
   convergence question is already on the maintainer's desk
   (`gauntlet-panel-fix-nonconvergence.md`, `evaluation-epochs-panel-calibration.md`)
   and the seat-error root cause belongs to `diagnose-panel-seat-error-rate`.
   Evidence: § 2.5, 19% error rate reaching a non-retryable branch.
7. **Validate job frontmatter at the write side.** [wrong sensor]
   `post-job.sh` and `post-plan.sh` warn (or refuse, behind a flag) on a
   `tier:` outside `job_tier`'s vocabulary and on a non-integer
   `handler-timeout:`; `job_tier` logs one WARN on the silent rc-1 path.
   `set-schedule.sh:75-83` already shows the write-side validation shape.
   Evidence: § 2.6, the `tier: builder` silent budget loss.
8. **Send scheduled dispatch through the admission gate.** [correct but
   couples badly] The scheduler builds its body, then posts via `post-job.sh`
   (inheriting budget-hold routing and the identity index) instead of writing
   `jobs/todo/` directly, and gains an occupancy option for recurring
   schedules (skip or carry forward when the previous instance is still live,
   the check the `once:` path already performs). Decide its drain posture
   explicitly rather than by omission; posting into a drained board may be the
   intended semantic, but today it is an accident of not calling
   `fleet_draining`. Evidence: § 3.4.
9. **Extend the coalescing discipline to the raw inbox path.** [missing loop]
   Require or default stable message ids for the autonomous callers of
   `inbox-send.sh` (orchestrate, gauntlet, follow-up-liaison, message-user
   with a per-job episode key) so repeats amend instead of accumulate,
   reusing `watchdog-notice`'s amend-while-unread mechanics. This does not
   solve inbox inflow being proportional to fleet activity (that is the
   telemetry ladder's digest rung), but it removes the duplicate mass the
   2026-07-28 incidents proved dominant. Evidence: § 3.3.
10. **Alert when the deploy loop's sensor goes silent.** [wrong sensor, low
    urgency] `upgrade-monitor.sh` counts consecutive silent-skip ticks (fetch
    or resolve failure) and raises one keyed alert past a threshold, and the
    stalled-deploy window becomes configurable per host class; a bot-only host
    that cannot host the human actuator deserves a shorter fuse than 3 days.
    Evidence: § 2.7, § 4.5, the weeks-long silent deploy blockage that
    presented as a code regression.

Not recommended, deliberately: loosening the cap-consistency guard (§ 4.3, the
stall is bounded and the guard is the safety property); raising
`max_iterations` (§ 5.2, more gain into a noisy sensor); any new autonomous
promoter for doomed work (the reaper's park-and-human-promote is correct); and
building the telemetry layer as a prerequisite for any of the above (every
recommendation here corrects a loop in place; the ladder remains valuable and
separately decided).

## Decision surfaces already open

No new maintainer decisions are opened by this audit. The decisions its
findings touch already have homes: panel convergence options in
`designs/gauntlet-panel-fix-nonconvergence.md` (awaiting choice); the 0.85
high-water and cap calibration in `designs/live-budget-admission.md` open
questions and `designs/recurring-budget-calibration.md`; fuzz-lane re-arming in
`designs/ironhorse-fuzz-triage-and-batch.md`; the meter-vs-`/usage` divergence
in job `diagnose-budget-meter-overreport-ece02cb4`; seat errors in
`diagnose-panel-seat-error-rate`; oscillation causality in
`diagnose-panel-fix-loop-oscillation`.
