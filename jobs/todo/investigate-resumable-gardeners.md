<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-27T09:21:04Z -->

# PLAN: investigate making gardeners RESUMABLE (don't lose work when an agent stalls/dies) → garden design PR

**Context:** On 2026-06-25 a model quota/availability blip left **12 gardener agents hung**;
their in-progress work was lost and the jobs had to be **requeued and re-done from scratch** —
re-spending tokens on work already partly done. The maintainer wants to **investigate ways to make
gardeners resumable** so a stalled/killed/crashed agent's work can be **resumed** rather than
restarted. **The maintainer explicitly notes this may be more complexity than it is worth — so
weigh it honestly and recommend AGAINST it if the cost exceeds the benefit.** Wear the
**researcher** then **designer** role. Deliverable: a garden design PR. Do not change the live
fleet; this is a proposal.

## Investigate the approaches

1. **Claude session resumption.** The Claude Code SDK / `claude -p` supports session
   continuation (session IDs, `--resume`/`--continue`, context summarization across windows). Can
   a gardener **persist its session id** (in the journal/scratch keyed to the job base) so a fresh
   gardener **resumes the same session** after a stall/crash, picking up its context instead of
   starting cold? Investigate the actual SDK capabilities, what state survives, and the cost.
2. **Job-state checkpointing.** Have the agent **periodically persist progress** (intermediate
   commits to the work branch, a checkpoint record in the journal: "stage N of M done, head SHA,
   what remains") so a resuming agent reads the checkpoint and continues from the last completed
   step rather than re-running everything. Leans on the **gardening state machine** (which already
   does deterministic steps + claude for decisions) — resume at the last completed deterministic
   step.
3. **Idempotent / restartable job design.** Structure jobs so a fresh run cheaply detects work
   already done (e.g. the branch already has the commits, the test already passes) and skips it —
   making "requeue and re-run" nearly free without true resumption.
4. **Relationship to the fleet model.** Note the interaction with the in-flight `systemd-run`
   fleet-model investigation (a transient-per-job worker + resumability vs a resident loop).

## Weigh and recommend

For each approach: the mechanism, what it actually salvages on a stall, the complexity/maintenance
cost, the failure modes (a resumed session re-doing a partial side effect, a stale checkpoint), and
whether it is worth it vs the current "requeue + redo, with a stuck-agent reaper". **A clear-eyed
"not worth it, here's why" is an acceptable and valuable outcome.** Where one approach is cheap and
high-value (e.g. idempotent job design, or persisting a session id for free), call it out.

## Deliverable

A design doc (e.g. `designs/resumable-gardeners.md`) surveying the options with the
complexity-vs-benefit analysis and a recommendation (adopt which, if any), opened as a **DRAFT PR
against `kriskowal/garden`** (base `main2`, bot identity) for maintainer review — same flow as
garden#4. Report the PR number and the recommendation.

## Definition of done

A researched, honest complexity-vs-benefit analysis of gardener resumability (session resumption,
checkpointing, idempotent jobs), grounded in the actual SDK/state-machine capabilities, with a
recommendation, opened as a draft garden design PR. Report the PR number and the bottom-line
recommendation.
