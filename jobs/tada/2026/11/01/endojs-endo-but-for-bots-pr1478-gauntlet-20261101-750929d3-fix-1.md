Fix round 1 is pushed, but CI isn't green and hasn't finished. Two macOS legs are still queued after four bounded waits of about 9 minutes each (≈40 minutes), so `ci-wait-merge.sh` returned rc 4 (still pending) every time.

**What changed**
- Pre-pass failure `spell-out-identifiers`: in `packages/ocapn-noise/src/network.js`, I renamed `err` to `error` in the two `throw: async error => {…}` iterator handlers that the PR added. I left the `err` uses that predate the PR alone.
- Pre-pass advisory on comment concision: I cut the 6-line prose comment above `OUTBOUND_HIGH_WATER_FRAMES` to 3 lines. It now keeps only the invariant (the `writer.next` wait at the bound, and the "bound plus two" limit from coalesced heartbeats).
- I ran `eslint` on the file: 0 errors, 1 warning (an unused `eslint-disable` directive at line 47 that I didn't touch).
- I pushed the follow-up commit with `safe-push-pr-head.sh` in advance mode: `4df3d965fb7 -> e8222fc4b55` on `build/ocapn-noise-session-queue`.

**CI state** (run 41353071765)
- Failing: `test (22.x, ubuntu-latest)`, `test (24.x, ubuntu-latest)`, `cover (22.x, ubuntu-latest)`, `cover (24.x, ubuntu-latest)` and `sandbox-drivers`.
- The only failure I could read in the logs is `bwrap › bwrap parent death leaves no owned process group`, in `@endo/sandbox`, followed by SIGINT cancellation. It is not in `@endo/ocapn-noise`. I only inspected the `test (24.x, ubuntu-latest)` log; I did not open the `cover` or `sandbox-drivers` logs.
- My memory notes call the bwrap CI reds pre-existing (fix tracked as #1566). That is why I'm treating this as likely not caused by this PR.
- Pending: `test (22.x, macos-15)` and `test (24.x, macos-15)`, queued and never started.

**Follow-up**
- The driver should re-post this stage or the panel once the macOS legs finish.
- If the ubuntu reds persist, they likely need a rerun or the #1566 fix rather than a change to this PR's diff.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-20261101-750929d3-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 102 tokens (3003034 cached reads)
- Output: 12394 tokens
- Cost: $1.3344222000000001
- Wall-clock: 8858s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
