---
ts: 2026-06-18T15:21:20Z
kind: result
role: architect
project: finbot
refs:
  - entries/2026/06/18/140701Z-result-architect-ef2880.md
---

# Built the finbot runtime harness (cut 2)

Landed a working `@finbot/harness` package on `kriscendobot/finbot@main` plus a `bin/finbot` entry script. The harness implements the OODA driving loop, a Pi-shaped tool-call surface, subagent spawn with capability attenuation, a two-channel message bus over the journal, an observation recorder, and a permissive v0 sandbox naming the v1 compartment-mapper path. 35 unit + integration tests pass on Node 22; the bin script runs end-to-end against the real finbot journal.

## Pi harness research

"Pi" resolves to **`badlogic/pi-mono`** (`@earendil-works/*` npm scope), a terminal-first coding-agent harness authored by Mario Zechner. Mirror at `earendil-works/pi`. The endopi reference design in `endojs/endo-but-for-bots` (`designs/endopi.md`) was the most useful map of Pi's surface, since it already enumerates Pi's tool model, agent loop shape, event stream, session format, extension model, skill format, and provider registry. Pi's agent loop lives at `badlogic/pi-mono/packages/agent/src/agent-loop.ts`; the tool type and event union at `packages/agent/src/types.ts`. Key idioms I pattern-borrowed:

- `Tool { name, description, inputSchema, run }`: identical to Anthropic's tool-use schema and what `@earendil-works/pi-ai`'s `Tool` type exposes.
- `AgentEvent` union: `agent_start`, `turn_start`, `message_start`, `message_end`, `tool_execution_start`, `tool_execution_end`, `turn_end`, `agent_end`. Mirrored in `spawn.js`'s event stream.
- The agent loop is two nested loops: an outer loop for queued steering messages, an inner loop for assistant message + tool calls + tool results until the assistant produces no more tool calls. Mirrored in `runLoop()` in `spawn.js`.
- `beforeToolCall` / `afterToolCall` hooks for capability attenuation. v0 simplifies this to a per-spawn capability subset filter; v1 can grow per-call hooks if needed.
- Markdown skills with frontmatter (agentskills.io spec). Mirrored in `tools.js`'s `splitFrontmatter` + `parseFrontmatter`; SKILL.md files become tools.

The parent garden's two-channel message bus (inbox + job board) is the second pattern source; transliterated from bash to Node verbatim. The endo daemon family (compartments + Far/Exo + compartment-mapper) is the third, named as the v1 path for `sandbox/permissive.js`.

## Per-commit substance

Eight commits on `main`, pushed individually for checkpoint discipline:

1. `064de2b feat(harness): tool registry + skill loader` — package.json + README + index.js + schemas/{tool,spawn,index}.js + tools.js. `loadTools(skillsDir)` walks `skills/`, parses SKILL.md frontmatter, builds the registry; `toolsToLlmShape` renders Anthropic-compatible tool list.
2. `2fcc716 feat(harness): message bus (inbox + job board) with journal serialization` — message-bus/{inbox,job-board,journal-sync,index}.js plus observation/{record,monitor,index}.js. The git push to `origin/journal` is the serialization point; `commitAndPush` adds via parent directory so `git mv` upstream of the call works.
3. `86c5c77 feat(harness): subagent spawn with cap-attenuation hook + permissive v0 sandbox` — spawn.js + sandbox/permissive.js. `spawn(params, ctx)` loads `roles/<role>/AGENT.md`, attenuates the tool surface, drives the Pi-shaped agent loop, returns a `SpawnHandle`.
4. `1cd6d2d feat(harness): OODA driving loop with persistent state in journal` — loop.js. `runOnce` drives one tick (observe -> orient -> decide -> act); `runPersistent` wraps in a cadence loop.
5. `f724852 test(harness): unit tests for tools, spawn, message-bus, loop` — 32 unit tests across four files.
6. `3d876de test(harness): integration test for one OODA tick end-to-end` — 3 end-to-end tests against a real synthetic-finbot + synthetic-journal worktree.
7. `2f374c9 feat: bin/finbot entry script + workspace package.json` — root package.json with workspaces + `bin/finbot`.

## File inventory under `packages/harness/`

```
packages/harness/
  package.json
  README.md
  index.js                          public exports + run() top-level driver
  loop.js                           OODA driving loop (runOnce, runPersistent)
  spawn.js                          subagent spawn primitive
  tools.js                          tool registry + SKILL.md loader
  sandbox/
    permissive.js                   v0 cap attenuator + v1 compartment-mapper stub
  schemas/
    index.js
    tool.js                         ToolDef shape + assertToolDef + toolResult
    spawn.js                        SpawnParams shape + assertSpawnParams
  message-bus/
    index.js
    inbox.js                        postToInbox + drainInbox
    job-board.js                    postJob + claimJob + completeJob + listOpenJobs
    journal-sync.js                 commitAndPush + runGit
  observation/
    index.js
    record.js                       recordEntry (writes journal entries/)
    monitor.js                      monitorSubagent + recordSubagentTrace
  test/
    tools.test.js                   12 tests
    spawn.test.js                   8 tests
    message-bus.test.js             8 tests
    loop.test.js                    4 tests
    integration.test.js             3 tests
```

