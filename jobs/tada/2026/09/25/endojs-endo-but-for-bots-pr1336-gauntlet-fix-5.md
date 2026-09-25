Fix round 5 for endojs/endo-but-for-bots#1336 is pushed and CI is green: all 33 checks passed at head `5f01c570f3` (`ci-wait-merge` rc 0).

**Must-fix items**
- **Follower cap untested (prover 1 / corner-prober 1):** new test opens 64 followers and checks that the 65th is refused. It also checks that a closed follower still waiting on its release keeps its slot until the release settles. The test fails if the `releasingFollowers` counter is removed.
- **`makePath` serialization untested (prover 2):** new test runs two `makePath` calls at once that share a prefix, against a fake guest whose `makeDirectory` replaces what the name held. The shared prefix is created only once. The test fails if `makePathQueue` is removed.
- **`readFollower` bounds untested (corner-prober 2):** new test sends limit values through `tools/call`. `maxItems` 1 and 256 and `waitMilliseconds` 0 and 30000 are accepted. `maxItems` 0, 257 and 1.5, and `waitMilliseconds` -1 and 30001, are refused as `argument-scope`.
- **Overlap with the existing MCP bridge (curator):** added Design Decision 7 to `designs/endo-guest-stdio-mcp.md`. It says the new adapter is kept separate from `claude-sandbox/src/mcp-bridge.js` on purpose. It also records the `-32001` vs `-32602` choice and the tool-name policy mismatch, and names merging the shared JSON-RPC code as a follow-up.
- **Speed claim with no measurement (benchmarker):** declined with a note in the PR comment. The framing change goes from quadratic to linear in frame size, which is clear from the code. The only client is one `claude` process sending small frames, so it isn't worth benchmarking.

**Cheap should-fixes also taken**
- **Nested keys reached the guest (breaker 1):** `define` slot records now refuse keys the schema doesn't declare. There is a test for the smuggled-key case, and it fails with the old pattern.
- **Schema/check mismatch (spec-keeper 1):** the number form of `messageNumber` now declares `maximum: Number.MAX_SAFE_INTEGER`, and the false comment is removed.
- **Unhardened export (purist 3):** `toMessageNumber` is now hardened.
- **Negative zero (corner-prober 3):** a `-0` → `0n` case is added to the accepted table.

**What went wrong on the way**
- **Spelling fix broke lint:** I first applied the orthographer's `acknowledgement` → `acknowledgment` fix to `SECURITY.md`. CI's `check-security-md.sh` requires that file to match the canonical text byte for byte, so lint failed. I restored it in `5f01c570f3` and explained why on the PR.
- **Two unrelated macOS failures:** the first was a network error during `yarn install`. The second was a `thixotrope` `durable-sessions` test, a package that doesn't depend on anything this PR changes. A rerun of that job passed.
- **Deadline hit, then confirmed:** the one-hour CI wait ran out with rc 4 while the rerun was still going. Once the rerun passed, a second `ci-wait-merge` confirmed all 33 green with rc 0.

**Commits:** `4375670571` (fix), `fad7248313` (tests), `01a76e6ea6` (docs), `5f01c570f3` (`SECURITY.md` restore). The disposition is in two PR comments, 5826626153 and 5826836279.

**Left for later** (should-fix or comment-only, listed on the PR):
- Regroup the commits before merge (integrator; best done as a retcon before un-draft).
- Refuse invalid UTF-8 instead of silently replacing it (spec-keeper 2 / wire-watcher 1).
- Use `Fail`/`q` instead of raw throws, and named `node:` imports (purist 2 and 4).
- Make construction errors passable across a boundary (purist 1).
- Stop timed-out follower reads from piling up retained memory (engine-realist 1).
- Add the missing argument-scope test cases (wire-watcher 2).

The panel was not re-run; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 126 tokens (6347369 cached reads)
- Output: 26110 tokens
- Cost: $2.7219058000000014
- Wall-clock: 5350s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
