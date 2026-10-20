FIX round 1 for endojs/endo-but-for-bots PR #1507 is done. The fix is pushed and CI came back green: 35 of 35 checks, none failed.

**What I fixed** (on branch `feat/ocapn-noise-explicit-listeners`, following the style pre-pass block in the job):
- **Inline type imports:** In `packages/ocapn-noise/test/_transport.js` and `test/network.test.js`, I added a `@import` tag at the top of each file. The four flagged `import('../src/types.js')` references are now bare type names.
- **Abbreviated identifier:** In `packages/ocapn-noise/src/transports/ws-node.js`, I renamed `addr` to `address` in the `advertisedHost` parameter and the local variable to `boundAddress`. Prettier reformatted the affected lines.
- **Comment advisory (non-blocking):** I kept the comment at `src/network.js:1331`. It explains why a failed bind leaves the advertised hints unchanged, which the nearby code doesn't say.

**Checks:** Before pushing, `ocapn-noise` type-checking passed, its 84 tests passed, and eslint reported no errors. Its one warning (line 213 of `ws-node.js`) is outside the code I touched.

**Push and CI:** The commit is `822b462c0b`, one review-feedback commit on top of `5081fa1915`, pushed with `safe-push-pr-head.sh`. `ci-wait-merge.sh --no-merge` exited with rc 0.

**Follow-up:** Older files in the package also use `addr` and inline `import('../src/types.js')`, for example `test/ws-transport.test.js`, `test/_fabric.js` and `src/transports/tcp.js`. The pre-pass didn't flag them because this PR doesn't change those lines, so I left them alone. The driver re-posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1507-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1096070 cached reads)
- Output: 4856 tokens
- Cost: $0.805462
- Wall-clock: 2062s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