Root-level additions: `package.json` (workspaces, ESM, Node >=20), `bin/finbot` (CLI wrapper).

## Tool call surface shape

```javascript
interface Tool {
  name: string;             // unique within a registry
  description: string;      // one-paragraph natural-language
  inputSchema: JSONSchema;  // JSON-schema-shaped object
  run: (args, ctx) => Promise<ToolResult>;
  skillPath?: string;       // for tools loaded from SKILL.md
  skillFrontmatter?: object;
}

interface ToolResult {
  ok: boolean;
  content: Array<{ type: 'text', text: string } | { type: 'json', value: unknown }>;
  details?: unknown;
}
```

The `tool:` frontmatter block in a SKILL.md can override the inferred name, description, and inputSchema:

```yaml
---
created: 2026-06-18
tool:
  name: my-override
  description: explicit override
  inputSchema:
    type: object
    properties:
      arg: { type: string }
---
```

`toolsToLlmShape(registry)` renders the registry as the Anthropic tool-use input shape (`{ name, description, input_schema }`); a future builder can plug an Anthropic SDK call directly into a spawn's `llm` parameter.

## Driving-loop tick shape (OODA)

```
runOnce({ finbotRoot, journalRoot, safety }) -> { tickId, observations, orientations, decisions, actions }
  1. observe(ctx):
       drainInbox(oracle-watcher), drainInbox(monitor)
       returns { count, inboxes: { oracle-watcher: [...], monitor: [...] } }
  2. orient(ctx, observations):
       if observations.count > 0: postJob(orient-analyzer), postJob(orient-forecaster)
       returns { posted: [{role, jobPath}, ...] }
  3. decide(ctx, orientations):
       if orientations.posted.length > 0 or no orient still open: postJob(decide-planner)
       returns { posted: [{role: 'planner', jobPath}] }
  4. act(ctx, decisions):
       for each planner proposal: postJob(act-audit)
       if safety == 'live': also postJob(act-execute) with authorizations: { live: true }
       returns { posted: [...] }
```

Per-tick state lives wholly in the journal (`entries/`, `inboxes/<host>/<role>.md`, `jobs/<state>/`). The loop is stateless across ticks; killing it and rerunning picks up where the previous tick left off. `runPersistent` wraps `runOnce` in a `while (true)` with a configurable cadence.

## Subagent spawn shape (cap attenuation hook)

```javascript
interface SpawnParams {
  role: string;              // matches roles/<role>/AGENT.md
  brief: string;             // dispatch prompt body
  capabilities?: string[];   // tool names the subagent may invoke
  attenuator?: Function;     // overrides permissiveAttenuator (the v0 default)
  llm?: Function;            // overrides the stub deterministic LLM
  timeoutMs?: number;
  observationKind?: string;
}

interface SpawnHandle {
  id: string;
  role: string;
  status: 'pending' | 'running' | 'completed' | 'errored' | 'aborted';
  started: number;
  finished?: number;
  events: AgentEvent[];      // Pi-shaped event stream snapshot
  result?: { messages, finalText };
  error?: { message, stack };
  done: Promise<SpawnHandle>;
}
```

The attenuator hook signature is the same in v0 and v1:

```javascript
attenuator(role, capabilities, parentContext) -> { globals, modules, tools }
```

v0 returns the parent context's tools filtered by `capabilities`; globals and modules are inherited unchanged (in-process spawn). v1 replaces this with `@endo/compartment-mapper`: each role's `AGENT.md` frontmatter declares the modules and globals it may import, the compartment-mapper builds a policy, and the harness instantiates the role's code inside a Compartment with that policy in force. The `compartmentAttenuator` stub in `sandbox/permissive.js` throws with a message naming the v1 path so it cannot be silently used.

## Message bus shape

