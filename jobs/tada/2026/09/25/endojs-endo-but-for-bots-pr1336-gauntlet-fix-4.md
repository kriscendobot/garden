## Fix round 4 report: endojs/endo-but-for-bots#1336

I applied the round-4 panel's must-fix items and the should-fix items that go with them, and pushed them to `build/endo-guest-stdio-mcp` (`cbadcf336e` → `814e3baade`) with `safe-push-pr-head.sh`. CI is green: `ci-wait-merge.sh --no-merge` returned 0, with all 33 checks passing.

**Commits**
- `a94bf4f3d0` fix(agent-tools):
  - **spec-keeper must-fix:** a message is now checked for validity before the "no id means notification" early return. An invalid message without an id gets `-32600` with `id: null`, per JSON-RPC §7.
  - **spec-keeper:** a `null` id or a non-integer id is refused, as MCP requires.
  - **engine-realist:** each `tools/call` now races its own short-lived promise instead of the promise that lives as long as the connection. The old pattern hit the V8 `Promise.race` leak.
  - Tests updated and added to match.
- `4004a13426` fix(agent-mcp-stdio):
  - **engine-realist:** the stdio framer now does linear work per chunk and refuses frames over `maxFrameLength` with a Parse error.
  - **engine-realist:** an EPIPE on stdout now becomes a `stdout-closed` JSON diagnostic and closes the daemon session. Before, it was an uncaught exception.
  - One test added for the oversize case.
- `ded37e77dd` fix(agent-mcp-stdio), all from breaker and spec-keeper:
  - A closed follower keeps counting against the 64-follower cap until its daemon subscription is actually released.
  - `makePath` calls on one server now run one at a time, so two concurrent calls can't wipe each other's directories.
  - The `messageNumber` schema now matches what the code accepts. I dropped the unexplained 20-digit cap, since daemon message numbers are unbounded.
  - The README's `waitMilliseconds` wording now matches the code.
- `814e3baade` feat(agent-mcp-stdio), **surfacer must-fix:** `exports["."]` now has a `types` condition pointing at a checked-in `types-index.types.d.ts`, and a new `test/exports.test.js` pins the export list.

**Checks run locally:** agent-mcp-stdio tests (43 pass), the agent-tools adapter and exports tests (25 pass), `lint:types` for both packages, eslint (no errors), and prettier (clean except the untouched shared `SECURITY.md`). The repo-root `tsc` checkJs run exits non-zero, but none of its errors are in the files this PR touches.

**Other actions**
- **Scribe:** I forwarded the maintainer's export-name index / build-versus-buy idea to `role/gardener` on the garden bus as a `[proposed-rule]` (message `20260925T032406Z-b9d8b5`).
- **PR comment:** posted a round-4 summary: https://github.com/endojs/endo-but-for-bots/pull/1336#issuecomment-5826156565

**Not applied, reasons given in the PR comment**
- **Curator, `major` → `minor` for the new package's changeset:** I kept `major`. Round 3's must-fix set it on purpose, per the changeset-discipline rule that a new package's first release is 1.0.0. The precedent the curator cites (`add-endo-sturdyref-shim.md`) doesn't exist in the tree. The two rounds disagree on this, so the maintainer may need to settle it.
- **Orthographer and pruner, `SECURITY.md`:** it's the canonical file every package carries, restored in `044bb6e4b3`. Changing its spelling or deleting it here would make this package differ from the others.
- **Pruner, design-doc editorial sections:** left for the maintainer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (5812871 cached reads)
- Output: 34014 tokens
- Cost: $2.8555181999999997
- Wall-clock: 2566s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
