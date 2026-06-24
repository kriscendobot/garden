---
ts: 2026-06-18T14:07:01Z
kind: result
role: architect
project: finbot
refs: []
---

# Bootstrapped kriscendobot/finbot

Created the new repo and landed the initial scaffolding on `main` plus an orphan `journal` stub. Pattern-borrowed from this garden's role/skill/dispatch architecture; shape-borrowed from Agoric ymax (planner + on-chain contract + price-oracle); safety-borrowed from the Endo family (compartments + Far/Exo + CapTP).

## Repo

- URL: <https://github.com/kriscendobot/finbot>
- Visibility: public
- Default branch: `main`
- Branches:
  - `main` at `426403b24b213d64be700525f69fb3335d5b628e` (initial scaffolding commit).
  - `journal` at `df5ccffa4ee4d25fc5b7cac787a911916396fc46` (orphan; one-file README stub).

## Top-level inventory on main

- `CLAUDE.md`: liaison-facing operating brief + dispatch contract.
- `README.md`: human-facing intro.
- `LICENSE` (Apache-2.0).
- `.gitignore` (Node + secrets + agent-state).
- `roles/COMMON.md` + ten role files:
  - `liaison/`, `steward/` (the two orchestrator postures).
  - `planner/`, `executor/`, `auditor/` (the decide-and-act chain).
  - `oracle-watcher/`, `monitor/` (observe).
  - `forecaster/`, `analyzer/` (orient).
  - `journalist/` (transcript).
- `skills/`: thirteen skill stubs:
  - `dispatch-worktree`, `inbox-drain`, `journal-sync`, `self-improvement` (the garden-mirrored basics).
  - `ymax-planner-protocol`, `portfolio-rebalance`, `opportunity-comparison`, `oracle-poll` (ymax-borrowed).
  - `monte-carlo-ensemble`, `histogram-projection-render` (forecaster).
  - `compartment-sandbox`, `far-exo-vending`, `pre-execution-audit` (endo-borrowed; the safety story).
- `designs/` with three stubs: `ymax-integration.md`, `ensemble-forecasting.md`, `cap-attenuation.md`.
- `scripts/README.md`, `references/README.md`, `worktrees/README.md`: placeholders pointing at the patterns to follow when those directories grow.
- `dispatches/.gitkeep`, `worktrees/.gitkeep`, `references/.gitkeep`: empty markers.

## Key design decisions

- **OODA partition.** Roles map cleanly onto observe (oracle-watcher, monitor), orient (analyzer, forecaster), decide (planner), act (executor). The `auditor` sits between decide and act as the irreversibility gate; the `journalist` records the transcript across all phases.
- **Two-posture orchestration, mirrored from the parent garden.** `liaison` (excess authority, in-loop) and `steward` (bounded authority, autonomous). The wallet boundary maps onto the posture boundary: the steward never originates `live_authorized: true`; only the liaison does, after explicit user confirmation.
- **Dry-run by default for the executor.** Live mode requires `live_authorized: true` in the dispatch frontmatter; without it the executor refuses to read the wallet keystore even if the path is provided.
- **Endo-borrowed capability attenuation.** Each role's code runs in an SES Compartment with explicit `globals` and `modules` maps; cross-compartment capabilities are vended as `Exo` (`Far` + `InterfaceGuard`) per `skills/far-exo-vending`. The wallet Far exists only in the executor's compartment, only in `--live`, only for the dispatch's lifetime. The compartment + Far pattern moves safety from "the LLM correctly follows the prompt" to "the runtime cannot reach the wallet unless the orchestrator has explicitly vended it".
- **ymax direct adoption where possible.** The planner imports `@agoric/portfolio-api`'s `computeTargetBalances` and mirrors the shape of `services/ymax-planner/src/engine.ts` + `packages/portfolio-contract/tools/plan-solve.ts`. The integration design lays out three paths (use ymax on-chain, mimic against paper, mimic against non-Agoric); recommendation is Phase 1 = paper, Phase 2 = ymax-on-Agoric for Agoric portfolios + mimic elsewhere for others.
- **Deterministic forecasts.** Same `program + horizon + ensemble_size + seed + input_distributions_hash` produces byte-identical histograms. Quantile estimates carry bootstrap confidence bands. The auditor's reproducibility invariant relies on this.
- **Citation chain.** Every step in a planner proposal cites at least one forecaster entry and one analyzer entry; the auditor rejects uncited plans. The audit trail extends from oracle reading -> analyzer -> forecaster -> planner -> auditor -> executor with each artifact pointing back to its inputs.
- **No PR workflows on finbot's own repo.** Both `main` and `journal` push directly to origin (`github.com/kriscendobot/finbot`). The journal is orphan; GitHub may offer "create PR for journal" links after a push, ignore.