Inbox (directed communication):
- `postToInbox(journalRoot, { to, from, body, project, refs })` writes a `message` journal entry with `to: <role>`.
- `drainInbox(journalRoot, role, { hostKey })` walks `git diff --name-only` since the last-drained commit (stored at `journal/inboxes/<host>/<role>.md`'s `last_drained_commit`), filters entries with `to: <role>` or `to: "*"`, returns the list. State file is only written when matched entries land (avoids the runaway-commit-loop the parent garden hit on 2026-06-02).

Job board (producer-consumer for work items):
- `postJob(journalRoot, { verb, slug, eligible, body, project, authorizations })` writes a job to `jobs/open/<UTC>--<sid>--<slug>.md`.
- `claimJob(journalRoot, sourceRel, { role, host, sessionId })` `git mv`s `open -> claimed`, stamps the claim frontmatter, commits and tries to push; rejection means lost race (the loser resets to `origin/journal`).
- `completeJob(journalRoot, claimedRel, 'done' | 'abandoned', { resultEntry, abandonReason })` moves `claimed -> done` (or `abandoned`) and appends a completion stamp.
- `listOpenJobs(journalRoot)` reads `jobs/open/` and returns the relative paths.

All bus writes go through `commitAndPush` (a single rebase-retry loop with configurable max retries); the `localOnly: true` opt skips the push for tests.

## Observation recorder shape

```javascript
recordEntry(journalRoot, {
  kind: 'dispatch' | 'tick' | 'message' | 'result' | 'worktree',
  role: string,
  body: string,
  to?: string,
  project?: string,
  refs?: string[],
  worktree?: string,
  repo?: string,
})
```

Writes to `entries/<YYYY>/<MM>/<DD>/<HHMMSS>Z-<kind>-<role>-<sid>.md` and pushes through the rebase-retry loop. Frontmatter matches the parent garden's COMMON.md entry shape exactly.

`monitorSubagent(handle)` is an async iterable over the handle's events; the driver can `for await` it to render progress. `recordSubagentTrace(journalRoot, handle)` drains all events into a single `tick` entry summarizing the agent's run (event count + each event type, status, started/finished timestamps).

## Integration test results

5 test files, 35 tests, all pass on Node 22.22.2:

```
packages/harness/test/tools.test.js        12 tests, 0 failures
packages/harness/test/spawn.test.js         8 tests, 0 failures
packages/harness/test/message-bus.test.js   8 tests, 0 failures
packages/harness/test/loop.test.js          4 tests, 0 failures
packages/harness/test/integration.test.js   3 tests, 0 failures
```

Integration coverage:
- One OODA tick end-to-end with synthetic skills + roles + journal: tick 1 initializes HWMs, tick 2 (after seeding an oracle-watcher inbox message) verifies observations, orient (analyzer + forecaster), decide (planner), act (auditor only in dry-run); tick 3 verifies HWM advancement.
- Live mode posts both auditor and executor; dry-run never posts executor.
- A spawn() of an "analyzer" subagent with a real tool registry completes, invokes the tool, and the trace lands as a journal entry via recordSubagentTrace.

End-to-end smoke test against the real finbot/journal repo: `node bin/finbot --once --dry-run` from the project root posted 2 jobs and 2 tick entries to the real `kriscendobot/finbot@journal` branch, confirming the full integration works without mocks. Those commits are visible in the journal as the cut-2 first live run (`d4c798c entry: tick driver 7b0a50` etc.).

## Open questions for cut 3

The harness is the runtime skeleton, not the live brain. Cut 3 needs:

1. **Real LLM integration.** v0 ships a deterministic stub LLM. The first real subagent dispatch wires `spawn.llm` to an Anthropic SDK call (`@anthropic-ai/sdk` or `@earendil-works/pi-ai`'s unified registry). The dispatching liaison should decide which provider to vendor based on the project's eventual `references/` shelf.
2. **Real skill executables.** The v0 tools `run` returns "Skill X is documentation-only in v0. Read <path>." A real implementation needs each skill's procedure section bound to a script under `scripts/<skill>/`. The first candidates: `oracle-poll` (the first real read), `journal-sync` (already mostly implemented in the harness; just expose it as a skill).
3. **The v1 sandbox.** `sandbox/permissive.js` ships the v0 shape; `sandbox/compartment.js` wires `@endo/compartment-mapper`. Read each role's `AGENT.md` frontmatter for its declared globals/modules; build the compartment policy; instantiate the role's code inside it.
4. **The auditor-signoff -> executor handoff.** Currently the live-mode `act` phase posts the executor job alongside the auditor, conditioned only on the live flag. The proper handoff: the auditor's `done` job entry cites the proposal hash; the next tick's `act` phase reads the auditor's signoff and only then posts the executor with `live_authorized: true`. The state machine is documented in `loop.js` as a future cut.
5. **A real planner.** Currently the planner is a stub that lands when the project picks up `@agoric/portfolio-api`'s `computeTargetBalances`. The first real planner dispatch wires `services/ymax-planner` shape per the existing `designs/ymax-integration.md`.

## Recommended next stage

`next: liaison`

The maintainer reviews this harness and iterates on:

1. Which of the cut-3 open questions to tackle first (the live LLM wiring is the highest-leverage one; without it every spawn returns a stub).
2. Whether to import a `references/` shelf containing the relevant pi-mono and endo packages so the harness can grow against pinned sources.
3. Whether to land the `job-board` SKILL.md (currently the skill exists only as the in-harness implementation; the matching SKILL.md stub naming the contract should land for symmetry with the parent garden).
4. Whether to wire `sandbox/compartment.js` now (before any role does anything dangerous) or defer until the first executor dispatch.
5. Whether to grow a `gardener` role here for harness-level meta-evolution, mirroring the parent garden's gardener.

Self-improvement: the parent garden's `skills/job-board/SKILL.md` is bash-centric. Transliterating it to Node revealed that `git add -- <deleted-path>` fails with "did not match any files" but `git add -A -- <parent-dir>` tolerates it; the bash script side-steps this by passing both paths after `git mv`, which works because bash's `git add` is itself rebuilding the index. Worth flagging in the parent garden's skill notes as a Node-port caveat if anyone else ports the skill set.
