# Design: continuous local-first evaluation lanes

| | |
| --- | --- |
| Created | 2026-07-24 |
| Author | gardener, prompted by kriskowal on [garden issue 62](https://github.com/kriskowal/garden/issues/62) |
| Status | Proposed |

## Decision

Establish a continuous evaluation service that uses the available Ollama hermit
pool as its first evaluation lane, then admits budgeted provider, model, effort,
and memory variants only through explicit experiment manifests. The service
evaluates replayable historical jobs and a sampled stream of future jobs. It
records comparable evidence for the bid and reputation system, but it never
selects live work, changes a role, changes a model route, changes an evaluator,
or spends a paid-provider budget without maintainer approval.

This is the operational companion to
[gardener-reputation-bootstrapping.md](gardener-reputation-bootstrapping.md),
which defines retrospective replay and cost-conditioned reputation, and
[evaluation-epochs-panel-calibration.md](evaluation-epochs-panel-calibration.md),
which freezes PR-review criteria during an evaluation epoch. It does not replace
either design.

## Why local first

The local hermit pool is already a separately routable `provider: local` worker
that uses the on-box Ollama endpoint. Its marginal invoice is low, but it is not
literally free: hardware amortization, electricity, queue delay, and opportunity
cost are real. The local lane is therefore the default source of frequent
measurements, while its ledger records both `invoice_dollars: 0` and an
amortized-dollar estimate from the active rate card. This avoids treating local
success as infinitely cheap and preserves a fair comparison with paid arms.

Running local evaluations continuously gives the garden an early warning when a
model tag, prompt routing rule, or memory bundle regresses. It also creates a
steady baseline before a paid comparison is allowed. Continuous does not mean
unbounded: each run is independently capped and can be paused immediately.

## Experiment identity

Every run belongs to an immutable manifest, stored in the journal under
`evaluation-lanes/manifests/<id>.md`. The manifest is the unit that can be
approved, scheduled, compared, paused, or retired. It contains:

```yaml
id: local-hermit-baseline-2026-07
status: active                 # proposed | active | paused | retired
lane: local-baseline           # local-baseline | comparison | telemetry
candidate:
  provider: local
  model: qwen3.6
  effort: medium
  memory_bundle: baseline-v1
control:
  provider: local
  model: qwen3.6
  effort: medium
  memory_bundle: baseline-v1
evaluator_epoch: pr-review:1
corpus_version: 2026-07-24-a
sampling:
  historical_per_tick: 2
  future_sample_rate: 0.10
limits:
  concurrent_runs: 1
  wall_clock_s: 1800
  invoice_dollars_per_day: 0
  amortized_dollars_per_day: 3
approval:
  approved_by: kriskowal
  approved_at: 2026-07-24T00:00:00Z
```

`candidate` is the full arm under test. The memory bundle is versioned content
selection and retrieval configuration, not an unbounded transcript or mutable
agent identity. It pins the source revisions, retrieval query policy, token cap,
and ordering rule. A comparison changes one declared factor at a time: provider
or model, effort, or memory bundle. Changing several factors makes attribution
unreliable and is rejected by manifest validation.

The evaluator epoch and corpus version are pinned at run start. A changed panel
criterion or corpus creates a new comparable series, rather than rewriting an
old score.

## Three evidence lanes

### 1. Local baseline lane

The scheduler continuously dispatches low-priority, locally routed evaluation
jobs while the hermit capacity is idle. It must yield to maintainer work and may
use at most the manifest's concurrency cap. The lane runs the baseline arm over
the current replay corpus and stores a result for every completed, failed,
timed-out, or skipped attempt. A failure is data, not a reason to silently retry
until a favorable result appears.

Its role is calibration and regression detection, not promotion. The baseline is
also replayed whenever a local model tag or its memory bundle changes, before the
new configuration can become the baseline.

### 2. Budgeted comparison lane

A paid or otherwise scarce arm enters only after the maintainer approves a
separate manifest with a dollar and concurrency budget. It is paired against the
active local baseline on the same task, source snapshot, corpus version, and
evaluator epoch. The paired design reports the delta in acceptance, duration,
token use, invoice dollars, amortized dollars, rework, and evaluator
disagreement. It does not pool results across mismatched tasks as if they were
independent model quality measurements.

The scheduler stops before launching a run that would exceed the budget. A daily
summary reports planned, spent, reserved, and remaining budget. Reaching the cap
pauses the lane; it never falls back to a paid default or raises its own cap.

### 3. Future-job telemetry lane

For a deterministic sample of completed future jobs, the service records a
minimal, privacy-respecting telemetry envelope: job kind, role, provider/model,
effort, memory-bundle ID and token count, source revisions, claim-to-completion
duration, retries/requeues, deterministic-gate outcome, panel epoch and outcome,
usage, and acceptance disposition when it becomes known. Raw prompts, issue
comments, credentials, and private model state are not copied into the telemetry
store.

The sample key is `hash(job base, telemetry epoch)`, so a producer cannot choose
only favorable work after observing the outcome. Sampling and recording are
observational: they do not alter the live claimant, job priority, evaluator, or
maintainer workflow. The telemetry lane supplies fresh out-of-time evidence for
the replay corpus and identifies where historical replay has drifted from live
work.

## Replay corpus and acceptance

The corpus consists only of completed `todo`/`tada` pairs whose objective gate
can be re-run against a pinned project snapshot. Corpus curation records why a
case is replayable, its job kind, source snapshot, gate command, and any
exclusions. It excludes tasks with unavailable credentials, nondeterministic
external dependencies, unsafe input, or a stale gate. The original artifact is
not the target: a candidate succeeds by passing the recorded acceptance gate.

When a task requires subjective review, the recorded evaluator epoch provides a
frozen panel criterion. Subjective results are reported separately from
deterministic results. An evaluator change goes through the existing epoch
checkpoint process; this service cannot tune against a moving evaluator or
promote a challenger evaluator.

Each result uses an append-only journal record under
`evaluation-lanes/runs/<manifest>/<run-id>.md` with:

- manifest and corpus IDs, candidate and control identities, and pinned source
  revisions;
- task ID, attempt outcome, stop reason, and objective and subjective outcomes;
- wall-clock and active duration, tokens, invoice dollars, and amortized dollars;
- memory bundle ID, retrieved artifact IDs, and retrieval token count; and
- provenance links to the task, gate output location, and evaluator result.

The reducer may derive aggregates, but it never overwrites raw run records.
`source: evaluation-lane` keeps this evidence distinct from both historical and
live reputation events.

## Control and safety boundaries

- A manifest is maintainer-approved before activation. Approval includes its
  model route, corpus, evaluator epoch, budget, retention rule, and stop rule.
- Evaluation workers use isolated project worktrees and have no authority to
  contact external parties, edit live jobs, push branches, or write role, skill,
  routing, auction, or reputation policy.
- Evaluation dispatch is opportunistic and preemptible. A worker-capacity
  reservation for maintainer jobs is enforced before an evaluation starts.
- Inputs remain subject to the garden's sender and prompt-injection gates.
  Replay curators paraphrase unsafe external text and retain provenance rather
  than treating task bodies as executable instructions.
- The service has a maintainer-operated kill switch, `evaluation-lanes/paused`.
  A paused service launches no new work. A timeout, budget violation, safety
  violation, or evaluator-integrity failure also pauses its manifest and emits a
  maintainer-facing report.
- Results inform proposals only. They cannot award a bid, modify an arm's live
  route, promote a role, or advance an evaluation epoch.

## Rollout

1. **Read-only foundation.** Add manifest validation, append-only result records,
   deterministic corpus curation, and a reducer that produces no scheduling
   decision. Seed one local baseline manifest with a zero invoice-dollar budget.
2. **Continuous local baseline.** Schedule at most one idle hermit evaluation at
   a time. Verify pause, timeout, priority yielding, corpus reproducibility, and
   complete failed-run accounting over a fixed observation window.
3. **Future telemetry.** Add deterministic sampling and the minimal telemetry
   envelope. Compare replay and sampled-live distributions without changing
   routing.
4. **One paid paired canary.** After maintainer approval, run one explicitly
   budgeted provider/model or memory-bundle comparison against the local baseline.
   Publish the paired scorecard, including negative and incomplete results.
5. **Use evidence in proposals.** Only after enough comparable observations may a
   maintainer request a normal market, routing, role-refinement, or evaluator
   proposal. That follow-on change is separately reviewed and remains reversible.

## Success and stopping rules

The first rollout is successful when it continuously produces reproducible local
results without delaying maintainer work, accounts for every run, and can show a
paired local-versus-candidate scorecard with pinned controls. It is not successful
merely because a local model is cheaper or because a single candidate wins.

Pause and investigate when the local lane repeatedly cannot reproduce a corpus
gate, sampled live work materially disagrees with replay evidence, a memory
bundle causes a safety or retrieval-integrity failure, the queue affects
maintainer work, or a budget/timeout limit is crossed. Retire a manifest after a
maintainer review when its model, corpus, or question is no longer useful; keep
its records for audit and do not merge its observations into another manifest's
series.

## Deferred

This design does not define a universal quality score, autonomous model routing,
automatic auction awards, self-modifying memory, or a garden-of-gardens market.
It supplies the controlled, continuous evidence those later decisions would need.

## References

- [gardener-reputation-bootstrapping.md](gardener-reputation-bootstrapping.md)
- [gardener-bid-accept-market.md](gardener-bid-accept-market.md)
- [evaluation-epochs-panel-calibration.md](evaluation-epochs-panel-calibration.md)
- [provider-model-catalog.md](provider-model-catalog.md)
- [anthropic-worker-kind-monk.md](anthropic-worker-kind-monk.md)
