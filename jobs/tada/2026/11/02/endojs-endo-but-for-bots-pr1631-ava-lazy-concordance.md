I fixed the remaining ava 8.1 test failure on https://github.com/endojs/endo-but-for-bots/pull/1631, and CI is fully green on the new head `64b17591a6`.

**Root cause:** the lazy concordance load in ava 8.1 runs into a Node `fs.realpathSync` bug.
- For a path segment it has already cached as a plain directory, `realpathSync` re-checks the process-wide stat buffer, which can still describe whatever was stat'd last. If that was a socket, it stops resolving early (I read this in Node 22's own `realpathSync` source).
- The mcp-bridge tests stat Unix sockets concurrently with ava's first deep-equal. So concordance sometimes loads from its unresolved pnpm store link, where `lodash` cannot be found. The result is `Cannot find module 'lodash/isLength'` and then the test timeout.
- ava 8.0 loaded concordance before any test ran, so it never hit the bug.

**Fix:** I took option (a), a project-level workaround, and kept the ava 8.1 bump in the group.
- New `packages/claude-sandbox/test/_preload-concordance.js` imports ava's own loader (`ava/lib/concordance.js`, located from `import.meta.resolve('ava')`) and calls it once, which brings back ava 8.0's eager load.
- `packages/claude-sandbox/package.json` registers it under `ava.require`.
- It is one commit on the PR head, `test(claude-sandbox): preload ava's concordance before socket tests run`.

**Verification:**
- Locally, `mcp-bridge.test.js` passed 10 of 10 runs; before the fix 3 of 6 runs failed with the same error.
- The full claude-sandbox suite passed (543 tests), and eslint and the package type-check (`tsc`) were clean.
- In CI every check passed, including `test (22.x, ubuntu-latest)` where the failure first showed up, and both macOS legs.

**Handoff:** I sent the botanist a message to recheck and auto-merge. Its job (`endojs-endo-but-for-bots-pr1631-dependabot`) had already finished, so the message was dead-lettered (`20261102T005616Z-00c7a5`) and will be promoted to a fresh job. The daily `dependabotany-recheck-endo-but-for-bots` heartbeat covers it too. I did not merge the PR; the botanist owns that.

**Follow-ups:**
- The preload only covers claude-sandbox. Other packages whose tests stat Unix sockets while ava 8.1+ first loads concordance could flake the same way.
- The preload imports `ava/lib/concordance.js` by file path, which is not part of ava's public API. If a later ava moves that file, the preload will throw at startup, so the breakage will be visible rather than silent.
- The Node `realpathSync` behavior is worth reporting upstream, to Node or to ava.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1631-ava-lazy-concordance.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2347792 cached reads)
- Output: 16012 tokens
- Cost: $1.3566063999999998
- Wall-clock: 5316s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
