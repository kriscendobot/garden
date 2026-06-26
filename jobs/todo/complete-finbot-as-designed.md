# GOAL: complete kriscendobot/finbot as designed (end-to-end dry-run OODA loop)

Wear the **builder** role, driving toward a **goal** (assess → build the critical path →
decompose the rest), not a single task. **Goal: bring `kriscendobot/finbot` to completion as
designed** — a working observe→orient→decide→act loop over its simulator, in **dry-run**. Bot
repo, bot identity (kriscendobot). Follow finbot's own conventions (read its `CLAUDE.md`).

## The design (read first)

`README.md`, `CLAUDE.md`, and `designs/{cap-attenuation,ensemble-forecasting,ymax-integration}.md`.
finbot is a self-driving portfolio garden: roles **oracle-watcher → monitor → analyzer →
forecaster → planner → auditor → executor**, with capability-attenuation safety (Endo
compartments/Exo/Far; the wallet reference reaches only the executor), pre-execution audit
invariants, and **dry-run-first** execution.

## Current state (verified)

Built with tests: `packages/harness/` (loop, message-bus, observation, sandbox, spawn, tools,
schemas) and `packages/simulator/` (forecast, metrics, portfolio, price-feed, runner, world,
self-improvement). The 10 roles + 13 skills + 4 designs exist as briefs/specs. **The gap is
wiring the roles into a working end-to-end loop** atop the harness + simulator.

## Drive toward completion

1. **Assess the gap precisely**: what the design calls for vs. what the harness/simulator/roles
   actually provide. Identify the critical path to an end-to-end **dry-run** OODA cycle:
   oracle-watcher emits an opportunity → analyzer scores → forecaster (Monte Carlo via simulator)
   projects → planner (ymax-shaped) proposes a rebalance → auditor checks invariants → executor
   **dry-runs** the action — all over the simulator world, recorded in the journal.
2. **Build that critical path** to working + tested: implement/wire the missing role logic and the
   loop integration on the harness, plus the **cap-attenuation** safety (subagents in attenuated
   compartments; wallet ref confined to the executor) and the **auditor invariants**
   (budget/NAV-step/forecast-citation checks). Keep all tests green; add tests for new wiring.
3. **Decompose the remainder**: this is large — after a solid pass landing the end-to-end dry-run
   loop, **post follow-on `finbot-<area>` jobs** for the rest (e.g. additional instruments,
   richer forecasting, daemon/scripts wiring, the steward/journalist loops) and report the
   roadmap. Goal-oriented: prioritize a demonstrably-working dry-run cycle over breadth.

## Safety bounds (hard)

- **Dry-run only. NEVER fire live on-chain transactions and never wire a real wallet/private key
  or real funds.** The executor's live mode stays gated behind explicit per-job maintainer
  authorization (per the design) — this job does NOT authorize it. Build + prove on the simulator.
- **No agoric-sdk work.** finbot borrows the **ymax pattern** from public references only; the
  work is on `kriscendobot/finbot` alone. Do not modify agoric-sdk and do not require the internal
  ymax-web repo — design from the public ymax-planner/portfolio-contract shape, flag where internal
  detail would refine rather than fabricating it.
- End reviewable increments with the standard summary (per finbot's convention: PR + summary
  comment, or a clear journal/commit summary if finbot pushes directly).

## Definition of done

finbot runs an **end-to-end dry-run OODA cycle** over its simulator — oracle→analyzer→forecaster→
planner→auditor→executor(dry-run) — with cap-attenuation + audit invariants in place and tests
green, plus follow-on jobs posted for the remaining designed scope and a completion roadmap
reported. Report what now works end-to-end, what was decomposed into follow-ons, and confirm the
executor never touched a live wallet.

Posted by the liaison on behalf of the maintainer.
