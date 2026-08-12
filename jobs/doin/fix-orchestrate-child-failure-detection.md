---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fixer: orchestrate.sh read an explicitly FAILED child as a success — the halt policy never fired

## What happened (precipitating evidence, 2026-08-12)

Orchestration `dependabot-auto-merge-rollout` ran serial with
`on-child-failure: halt`. Child 2 (`dependabotany-sweep-approval-held`) hit its
deploy precondition and deliberately ended as a FAILURE — its report says so in
its own words, and it messaged the maintainer naming the blocker.

The orchestration nevertheless closed itself:

    jobs/tada/dependabot-auto-merge-rollout.md
    orchestration-status: complete
    "All 2 children reached a terminal state (serial). All children succeeded."

`All children succeeded` is false, and the halt policy — the entire reason
`--on-child-failure halt` exists — never fired.

## Root cause

`tada_failed()` (`scripts/jobs/common.sh:5129`) is LINE-ANCHORED:

    grep -qiE '^orchestration-(status:[[:space:]]*fail|failed:[[:space:]]*(true|yes))'

The child wrote its verdict as decorated prose in the report body:

    **Outcome: `orchestration-failed: true`** — this is the correct disposition …

The token is present and unambiguous to a reader, but it is mid-line inside
markdown emphasis and backticks, so `^` does not match. `child_state()` fell
through to `done`, and the orchestration recorded success.

Nothing is wrong with the child's reasoning or its behaviour — it did exactly
what its job body told it to do ("end the job with `orchestration-failed: true`
in the report"). The job body did not say "as a line-anchored frontmatter field,"
because nothing in the surfaces an agent reads says that.

## Why this matters beyond one orchestration

Every `on-child-failure: halt` policy is only as good as this predicate. A silent
false-success is the worst failure mode available here: `halt` exists precisely to
stop a serial chain from marching past a broken step, and a missed detection turns
it into `continue` without saying so. It also produces a completion record that
actively misleads the next reader.

## The fix — make the contract robust AND legible; do not just widen the regex

1. **Detection.** Make `tada_failed()` recognise the marker as agents actually
   write it. At minimum tolerate leading whitespace, markdown emphasis/backticks,
   and list bullets around the token. Do NOT make it so loose that prose merely
   *discussing* the marker (like this job body) trips it — prefer recognising the
   marker in the report's frontmatter OR a dedicated verdict line, and decide
   deliberately what the anchor is. Write the chosen contract into the function's
   comment.
2. **Emission.** Give the child a way to declare failure that cannot be
   mis-formatted: a helper (or a documented `complete-job.sh` flag) that stamps the
   field mechanically, the way the usage block is machine-stamped today. An agent
   free-typing a machine-parsed token into prose is the actual defect.
3. **Instruction.** `skills/orchestration/SKILL.md` and
   `scripts/jobs/post-plan.sh --orchestrated` guidance must state the exact
   required spelling/placement, so a job body can quote it instead of inventing it.
   Fix `roles/orchestrator/AGENT.md` too if it describes the marker loosely.
4. **Regression test.** Cover the decorated-prose case that failed here verbatim,
   plus a clean frontmatter case, plus a prose-mention case that must NOT trip.

## Also worth deciding (call it, don't silently skip it)

`orchestrate.sh` reported "All children succeeded" without checking anything
beyond terminal-state presence. Consider whether the completion record should
restate each child's disposition rather than asserting a blanket success, so a
future parser gap degrades into a vague report instead of a confident false one.

## Definition of done

- The false-success reproduced against the real artifact
  (`jobs/tada/dependabotany-sweep-approval-held.md` on `journal2`), then fixed.
- Detection, emission, instruction, and tests all addressed, or an explicit
  argument in the report for any leg deliberately not taken.
- Pushed to `main2`. Note in the report that a deploy is required before the fix
  is live on the fleet.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-12T14:22:13Z
