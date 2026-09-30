---
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T03:47:10Z cleared=none -->

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book, chapter 7: Procedures and workflows

One chapter of a multi-part "book" (orchestration `garden-book-orch`). Write
to `journal/projects/garden-book/ch7-procedures-workflows.md` as Markdown.

## Ground this in real sources

- `skills/pr-creation-flow/SKILL.md` in full — this is the spine of "the
  gauntlet": the stage order (build → assayer → cleaner → panel → fixer loop
  → appellate → un-draft), draft discipline, the design-only-PR variant, the
  next-stage-owed heuristic, and the manual-gauntlet-trigger regime
  (`designs/manual-gauntlet-trigger.md`) that makes "run the gauntlet #N" the
  sole ordinary trigger.
- `skills/panel/SKILL.md` and `skills/panel-review/SKILL.md` — the code vs.
  design panel, the seat lists (cite the real seat count and composition,
  don't estimate), the disposition rubric, the panel-fixer loop, the
  appellate pass.
- `skills/orchestration/SKILL.md` in full — the decompose/park/record/watch
  pattern, serial vs. parallel, the failure policy, why it exists alongside
  the lighter `blocked_on` + unblock primitive.
- `skills/chained-followup/SKILL.md` — the D→N→F indirection pattern for a
  follow-up whose trigger is a second-order event (a design maturing into a
  build), distinct from plain `blocked_on`.
- `roles/boatman/AGENT.md` and `CLAUDE.md` § The ferry — how an approved
  change actually gets carried upstream under the maintainer's identity, and
  why this is the one work request the liaison never posts to the board.
- `designs/gardening-state-machine.md` for the architectural framing tying
  these together.

## What this chapter should cover

1. **The gauntlet, end to end.** Walk the full chain a PR goes through from
   `build` to landing in the maintainer's review queue, naming every stage
   and who/what runs it (a script the gardener supervises, not a dispatched
   subagent per stage). Explain draft-vs-ready-for-review as the load-bearing
   signal, and the manual-gauntlet-trigger regime's effect on when the chain
   actually runs.
2. **The panel**, concretely: how it senses code vs. design, roughly how
   many seats each carries, the disposition categories (must-fix/should-fix/
   summary-fix/follow-up/acknowledge/drop), and the loop's actual exit
   condition ("no in-scope must-fix," not "all complaints addressed").
3. **Orchestration**, as the standing pattern for multi-part work: when to
   reach for it vs. a plain `blocked_on` chain, serial vs. parallel, the
   failure policy, and a concrete walkthrough of one orchestration's
   lifecycle from `post-plan.sh --orchestrated` through the terminal report.
4. **Chained follow-ups**, for the case an orchestration can't express: a
   trigger that depends on a second-order event (a design maturing into a
   build) rather than a board completion.
5. **The ferry**, as the one deliberately out-of-band workflow: why it's
   staged to `journal/jobs/ferry/` rather than the board, and what
   authorization it requires.

Name real script paths (`scripts/jobs/gardening/garden-pr.sh`,
`scripts/jobs/gardening/panel.sh`, `scripts/jobs/post-orchestration.sh`,
`scripts/ferry.sh`) rather than describing mechanisms abstractly.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T04:23:17Z
