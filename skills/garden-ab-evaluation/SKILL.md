---
created: 2026-05-14
updated: 2026-05-14
author: gardener
---

# Skill: garden-ab-evaluation

The A/B procedure for measuring whether the garden is improving as roles and skills accrete. Pick a design that already shipped through the bot-side chain, replay the same brief end-to-end through two garden checkouts (a historical ref and the current or a variant ref), then compare what each produced against what the maintainer ultimately landed. The output is a journal `result` entry naming both replay PRs, a comparison table, a qualitative judgment about which product better served the maintainer's interests, and a one-paragraph recommendation: continue, revert, repartition, or audit.

The skill is consumed by the [evaluator](../../roles/evaluator/AGENT.md) role (which reads the two PRs against the landed one and writes the comparison) and by the [liaison](../../roles/liaison/AGENT.md) (which prepares the two environments and dispatches the two replay chains plus the evaluator).

## When to use

- After a substantive meta-evolution lands (a new role, a non-trivial skill rewrite, a refactor of multiple roles' interlocks). The framing is "did the change pay off?".
- Periodically, as an "are we improving" sanity check. Cadence is maintainer-driven; there is no scheduled trigger today.
- In response to a maintainer-flagged regression (a recent dispatch produced worse output than a comparable older one).

Do not run this skill on a design under active development. The procedure requires a landed PR with the maintainer's review history attached as the reference truth; a draft PR has nothing to anchor to.

## Inputs

The dispatching liaison gathers these before invoking the skill:

- **Design under test.** A `designs/<slug>.md` file (in the consuming project) plus the PR that ultimately landed implementing it. The landed PR's body, the maintainer's review threads, and any follow-up commits are the reference truth.
- **Historical garden ref.** A git sha or tag on `kriskowal/garden@main` that predates the meta-evolution being evaluated. Picked so that the replay subagent's library, when checked out at this ref, is the version that existed *before* the change under test.
- **Current or variant garden ref.** A second git sha or tag on `kriskowal/garden@main` that includes the meta-evolution. Typically `main@HEAD`, but a feature branch tip works when the evaluation is for a not-yet-landed change.
- **Maintainer's notes on user-interest fidelity (optional).** A short paragraph from the dispatcher's brief naming what "user interest" meant for this design (a performance bound, an API shape, a doc readability target). When absent, the evaluator infers from the landed PR's review history.

These flow into the skill via the liaison's dispatch prompts to the two replay subagents and to the evaluator.

## State

None of the procedure's intermediate state is durable beyond the dispatch roots and the journal entries the replays and the evaluator write. The dispatch-root teardowns happen normally after each subagent returns (per [`skills/dispatch-worktree/SKILL.md`](../dispatch-worktree/SKILL.md)); the journal entries are the only persistent record.

## Procedure

The procedure has four steps, executed by the liaison except where named otherwise. The whole procedure is one engagement from the liaison's perspective; the journal entries chain through `refs:`.

### Step 1: Prepare two isolated environments

For each of the two garden refs (historical, current-or-variant):

1. Run `skills/dispatch-worktree/dispatch-prepare.sh builder <evaluation-slug>-<arm> <owner>/<repo> <design-base-branch>` to create the dispatch root. The `<arm>` is `historical` or `current` (or a short variant slug); the timestamp + short-id in the dispatch root's name keeps the two distinct.
2. The prepare script checks `garden/` out at `main` by default. **Reset both `garden/` and `journal/` to the chosen ref**:

   ```sh
   git -C "$DISPATCH_ROOT/garden"  fetch origin
   git -C "$DISPATCH_ROOT/garden"  reset --hard <garden-ref>
   git -C "$DISPATCH_ROOT/journal" fetch origin
   git -C "$DISPATCH_ROOT/journal" reset --hard <journal-ref-matching-the-garden-ref>
   ```

   The `<journal-ref>` is the latest journal commit whose `ts:` predates the `<garden-ref>`. Pin both to the same calendar moment so the replay subagent sees the library *and* the transcript as they existed at that moment. A mismatched pair (current garden plus historical journal, or vice versa) contaminates the result; see § Pitfalls below.

3. Note the dispatch-prepare script does not currently support a `--garden-ref` flag; the manual reset above is the documented workaround. A follow-up engagement may extend the script (see § Follow-ups); the skill ships without that extension.

The output of step 1 is two dispatch roots, each with `garden/`, `journal/`, and `project/` at the right refs. The liaison records both paths and refs in a `dispatch` journal entry naming the evaluation engagement.

### Step 2: Dispatch one replay subagent in each environment

The two subagents run the same brief: implement the design end-to-end, from inception through opening the PR to taking it out of draft for the first user review. The flow they execute is [`skills/pr-creation-flow/SKILL.md`](../pr-creation-flow/SKILL.md) in full, which (current as of 2026-05-18) is: builder opens the draft, assayer pushes tests (in concert), cleaner pushes coverage, judge dispatches the seventeen-seat jury panel concurrently and aggregates the verdict, fixer loop runs, judge un-drafts. Historical-arm replays at refs older than 2026-05-18 run the prior flow shapes (originally builder + assayer + juror-plus-saboteur panel + fixer + cleaner-un-drafts; 2026-05-14, builder + assayer + cleaner + six-seat then twelve-seat judge-dispatched panel + fixer-loop + judge-un-drafts; 2026-05-15, the same flow with a sixteen-seat code panel after four maintainer-modeled additions); the evaluator's comparison surfaces the flow-shape differences as part of the meta-evolution signal.

Practical shape:

- Each replay is **one dispatched builder** that the brief expects to be followed by an assayer, jury, fixer, and cleaner sequence. The liaison fans out each step against each replay's `project/` worktree (the `garden/` ref pinned in step 1 governs every dispatch in that arm).
- The brief is identical across arms: the same `designs/<slug>.md` content, the same prose, the same "user interest" notes. The two arms differ only in the garden ref the subagents read from.
- Each arm produces a draft-then-ready PR on the fork. The PRs land on separate branches (`eval-<slug>-historical-<short-id>`, `eval-<slug>-current-<short-id>`) so they coexist without colliding.
- The replay subagents do **not** know they are in an A/B evaluation. Their dispatch briefs read as ordinary builder, assayer, jury, fixer, and cleaner briefs. Blinding the subagents to the experiment is the cheapest defense against the subagent trying to please the experimenter.

Per-arm parallelism is a liaison decision: the two arms may run concurrently (cheaper wall-clock; the two arms share no working tree) or sequentially (lets the liaison spot a fatal error in arm one before paying for arm two). Default: concurrent.

When each arm has un-drafted the PR (the judge in the current flow; the cleaner in historical-arm replays pinned at refs older than 2026-05-14), the arm is done. The un-drafter's `result` entry names the PR; the liaison records both PR URLs and waits for both arms to land.

### Step 3: Dispatch the evaluator

A third subagent reads both replay PRs against the landed reference and produces the comparison. This is the [evaluator](../../roles/evaluator/AGENT.md) role; the dispatch prompt names:

- The landed PR's repo, number, and URL.
- The two replay PR URLs (without identifying which is historical and which is current; see § Blinding below).
- The design path and an optional pointer to the maintainer's user-interest notes.

The evaluator's job, per its role file:

1. Read all three PRs: file structure, diff size, test coverage, CI history, build success, the maintainer's review threads on the landed one (the *amount of unanticipated feedback* the real maintainer surfaced becomes the proxy for "gaps the bot missed").
2. Build a comparison table covering file count, line count, test count, CI runtime, review-feedback volume (number of distinct must-fix threads on the landed PR, mapped to which replay arms also missed them), and any project-specific metric the design called out.
3. Write a qualitative judgment on user-interest fidelity. Which of the two replays' shapes better serves what the maintainer ultimately asked for? "Better" is judgment, not a metric; the evaluator says why and cites the evidence.
4. Unblind (the liaison reveals which arm is which) and write a one-paragraph recommendation. If the historical arm outperforms, the recommendation names a candidate role/skill/cadence change. If the current arm outperforms, the recommendation is "the evolution paid off; continue." If they tie, the recommendation says so and proposes whether to repeat the experiment with a different design.

The evaluator's output is a journal `result` entry; the shape is in § Output.

### Step 4: Recommend a course of action

The evaluator's recommendation is the engagement's deliverable. The liaison reads it and:

- If the recommendation is "continue", the engagement closes with the journal `result`.
- If the recommendation names a meta-evolution (revert a role, repartition a skill, adjust a cadence), the liaison dispatches a [gardener](../../roles/gardener/AGENT.md) with the evaluator's recommendation inline. The gardener lands the change.
- If the recommendation is "repeat with a different design", the liaison stages a follow-up evaluation engagement.

The decision is the liaison's (with the user in the loop). The evaluator recommends; it does not commit role or skill changes itself.

## Output shape

The evaluator's journal `result` entry under `journal/entries/<YYYY>/<MM>/<DD>/<HHMMSS>Z-result-evaluator-<short-id>.md`:

```markdown
---
ts: <UTC>
kind: result
role: evaluator
project: <consuming-project-slug>
refs:
  - entries/<path>/<dispatch-entry-from-liaison>.md
  - entries/<path>/<arm-A-cleaner-result>.md
  - entries/<path>/<arm-B-cleaner-result>.md
---

# Evaluation: <design slug>

## Setup

- Design: `<owner>/<repo>/designs/<slug>.md`
- Landed reference: <repo>#<N>
- Arm A garden ref: <sha-or-tag>
- Arm B garden ref: <sha-or-tag>
- Replay A PR: <repo>#<X>
- Replay B PR: <repo>#<Y>

## Comparison table

| Metric                              | Landed | Replay A | Replay B |
| ----------------------------------- | ------ | -------- | -------- |
| Files changed                       |        |          |          |
| Net lines added                     |        |          |          |
| Tests added                         |        |          |          |
| CI runtime (cleaner-final)          |        |          |          |
| Review-feedback threads (landed)    |  N/A   |          |          |
| Threads each replay anticipated     |        |          |          |
| Design open-questions resolved      |        |          |          |

## User-interest fidelity

<one or two paragraphs naming, with citations, which replay's product
 better represented what the maintainer asked for, and why.>

## Recommendation

<one paragraph: continue, revert, repartition, audit, or repeat.>

Self-improvement: <one line per `skills/self-improvement/SKILL.md`.>
```

The dispatching liaison's closing `result` entry refers to the evaluator's entry and names the meta-evolution decision (if any).

## Pitfalls

### Subagent context contamination

A replay subagent with the historical `garden/` ref but the current `journal/` checkout has read the entire evolution's transcript. That contamination biases the comparison: the subagent sees lessons the historical version would not have had. **The historical arm's `journal/` must be reset to a journal commit whose timestamp predates the garden ref**, per § Step 1. The current arm has both pinned to current; no contamination concern, because the experiment's point is to measure the current version against the historical one with both seeing what they would actually see in their natural deployment.

When in doubt, dump both `garden/` and `journal/` refs into the dispatch's `dispatch` entry and into the evaluator's `setup` section; a future reader can audit the pinning.

### Non-determinism

The replay subagents are non-deterministic: temperature, tool selection, the order findings surface, all vary. A single A/B pair's result is suggestive, not conclusive. **For a confident verdict, run each arm two or three times and aggregate the results**. The evaluator's comparison table accommodates a `(median, n=3)` annotation per cell. The dispatching liaison decides the replay count; the budget is the constraint.

For low-stakes evaluations (the meta-evolution is a small skill tweak), one replay per arm is fine; flag the n=1 in the recommendation.

### Anchoring bias

If the evaluator knows which arm is historical and which is current, its read of "user-interest fidelity" drifts toward the version it expects to win. **Blind the comparison step**: the liaison's dispatch to the evaluator names the two PRs as "Replay A" and "Replay B" without saying which is which. The evaluator returns its comparison under those labels and writes the recommendation only after the liaison unblinds. The unblinding happens after the evaluator's comparison table and user-interest section are written, so the labels in those sections cannot be retrofit.

Operationally: the liaison's dispatch prompt to the evaluator carries the two arm refs as opaque labels; the liaison writes a separate journal `message` entry to itself (or holds the mapping in its own session state) naming which is which, and reveals it only after the evaluator's first `result` lands. The evaluator then writes a follow-up `result` adding the recommendation paragraph.

### Replay PRs polluting the project's PR list

The two replay PRs are not real product PRs; they are experiment artifacts. They sit in the project's PR list and could be mistaken for real work. **Mark them clearly**:

- PR title prefix: `[EVAL-<slug>-A]` or `[EVAL-<slug>-B]`.
- PR body opens with a one-line callout: "This is a garden A/B evaluation replay. See `<evaluator-result-entry-path>` for context. Do not merge."
- A label like `garden-evaluation` (if the project's label set supports it). Not load-bearing; the prefix is.

The un-draft still happens at the end of each arm (step 2 calls for the full pr-creation-flow), so the replay PRs *are* technically open for review. The maintainer should not review them. The bulletin's *Pending kriskowal reviews* section must filter the replay PRs out by title prefix; see § Bulletin handling below.

After the evaluator's `result` lands, the liaison closes both replay PRs with `gh pr close` (a per-action authorization the dispatching liaison originates because they are garden-meta artifacts, not upstream contributions). The replay branches are pruned in the same step.

### Bulletin handling

While the two replay PRs are out of draft and the evaluator has not yet closed the loop, the *Pending kriskowal reviews* section of `journal/README.md` would naturally surface them. The bulletin's *PR backlog* section should annotate them as "EVAL replay, do not review" and the *Pending kriskowal reviews* section should exclude PRs whose title starts with `[EVAL-`. The [journalist](../../roles/journalist/AGENT.md) is the role that maintains those sections; when this skill runs, the dispatching liaison writes a `message` to the journalist naming the in-flight evaluation slug so the journalist's next cycle filters the right PRs.

### Cost

Each arm runs a full pr-creation-flow: one builder, one assayer, the cleaner, the judge (which dispatches the seventeen-seat code panel concurrently internally), the fixer loop (variable count), and the judge's un-draft. That is one outer dispatch chain of about six stages plus seventeen juror dispatches per panel round; the total subagent count for a single A/B pair is around 40 to 60 depending on the fixer-loop iteration count. **Run this skill sparingly**: the framing is "a sanity check after a substantive meta-evolution", not a per-PR procedure.

### Design selection bias

The design under test must already be landed, which means it must already have survived the bot-side chain and the maintainer's review. The selection itself biases toward designs that *did* succeed. The skill cannot evaluate the garden against a design the garden never managed to ship. Frame the recommendation accordingly: this skill measures "how well did the garden do on a design it could ship"; it does not measure "what could the garden ship at all".

## Notes on routing

The procedure is split across roles for two reasons:

- **The evaluator is a clean-head comparison posture**, not a meta-evolution authoring posture. Its remit is read-and-judge; it does not edit roles or skills. The [gardener](../../roles/gardener/AGENT.md) is the one that lands meta-evolution; the evaluator hands the recommendation off and stops.
- **The liaison drives the dispatch fanout** because the procedure spans multiple subagent dispatches across two dispatch roots; that orchestration is the liaison's job, not a subagent's. The gardener cannot dispatch sub-subagents (per [`roles/gardener/AGENT.md`](../../roles/gardener/AGENT.md), the gardener is a writer of role and skill files, not an orchestrator), so wedging this procedure into a gardener engagement would either bloat the gardener's authority or require the gardener to re-enter the liaison's surface.

The trade-off was considered: inline the whole procedure into a single gardener engagement (no new role, less ceremony) versus a dedicated `evaluator` role plus liaison orchestration. The dedicated role won because the procedure is large (four steps, many dispatches, blinding discipline) and because the comparison posture is genuinely distinct from meta-evolution authoring. A future gardener pass may revisit this if the procedure simplifies.

## Follow-ups

These items are not in scope for the skill's first ship; they are candidate engagements once the skill is exercised:

- **Extend `skills/dispatch-worktree/dispatch-prepare.sh` with a `--garden-ref <ref>` flag.** Removes the manual `git reset --hard` in § Step 1 and makes the historical-arm preparation a single command. The current workaround is documented but error-prone (the journal-ref pinning is easy to forget); the flag would carry both `garden/` and `journal/` ref pins in one place.
- **Automate the replay-PR cleanup.** The two replay PRs and their branches accumulate; the manual `gh pr close` step belongs in a teardown skill once the pattern has run a few times.
- **Codify the comparison table's metric set.** The shape in § Output is a starting point; once a few evaluations have run, the metrics that turned out to matter become the canonical set and the ones that did not get dropped.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-05-14_: skill landed alongside the `evaluator` role. No evaluation has run yet; the procedure is unvalidated in practice. The first run on a real design under test should produce a notes-from-the-field entry capturing what the procedure missed and what the comparison table actually wanted in its metric set.