## Key ymax research findings

- `services/ymax-planner/`: off-chain planner. Cosmos-RPC subscriber + vstorage reader; `engine.ts` is the main loop; `plan-deposit.ts` exports the three plan entry points (`planDepositToAllocations`, `planRebalanceToAllocations`, `planWithdrawFromAllocations`).
- `packages/portfolio-contract/`: on-chain contract holding per-portfolio state in vstorage; offer handlers for open/rebalance/withdraw; integrates with USDN, Aave (via Axelar GMP), Compound (via Axelar GMP); cross-chain accounts (Agoric Local, Noble ICAs).
- `packages/portfolio-contract/tools/plan-solve.ts`: the rebalance-step solver. `planRebalanceFlow` is the entry point; `NoSolutionError` names infeasibility within risk bounds.
- `packages/portfolio-api/`: shared API. `computeTargetBalances` (target-balance helper), `PROD_NETWORK` (network spec), `places.ts` / `instruments.js` / `constants.js` (identifiers), `evm-wallet/eip712-messages.js` (EVM-side EIP-712 handling).

## Key endo borrowings

- `packages/ses/` (lockdown + compartments) → `skills/compartment-sandbox/SKILL.md`.
- `packages/exo/` (InterfaceGuard-validated Far) → `skills/far-exo-vending/SKILL.md`.
- `packages/captp/` (capability transfer across process boundaries) → cited by `far-exo-vending` for the executor's separate-worker live mode.
- `packages/eventual-send/` (`E` and `HandledPromise` for promise-pipelining) → cited by `far-exo-vending`.
- `packages/compartment-mapper/` (load-time compartment policy) → cited by `compartment-sandbox` for the role-specific globals/modules maps.
- `packages/daemon/` (host that vends Far refs to guest programs in hardened workers) → cited by `compartment-sandbox` as the model for the executor's worker pattern.

## Scope deferrals

These were intentionally not done in this bootstrap (per *Out of scope*):

- No on-chain infrastructure: no live wallet keys, no RPC URLs, no signing infrastructure.
- No actual implementations of the skills; every SKILL.md is a stub that names the contract and points at the source it borrows from.
- No `scripts/` executables: `scripts/README.md` names the pattern to grow into; the first dispatch that needs an executable adapts the parent garden's.
- No `job-board` skill landed yet (referenced by the steward role and `CLAUDE.md` § Dispatch contract); the first liaison engagement that needs distributed work mirrors `/home/kris/skills/job-board/SKILL.md` into `skills/job-board/SKILL.md`.
- No bot identity set in the local config (`git -C <finbot-root> config user.name/email`); the first host that runs the steward will do this per `CLAUDE.md` § Host environment.
- No projects/<slug>/README.md context documents in the journal yet; the first project finbot manages (the maintainer's actual portfolio) lands the first one.
- No `WORKTREES.md` document; the parent garden's pattern is cited inline in the relevant files but not extracted into a top-level document. Extract when the directory grows enough to warrant it.

## Recommended next stage

`next: liaison`

The maintainer reviews this scaffolding and iterates on:

1. Which roles need their AGENT.md tightened or split.
2. Which skill stubs to grow first (likely candidates: `ymax-planner-protocol` and `monte-carlo-ensemble`, since those are the central novelty; or `oracle-poll` since that is the first thing to actually run).
3. Whether to import a `references/garden/` shelf so the liaison can browse it without leaving the repo.
4. Whether to land the `job-board` skill now or defer until concurrent stewards are warranted.
5. Whether to start with a paper portfolio (Path B in the ymax-integration design) or to wire directly into the maintainer's Agoric portfolio (Path A).

Self-improvement: noted in field that bootstrapping a sibling garden was straightforward by pattern-matching this garden's layout, but the references-shelf machinery (a `scout` role + a clone-and-pin convention) is implicit here and may be the first cross-garden gap; flagging for the liaison once finbot wants to import its first reference shelf.
