---
ts: 2026-06-18T14:32:00Z
kind: dispatch
role: liaison
host: endolinbot
to: architect
dispatch_root: /home/kris/dispatches/architect--e00710
model: opus
prs: []
refs:
  - https://github.com/kriscendobot/finbot
  - entries/2026/06/18/140000Z-dispatch-architect-004d8d.md
  - entries/2026/06/18/140701Z-result-architect-ef2880.md
---

# dispatch: architect — cut 2 on finbot (harness in place; Pi-based)

User directive: "For the next cut on finbot, please dispatch a
subagent to create a harness in place based on Pi harness that
has a tool call surface that can support the various roles and
skills, as well as a driving loop that ensures it makes
continuous progress. It will need to ability to create and
monitor subagents with specialized roles, context, and
capabilities, especially the ability to record its
observations. It will need a message bus between agents."

## State at dispatch time

- **Repo**: https://github.com/kriscendobot/finbot
- **main** at the bootstrap commit `426403b2` (architect 004d8d).
- 10 roles + 13 skill stubs + 3 design stubs scaffolded.
  No executable harness yet.

## Task

Implement the runtime harness:

1. **Research "Pi harness"** — the user did not specify which
   Pi. Best guesses to investigate (use judgment):
   - **Endo's Pi** — search endojs/endo for "pi" prefix
     packages (e.g., `packages/pi-*`, scripts, or design docs
     mentioning "pi").
   - **Agoric Pi** — search Agoric/agoric-sdk for "pi".
   - **kriskowal's repos** — `gh search repos --owner=kriskowal Pi`,
     `gh search code --owner=kriskowal Pi harness`.
   - **Pi-calculus / process calculus** — if all the above
     return nothing concrete, fall back to the
     process-calculus-inspired-harness reading: a harness
     where subagents are processes that communicate via
     typed channels (the message bus), and the driving loop
     schedules.
   - Document the research findings inline in the result
     entry. If "Pi harness" resolves to a specific codebase,
     pattern on it; otherwise design from first principles.
2. **Clone the finbot repo**:
   `git clone git@github.com:kriscendobot/finbot.git project`
   (into your dispatch root).
3. **Implement the harness in JavaScript** (or TypeScript;
   match endojs/endo's conventions — JS + JSDoc types is fine
   for Endo-pattern code). Use ESM. Land in
   `packages/harness/` or similar.

### Harness requirements

- **Tool call surface**: each role's skills exposed as
  callable tools. Suggested shape: each skill exports
  `{ name, description, inputSchema, run }`. The harness
  loads all skills, builds a tool registry, and exposes the
  registry to agents.
- **Driving loop**: a main OODA tick (observe → orient →
  decide → act). Each tick:
  - Observes (oracle-watcher polls; inbox drain; new event
    surfacing)
  - Orients (analyzer scores opportunities)
  - Decides (planner produces a proposal; auditor reviews
    before fire)
  - Acts (executor dispatches; defaults dry-run)
  - The loop persists across ticks; state lives in the
    journal.
- **Subagent spawning**: support `spawn(role, context, caps)`
  where:
  - `role` selects the AGENT.md and skill subset
  - `context` is a frozen object passed in (per
    cap-attenuation)
  - `caps` is the Far/Exo capability set the subagent can
    reach (per `compartment-sandbox` and `far-exo-vending`
    skills from cut 1)
  - Returns a handle for monitoring + recording observations
