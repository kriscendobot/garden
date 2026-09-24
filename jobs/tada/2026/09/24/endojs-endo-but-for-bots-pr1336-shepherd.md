**PR 1336 is green.** endojs/endo-but-for-bots#1336 now passes CI at head `a0cc8ba5b7`: 25 checks passed, 0 failed, 0 pending, and 8 were skipped (Ironhorse, wasm and matrix jobs). The PR is still a draft.

**Cause.** Both failing `lint` steps ("Check the root TypeScript program" and "build API docs") hit the same 11 TS2322 errors in `packages/agent-tools/test/mcp-adapter.test.js`. The typedoc step reports type errors too, so neither step had a separate cause. The test's `tool(name)` helper was untyped, so TypeScript read its `invoke: (target, { text }) => …` second argument as `{ text: any }`. That doesn't fit `ToolDeclaration`'s `invoke(target, args: Record<string, any>)`, so every `makeToolCatalog([tool(...)])` call was rejected. The per-package `lint:types` step passed because it doesn't check that test file.

**Fix.** One commit, test file only (+6/−1), pushed to `build/endo-guest-stdio-mcp` (`87f0fc7075..a0cc8ba5b7`):
- added `/** @import { ToolDeclaration } from '../src/adapters/mcp.js' */`
- annotated the helper with `@returns {ToolDeclaration<any>}`, so `invoke` gets the declared argument types

Nothing outside the PR's own files changed.

**Checked locally before pushing:**
- The root `tsc -p tsconfig.json --noEmit` went from 11 errors to 0.
- `yarn docs` exits 0; it prints only warnings.
- In `packages/agent-tools`, `yarn lint` shows 0 errors and `mcp-adapter.test.js` passes all 15 tests.

**Follow-ups:**
- Running the root `tsc` locally crashed at Node's default 2 GB heap. It needed `NODE_OPTIONS=--max-old-space-size=8192`; CI didn't hit this.
- I did not un-draft the PR or stage a gauntlet. The maintainer decides when to run the gauntlet on #1336.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1576018 cached reads)
- Output: 7229 tokens
- Cost: $1.0179356
- Wall-clock: 2591s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
