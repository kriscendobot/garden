# Gauntlet clean stage: endojs/endo-but-for-bots#1645 (`fix/agentry-pi-agent-system-messages`)

CI is green at head `6f0f801` (16 passed, 20 skipped, 0 failed). The PR's new test was failing on Node 24 and I fixed it in three follow-up commits pushed to the PR head.

**Starting state:** the PR was a draft at `d080647e4b`. The `test (24.x, ubuntu-latest)` leg was red: `@endo/agentry`'s `test/harness-pi-agent.test.js` ended with 3 fatal unhandled rejections, `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'`. The cause was the PR's new test, "makePiAgent declares the system prompt and tools to a real provider adapter".

**Root cause:** the test sends requests through the global `fetch`, which on Node 24 is undici 7.30. undici shuts down its connection pool for a server once all connections to it close. While doing that it builds a `ClientDestroyedError` and writes its `message`. Under SES that write is forbidden, so each pool shutdown becomes a fatal unhandled rejection. I reproduced this locally with a downloaded Node 24.22.2; it never happens on Node 22.

**Commits pushed** (all via `safe-push-pr-head.sh`, fast-forward):
1. `ed4f7aa` sent `connection: close` from the fake server. This was the wrong fix: both Node 24 legs (ubuntu and macOS) still failed.
2. `1aeae21` reverted that header. The test now sends its requests through a `node:http` fetch with `agent: false`, passed into the real `streamSimple`/openai-completions adapter. This is the same pattern the daemon `ws-relay` and `endo-fs-asset-server` tests use. All test legs went green, but lint went red.
3. `6f0f801` fixed the lint failure. The repo-root type check (`tsc` with `checkJs`) rejected the shim's signature, so I typed it as `typeof fetch` and narrowed the URL at the call site. I confirmed the root config reproduces the TS2322 error on the old code and passes on the new.

**Local checks:** the test file passes on Node 24 (3 runs) and Node 22 with no unhandled rejections. eslint, prettier and package `tsc` are clean.

**Coverage and dead code:** the PR already removes the now-unused `defaultConvertToLlm` filter. The `Message` type import is still used, and nothing else was left orphaned.

**Follow-ups:**
- The PR now carries three test commits, including the reverted `connection: close` attempt. A retcon could squash them if the maintainer wants a tidy history.
- I saved a memory note (`node24-undici-ses-clientdestroyed`), since any SES test that uses `fetch` against a local server will hit this on Node 24.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1645-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (4362099 cached reads)
- Output: 25072 tokens
- Cost: $2.1920517999999993
- Wall-clock: 2482s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
