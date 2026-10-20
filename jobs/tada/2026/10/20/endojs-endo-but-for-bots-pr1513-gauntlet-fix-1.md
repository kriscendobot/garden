# Gauntlet fix round 1: endojs/endo-but-for-bots PR #1513

Both blocking prepass findings are fixed and CI is green on the new head, `005ea1bb801`. All 35 checks passed and none failed. `ci-wait-merge.sh --no-merge` returned rc 0.

**What changed:** one follow-up commit on `feat/ocapn-noise-tcp-cbor-transport`, editing only `packages/ocapn-noise/test/network-tcp.test.js`. It was pushed with `safe-push-pr-head.sh`, which moved the head forward from `21b45842a` without rewriting history.

- **no-inline-import-jsdoc:** I added a top-of-file `/** @import { ByteStream } from '../src/types.js' */`. All six inline `import('../src/types.js').ByteStream` uses now use the bare `ByteStream`. That includes the two older ones at lines 84/86, which the probe didn't flag.
- **prefer-endo-primitives:** `@endo/bytes` has no text encoder, so I removed `TextEncoder`/`TextDecoder` from the new tcp+cbor session test instead. It now sends fixed byte payloads with `Uint8Array.of(...)` and checks them with `t.deepEqual`, the same way the framing tests in that file already do.
- **Advisory comment check (pruner, `tcp.js:194`):** I left it unchanged. It is the function's documentation comment, and it explains why the transport registers as `'tcp+cbor'` separately from the netstring `'tcp'` transport, which isn't obvious from the code.

**Local checks:** after committing, both probes pass when run against `origin/llm`. `yarn test test/network-tcp.test.js` passes all 8 tests, and eslint reports no errors.

**Follow-ups:**
- eslint warns about an unused `eslint-disable` directive at line 92 of the same file. It's only a warning, and I didn't change it.
- The older netstring tcp test still uses `TextEncoder` at lines 50–56. The probe doesn't flag it, so I left it alone.
- My first CI wait ran in the background and was stopped at the 10-minute limit. The wait that produced the green result ran in the foreground.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1513-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1377641 cached reads)
- Output: 8115 tokens
- Cost: $0.8890282000000002
- Wall-clock: 2529s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
