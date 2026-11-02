Fix round 1 for PR #667 is pushed and CI is green: all 36 checks passed, none failed (`ci-wait-merge.sh` rc 0).

**Pushed:** commit `79f210a961` on `endojs/endo-but-for-bots` branch `feat/genie-stdio-jsonl-rpc-bridge`, via `safe-push-pr-head.sh` in advance mode. It adds to the previous head `4e580b435e` without rewriting it.

**What each prepass finding got:**
- **`no-plain-reexport`:** `src/rpc/index.js` is the `@endo/agentry/rpc` entry point, not a compatibility shim. I marked it `reexport-policy-exempt` with that reason, the same way `agent-mcp-stdio/index.js` and `npm-registry-server/index.js` do.
- **`prefer-endo-primitives`:** `@endo/bytes` has no UTF-8 encoder or streaming decoder. `framing.js` needs a streaming decoder because a chunk can split a multibyte character, so I marked it and `framing.test.js` exempt with that reason.
- **`spell-out-identifiers`:**
  - `err` is now `error` in `bridge.js` and `serve.js`.
  - In `serve.test.js` the `err` sink is now `errorSink`.
  - In `bridge.test.js`, the `(err: Error)` type is now `(error: Error)`, and the fixtures use `command` and `success` instead of `cmd` and `ok`.
  - `args` stays: it is the tool-call field name that `pi-agent-core` and the RPC wire format both use, so it can't be renamed. I marked `protocol.js`, `bridge.test.js` and the new `types.d.ts` `spell-out-exempt` with that reason.
- **`typedefs-belong-in-dts`:** `src/rpc/types.js` is now a hand-written `src/rpc/types.d.ts` with the same types. I added a `.gitignore` exception so the file is tracked. The existing `@import … from './types.js'` lines still resolve to it, so no importer changed.
- **Pruner advisory (non-blocking):** I kept the long header comment in `bridge.js`. It explains a non-obvious rule: a prompt round isn't awaited, so `steer` and `abort` can arrive mid-round, and a second prompt during a round is rejected.

**Checks before pushing:** all four probes pass when re-run against `origin/llm-9a14ddf`. Prettier, the package `tsc` and eslint are clean, and the 45 `test/rpc` tests pass. The repo-root `tsc` ran out of memory on this host, so I couldn't run it locally; the green CI run covers it.

**Follow-ups:** none. The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr667-gauntlet-20261102-7e7e4481b830-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2310949 cached reads)
- Output: 11306 tokens
- Cost: $1.3139737999999999
- Wall-clock: 1424s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
