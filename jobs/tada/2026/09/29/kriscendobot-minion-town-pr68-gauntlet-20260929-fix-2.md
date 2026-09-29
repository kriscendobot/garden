## Gauntlet FIX round 2: kriscendobot/minion.town PR #68

I applied all five must-fix items from the panel round 2 review (`pullrequestreview-5357907919`, head `3c9dc25`). They are pushed to `feat/weblet-publish-dir` as two follow-up commits (`3c9dc25..d6d05b4`), and CI on the new head is green.

**Commits**
- `46d9060` fix(clip): check the worker result and entry count before the schema
- `d6d05b4` chore: Update package-lock.json (removes `@endo/bytes`)

**Must-fix items** (all in `src/endo/guest-tools.ts` and `test/endo-clip-tools.test.ts`)
- **breaker:** the parsed value must now be an array of at most 1024 entries before `ContentFiles` runs. Schema failures now return only the first issue, with its path, truncated to 200 characters, instead of the whole error message. New tests:
  - 100,000 `{}` entries are rejected in under 1 s with a short error.
  - A 1M-character unknown key produces a short error. This also covers breaker's should-fix about echoed keys.
- **warden + engine-realist:** removed the `@endo/bytes` dependency and use one module-level `TextEncoder` instead. The module header comment is corrected, and the lockfile is back to matching the base.
- **wire-watcher + saboteur + engine-realist:** a worker result that isn't a string is now rejected. The doc comment now says only the worker-side check prevents the allocation. The `facetWithNamedContent` fake now returns the JSON text the real worker source produces, with a `raw` option for a worker that doesn't. A new test covers an array result being rejected. The non-array test now expects the new "is not an array of files" message.
- **integrator:** rewrote the PR description to cover the `dev/mock-as.ts` → `dev/mock-authorization-server.ts` rename, the input limits (1024 files, 16 MiB, 32M code units), the shared `resolveGuestMainWorker`, `confirmPublicBuiltIn`, and the switch to `TextEncoder`. I left the title as is.
- **benchmarker:** the `utf8ByteLengthWithin` docstring now says why there's no benchmark: it limits peak memory, not time. Measuring by encoding would allocate up to 48 MiB for each entry, including the ones it rejects.

**Verification**
- Typecheck is clean.
- The full test suite passed locally (579 passed, 8 skipped); `test/endo-clip-tools.test.ts` passes 31/31.
- **CI:** the only workflow run for `d6d05b4`, "test (typecheck + vitest)", completed with success: https://github.com/kriscendobot/minion.town/actions/runs/36633694252
- **CI was checked a different way than the job specified.** `ci-wait-merge.sh` printed nothing because this host's bot token gets a 403 from the checks and commit-status APIs (a known problem on this host). I read the result from the Actions runs API instead and stopped the script before its deadline.

**Not done (should-fix, non-blocking):**
- Regrouping the commits by topic.
- Keeping the parser/decoder error messages in the `JSON.parse` and base64 catches.
- The dev-only mock server issues: the `/token` scope can override the granted one, and codes can be reused.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr68-gauntlet-20260929-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1692617 cached reads)
- Output: 13962 tokens
- Cost: $1.2005154000000005
- Wall-clock: 1427s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
