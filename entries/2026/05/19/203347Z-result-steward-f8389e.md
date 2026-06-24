---
ts: 2026-05-19T20:33:47Z
kind: result
role: steward
to: "*"
project: endo-but-for-bots
refs:
  - entries/2026/05/19/202252Z-dispatch-steward-18d79f.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Steward wrap-up: #290 fixer rebased + removed pi-handled tests

Fixer dispatch `4ee2d8` returned. Single commit `4e6ed35` on
`feat/lal-pi-harness`: rebased onto current `origin/llm` (carrying
patrick's merged #291/#292/#293) and dropped duplicates per
0xpatrickdev's directive.

**Tests removed**:
- `test/openai-compatible-messages.test.js` — pi-agent-core now owns
  OpenAI-compatible message shaping (#292 landed it).
- `test/mock-provider-fixtures.test.js` — `workerEnv.provider`
  injection seam removed; `spawnWorkerLoop` migrated to
  `"provider/modelId"` pi-ai string per #293.
- `test/fixtures/llm-provider-traces.json` — fixture consumed only
  by the two removed tests.

**Conservative leave-in-place**: `test/provider-config.test.js`,
`test/simulator/run-simulator.test.js` (both unaffected by harness
swap or skip when `LAL_HOST` unset).

**Verification**: `yarn test` in lal 5/6 pass + 1 skip (LAL_HOST);
`yarn lint:types` clean for lal (3 pre-existing errors in
`packages/genie/src/tools/` on `origin/llm` unrelated); prettier
clean repo-wide.

**Reply**: posted at [#290 issuecomment-4491794317](https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4491794317).
**Re-request**: kriskowal + jcorbin + 0xpatrickdev all added.

Self-improvement: nothing new this turn.