- **Message bus**: persistent inbox + job-board pattern
  (mirror garden's two-channel bus):
  - Per-role inbox (`journal/inboxes/<host>/<role>.md`)
  - Job board (`journal/jobs/{open,claimed,done}/...`)
  - Use git commits + pushes as the serialization point
    (mirror garden's pattern).
- **Observation recording**: every subagent action and
  observation lands in the journal under
  `journal/entries/<date>/<HHMMSS>-<kind>-<role>-<slug>.md`.
  Use the garden's journal-sync + journalist patterns.
- **Capability attenuation**: subagents run in attenuated
  contexts. For now, since Node lockdown + Compartment is
  heavyweight, mark this as a v0 hook (e.g., a `harness/sandbox.js`
  that takes a list of allowed globals and a list of vended
  Far refs, but starts with a permissive impl that just
  enforces "no access to unspecified things in the spawn
  prompt"). Document the v1 path: replace with
  `@endo/compartment-mapper` + lockdown.

### Suggested file shape

```
packages/harness/
  README.md
  index.js                — exports { runLoop, spawn, registerSkill, ... }
  loop.js                 — OODA driving loop
  spawn.js                — subagent spawning with cap attenuation hook
  tools.js                — tool registry + tool-call surface
  message-bus/
    inbox.js              — inbox-drain + post
    job-board.js          — claim/post jobs
    journal-sync.js       — commit + push
  observation/
    record.js             — write journal entries
    monitor.js            — observe running subagents
  sandbox/
    permissive.js         — v0 impl; document v1 path to @endo/compartment-mapper
  schemas/
    tool.js               — tool definition shape
    spawn.js              — spawn parameters shape
  test/
    loop.test.js
    spawn.test.js
    tools.test.js
    message-bus.test.js
package.json              — name @finbot/harness or similar
```

### Auxiliary work

- **`bin/finbot`** at repo root: a tiny entry script that
  imports `@finbot/harness` and runs the driving loop. Allow
  `bin/finbot --dry-run` (default), `bin/finbot --once`
  (single tick), `bin/finbot` (persistent loop).
- **`package.json`** at repo root: declare workspace
  packages.
- **`yarn.lock`** if you bring in any dependencies.
  Prefer to start dependency-free (no install needed for v0).
- Wire the 10 roles' AGENT.md to the harness — they don't
  need to be runnable yet; just be readable by the harness
  (e.g., `loadRole(name)` returns the parsed AGENT.md).
- Likewise for the 13 skill stubs.
- Add **integration test** showing one OODA tick: spawn an
  oracle-watcher, observe a stub event, spawn an analyzer,
  produce a stub proposal, spawn the auditor, audit returns
  ok, spawn the executor with `--dry-run`, log the simulated
  action.

### Commit shape

Per logical unit, with checkpoint push after each:
1. `feat(harness): tool registry + skill loader`
2. `feat(harness): OODA driving loop with persistent state`
3. `feat(harness): subagent spawn with cap-attenuation hook`
4. `feat(harness): message bus (inbox + job board) with journal serialization`
5. `feat(harness): observation recorder + monitor`
6. `feat(harness): permissive v0 sandbox + design path to compartment-mapper`
7. `test(harness): integration test for one OODA tick`
8. `feat: bin/finbot entry script + workspace package.json`

### CRITICAL: checkpoint discipline (rate-limit safety)

Push after each logical commit. If you approach the budget
ceiling, STOP and write a partial result entry. Do NOT batch
multiple commits to a single push at the end.

## Authorizations

- Clone https://github.com/kriscendobot/finbot.
- Push commits to `main` directly (this is the bot's own
  repo; no PR workflow needed for the initial cuts).
- Push journal entries to the finbot's `journal` orphan
  branch.

## Out of scope

- Do NOT spin up actual on-chain transactions or wallet
  signing.
- Do NOT add real RPC URLs or live keys.
- Do NOT publish to npm.
- Do NOT touch garden, endo-but-for-bots, or other repos.

## Deliverable

A `result` entry in the GARDEN's journal at
`/home/kris/dispatches/architect--e00710/journal/entries/2026/06/18/`
naming:
- Per-commit substance.
- Pi harness research findings (or fallback to first-principles
  design).
- Total file inventory under `packages/harness/`.
- Tool call surface shape (e.g., the tool definition schema).
- Driving loop tick shape (the OODA implementation).
- Subagent spawn shape (cap attenuation hook).
- Message bus shape (inbox + job board, journal-serialized).
- Observation recorder shape.
- Integration test results.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (user reviews
  + iterates).

End your turn with a concise summary back to the orchestrator.
