---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gauntlet early termination: summarize the unaddressed must-fix requests for a budget decision

Maintainer request (2026-10-09): when a gauntlet terminates early, produce a summary of the
**must-fix requests that were left unaddressed**, so the maintainer can decide whether to
**inject additional budget and resume**.

## What exists, and the gap (verify before changing)

`scripts/jobs/gauntlet.sh` already ends a non-passing gauntlet in a terminal state and posts a
PR comment through `gauntlet_terminal_comment` plus a coalesced maintainer notice through
`gauntlet_notify`. Terminal states today: `review-budget-reached`, `halted`,
`parked-ci-billing` (and `held-draft`, where the panel passed, so it owes no must-fix list).
The only must-fix content is a COUNT, `last panel unaddressed must-fix: N`, scraped from the
last panel report's `must-fix items (N):` line. A maintainer cannot decide on that. Resume
exists as `gauntlet.sh --resume-from-stage <g> <stage> [--iteration N]`.
`designs/gauntlet-panel-fix-nonconvergence.md` shows why a count misleads: the panel often
raises a different set of findings each round, so more rounds frequently do not converge.
The summary has to let the maintainer tell a stuck-on-real-defects gauntlet from a
moving-target one.

## What to build

1. **The summary.** On every early termination that left the last panel's must-fix items
   unfixed, compute, deterministically and with no LLM in the gauntlet process, a bounded
   summary built from the panel and fix stage reports in `jobs/tada/`:
   - each unaddressed must-fix request: juror seat, file and line if given, the request text
     (truncated to a fixed length), and the round it was first raised;
   - for each, whether it is **persistent** (raised in two or more rounds and never
     resolved), **new in the last round**, or addressed-then-reintroduced;
   - the per-round trend: findings raised, fixed, and carried over, so a flat or churning
     series is visible at a glance;
   - cost so far (the usage-meter figure for the gauntlet's jobs, if obtainable without new
     instrumentation) and rounds spent against the cap;
   - a plain verdict line: `converging`, `stuck on N persistent items`, or `moving target`,
     from stated, tested rules (not a model's opinion);
   - the exact resume command, and what budget it adds. If no single documented command both
     raises the round budget (`max_iterations`) and resumes, add the smallest one that does
     (for example `--add-rounds N` on the existing resume form), and document it.
2. **Where it goes.**
   - The PR terminal comment: keep the existing one-line receipt, append the summary inside a
     collapsed `<details>` block, bounded in size, with the same idempotency marker so a
     re-driven finish does not post twice.
   - The maintainer inbox: the existing coalesced notice gains the summary and the resume
     command, so the decision is made from the inbox without opening GitHub.
   - A journal record next to the gauntlet record, so the liaison, the muster, and the arc
     supervisors read the same facts without parsing a GitHub comment. For
     `kriscendobot/minion.town` PRs the maintainer does not review individual PRs (standing
     order, journal `entries/2026/10/07/203746Z-message-gardener-a253b1.md`), so the arc
     supervisors act on this record: say so in `roles/` or `context/` where they will read it.
3. **Prompt-injection discipline.** Must-fix text derives from juror output about untrusted PR
   content. Treat it as DATA: strip control characters and markdown that could forge a
   heading, link, or `@`-mention, truncate, and fence it. Never let it reach a shell, a job
   body that grants authority, or an LLM prompt as an instruction.
4. **Fail soft.** A parse failure on an old-format panel report yields the existing count line
   and a note that the list was unavailable, never a wedged tick or a missing terminal state.
5. **Tests.** Extend `scripts/jobs/test/gauntlet-test.sh` with fixtures for each terminal state,
   a persistent item, a moving-target series, an old-format report, an oversize item, and a
   hostile item. Update the operator documentation and the gauntlet section of the relevant
   skill.

Land on `main2` directly (the garden's own repo takes no PR workflow). Post a journal message
summarizing the change and one worked example rendered from a real past halt, for instance
`endojs-endo-but-for-bots-pr995-gauntlet`, so the maintainer can judge the summary's usefulness.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-09T06:52:26Z
