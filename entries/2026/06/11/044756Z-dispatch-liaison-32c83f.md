---
ts: 2026-06-11T04:47:56Z
kind: dispatch
role: liaison
host: endolinbot
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/liaison--32c83f
short_id: 32c83f
model: fable
refs:
  - endo-strategy-prompt.md
---

# dispatch: liaison (sub-orchestrator) — execute the endo-strategy-prompt three-workstream brief

Sub-liaison meta-orchestrator dispatch. Reads
`endo-strategy-prompt.md` (top-level garden file, copied into
dispatch root's garden worktree), then dispatches Workstreams A
+ B concurrently per the brief's §6 *Process* and C after A's
draft exists (C's road section blocks on A).

Model: fable (per maintainer's "Fable 5 High" directive).

The brief is addressed to "the liaison" and commissions:
- A: resequencing proposal (designer + scout + scholar)
- B: four persuasion essays (journalists)
- C: synthesis document (designer or journalist; blocks on A)

The dispatched sub-liaison itself dispatches the named roles in
its own dispatch roots, journals each, and reports back when
all four deliverables are landed as drafts with bulletin items.
