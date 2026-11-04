---
orchestration-failed: true
---
orchestration-failed: true

# PR #1651 clean stage: failed on CI, one macOS job red

The coverage pass is finished and pushed, but CI is red at head `fca0a53d79`, so this stage did not achieve clean=done. `ci-wait-merge` returned rc 3.

**Failing check:** `test (24.x, macos-15)`, in run 41934287310, job 126939522631.
- **Failure:** in `@endo/claude-sandbox#test`, all 528 tests passed, then `test/restore-context.test.js` exited 1 with "1 uncaught exception". The log has no stack or message.
- **Other checks:** the other 34 checks are not red, including the same test job on Node 22 macOS and on both Ubuntu versions.
- **Link to this PR:** probably none, though the cause is unproven. The test imports only `claude-sandbox` code, and it ran because `claude-sandbox` depends on `@endo/hosted-agent`.
- **Local result:** it passed 3 out of 3 runs on Node 22. I could not reproduce on macOS or Node 24.
- **Possible cause:** the test's `child.stdin` has no error listener, so an EPIPE when a child exits early could be the uncaught exception. This is a guess.
- **Similar failures:** #1640 and #1644 hit post-pass uncaught errors on this same job, though in other packages and with a named `ClientDestroyedError`.
- **Rerun:** `gh run rerun --failed` was refused with "Resource not accessible by personal access token". This job's run needs a rerun by someone with Actions write access. I did not push an empty commit to retrigger CI.
- **Earlier head:** both macOS jobs were cancelled at `e037713894`, so there is no earlier macOS result for this PR's change to compare against.

## What the coverage pass found
**Defect, now fixed:** a 429 or 404 on a non-streaming turn never got its fixed refusal code. The buffered `request` wrapper in `provider-transport.js` kept only the credential and exhaustion errors, so these reached the caller as `Provider request failed`. That is the fault this PR says it fixes, but only the streaming path worked, and that's the only path the `lal` tests use. New tests failed on this before the fix.

**Commit `fca0a53d79`** (`fix(hosted-agent): keep upstream refusals across the buffered transport`):
- **Fix:** the buffered path now passes `isUpstreamRefusal` errors through.
- **Updated test:** the `provider-transport` diagnostics test now expects `Provider rate limited` for a 429.
- **New tests in `hosted-agent`:**
  - the status mapping on both transport paths;
  - the real Anthropic issuer through `request` and `requestByteStream`, with a check that the upstream body doesn't leak into the error;
  - the broker's `revealUpstreamRefusal` opt-in, on and off;
  - the registry passing an unclassified failure or non-Error rejection through without recording a refusal.

**Coverage:** every line and branch this PR adds in the six touched source files is now covered. `provider-broker.js:1801-1803`, `provider-transport.js:530` and the non-Error branch in `failDispatch` were not covered by the `hosted-agent` tests I ran before.

**Dead code:** none removed. The `response.status === 401/429` checks in `lal`'s `brokered-messages.js` look unused on the real path, but they are still tested and part of the endpoint contract.

**Local checks:**
- The `hosted-agent` suite has 4 failures, in `mcp-server` and `recorded-cleanup`. All 4 fail without my change too.
- `provider-worker` tests failed with `Provider pipe closed` only under c8, and passed in the plain run.
- The `lal` brokered tests pass, ESLint reports 0 errors, and the pre-push probes pass.
- `tsc` reports errors only in `../base64`.

## Follow-ups
- **Rerun:** rerun job 126939522631 from a credential with Actions write access. If it goes green, resume the gauntlet.
- **If it recurs:** add an error listener on `child.stdin` in `restore-context.test.js`, in a separate change.
- **PR description:** it doesn't mention the buffered-path fix, so panel reviewers should look at `fca0a53d79`.

The PR is still a draft. I also added this failure to the macOS Node 24 memory note.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1651-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2778593 cached reads)
- Output: 29225 tokens
- Cost: $2.0915546
- Wall-clock: 2028s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
