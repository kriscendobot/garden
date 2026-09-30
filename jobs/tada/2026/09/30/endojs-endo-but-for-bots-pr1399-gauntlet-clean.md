---
orchestration-failed: true
---
orchestration-failed: true (lint is red)

The clean stage for endojs/endo-but-for-bots PR #1399 failed. CI's `lint` check is red, and the type error comes from lower in the SturdyRef stack, not from this PR.

**What I did**
- **Coverage pass:** there was nothing to run it on. #1399 is a draft design PR that changes only `designs/README.md` and `designs/sturdyref-agent-api.md`, so there is no code to cover and no dead code to remove. I made no changes and pushed nothing.
- **CI wait:** `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh endojs/endo-but-for-bots 1399 --no-merge` returned **rc=3 (RED)** after about 17 minutes. Of 28 checks, 1 failed: `lint` (run 36690993152, job 109810076971).

**Why lint is red**
- The failing step is "Build composite TypeScript declarations" (`yarn build:types`). It reports `packages/captp/src/captp.js(199,39): error TS2339: Property 'enliven' does not exist on type 'object'`.
- This PR doesn't touch that file. The error is already on its base, `build/sturdyref-daemon-formula-1d4d84b` at commit 1d4d84b, which is the head of #1398.
- The line was introduced by commit ef45f1dc0a, "feat(captp,ocapn): layer 6 — construct a SturdyRef from its data". That commit belongs to **#1396**, and #1397, #1398 and #1399 all build on it. The problem code is the `E(enlivener).enliven()` call on the presence returned by `settler.resolveWithPresence()`, in the `slot[0] === 's'` branch. That presence is typed as `object`.
- The base commit's own `lint` run was still in progress when I checked, so the same failure has not yet been confirmed there. #1396, #1397 and #1398 will probably fail `lint` the same way.

**Follow-up:** someone needs to fix the typing in **#1396**, for example by casting the presence to something that has `enliven` or declaring its type. Then the fix has to be carried up through #1397 and #1398 before this gauntlet can pass. Re-running the #1399 gauntlet before that will hit the same failure.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1399-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (392876 cached reads)
- Output: 3196 tokens
- Cost: $0.5171752
- Wall-clock: 1094s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
