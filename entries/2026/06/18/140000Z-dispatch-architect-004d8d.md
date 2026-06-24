---
ts: 2026-06-18T14:00:00Z
kind: dispatch
role: liaison
host: endolinbot
to: architect
dispatch_root: /home/kris/dispatches/architect--004d8d
model: opus
prs: []
refs: []
---

# dispatch: architect — bootstrap kriscendobot/finbot repo (new garden + endo-style harness)

User directive: "I would like to create a new project repository
under kriscendobot tentatively named finbot. This will be a new
garden, with new roles and skills, that will be responsible for
running an analogous OODA loop to this software development
garden. However, unlike this garden, it will borrow ideas from
the Endo agent harnesses as well, to safely run subagents with
different contexts and capabilities, blending inference,
automation, automatic inference, automation born from
inference. This will require some research into Agoric's ymax
project, which consists of a planner and on blockchain contracts
and price oracles. We need a machine that can periodically
execute changes to a portfolio's balance and analyze
opportunities with other instruments. I am expecting that the
meat of this machine will be Ensemble Forecasting, automation
that we will need to grow that is capable of both executing and
producing compelling visual projections through iterative Monte
Carlo simulation of the histogram distributions of likely
outcomes for particular financial programs on a fixed time
horizon. Do not ask follow-up questions. Take your best
guesses."

## Scope

1. Research Agoric's ymax project (planner + on-chain contracts
   + price oracles).
2. Research Endo agent harness patterns (compartments,
   Far/Exo, captp, sandboxing primitives in endojs/endo).
3. Create new GitHub repo `kriscendobot/finbot` (public unless
   constraints suggest private).
4. Scaffold a garden-style structure patterned on
   `/home/kris/CLAUDE.md` (this garden) plus endo-style
   sandboxing primitives:
   - `CLAUDE.md` (top-level orientation, dispatch contract)
   - `roles/` (initial roles per best-guess; see below)
   - `skills/` (initial skills per best-guess; see below)
   - `journal/` (orphan branch sketch + the inbox/job-board
     contract)
   - `worktrees/` directory placeholder
   - `scripts/` for executable bits
   - `references/` placeholder for shelf imports
   - `designs/` for project-level designs
   - `dispatches/` placeholder
5. Take best guesses on initial roles + skills relevant to a
   finance-OODA garden. Suggested starting set:
   - **Roles** (analogues of garden roles + new finance-specific):
     - `liaison` (user-facing orchestrator, mirrors garden)
     - `steward` (autonomous orchestrator, mirrors garden)
     - `planner` (ymax-inspired portfolio rebalance proposer)
     - `executor` (sends on-chain transactions per planner
       directives)
     - `oracle-watcher` (reads price oracles, surfaces
       deviations + opportunities)
     - `forecaster` (Monte Carlo ensemble forecasting; produces
       histogram-distribution visual projections)
     - `analyzer` (opportunity-comparison across instruments)
     - `auditor` (safety review of every executed change before
       commit; analogue of barrister/justice)
     - `journalist` (records what happened, mirrors garden)
   - **Skills**:
     - `ymax-planner-protocol` (how the planner produces
       proposals)
     - `oracle-poll` (price oracle reading)
     - `monte-carlo-ensemble` (forecasting machinery)
     - `histogram-projection-render` (visual output)
     - `portfolio-rebalance` (atomic rebalance execution)
     - `opportunity-comparison` (cross-instrument scoring)
     - `dispatch-worktree` (mirror from garden; subagent
       isolation)
     - `inbox-drain`, `journal-sync`, `self-improvement`
       (mirrored from garden)
     - **Endo-borrowed**: `compartment-sandbox` (subagent
       capability attenuation), `far-exo-vending` (object
       capability boundaries between roles)
6. Use endo's sandbox primitives where they fit the
   "subagents with different contexts and capabilities" goal —
   e.g., a subagent that has only oracle-read capability cannot
   touch the executor. Reference endojs/endo's
   `packages/captp`, `packages/exo`, `packages/eventual-send`,
   `packages/lockdown` as the design inspiration.
7. Initial commit on `main` with the scaffolding.
8. Create the orphan `journal` branch as a stub.
9. Populate top-level `CLAUDE.md` patterned on the garden's
   (dispatch contract, layout, conventions, monitoring safety
   constraint adapted for on-chain context).

## Authorizations

- Create new repo via `gh repo create kriscendobot/finbot
  --public` (or private if surfaced as appropriate).
- Push initial scaffolding to `main` + `journal` (orphan).
- Modify your own dispatch worktree freely.
- Read endojs/endo source via gh api or local clone.
- Read Agoric ymax sources via gh api (likely
  `Agoric/agoric-sdk` or a standalone Agoric ymax repo;
  search for it).

## Out of scope

- Do NOT touch any endo-but-for-bots or garden state beyond
  reading.
- Do NOT push commits to other repos.
- Do NOT spin up actual on-chain infrastructure (this is
  scaffolding only).
- Do NOT add live secrets/credentials to the repo.

## Deliverable

A `result` entry under `journal/entries/2026/06/18/` naming:
- The new repo URL.
- Top-level file inventory (CLAUDE.md, roles/, skills/, etc.).
- Initial commit SHA(s).
- The orphan journal branch sha.
- Key design decisions (e.g., role taxonomy, endo-pattern
  borrowings).
- A `Self-improvement: ...` line.
- **Recommended next stage**: probably `next: liaison` (user
  reviews the scaffolding + iterates).

End your turn with a concise summary back to the orchestrator.
