**Gauntlet fix round 3 for kriscendobot/minion.town PR #179:** I fixed all six panel-3 must-fix items and pushed them as one commit (`9ebace1 → 090fb13`) with `safe-push-pr-head.sh`. `ci-wait-merge.sh --no-merge` returned rc 0: CI is green on all 3 checks (`test` and both `Claude harness` builds).

**Must-fix items:**
1. **Abbreviated names:** in `site-registry.ts`, `conn` is now `connection` and `sockPath` is now `socketPath`.
2. **Fake subdivision flags:** both copies of `NAME_FILTER` (`clip-title.ts` and `shell.js`) now keep only the England, Scotland and Wales flags (`gbeng`, `gbsct`, `gbwls`). Any other tag run is stripped. There are new fake-flag and Scotland-flag test cases.
3. **Hung daemon reads:**
   - A lookup now gives back its slot and its shared lookup entry after a hard ceiling (`slotCeilingMs`, 15 s by default), even if the daemon read never settles. The clip is then looked up again on the next request.
   - `makeDaemonSiteDirectorySource` now times out the connect and the `@sites` lookup (`connectTimeoutMs`, 5 s by default). On timeout it clears the cached connection and closes it, including one that arrives after the deadline.
   - New tests cover both.
4. **`extractHtmlTitle` slowdown:** it now finds the tags with `indexOf`, so the scan is linear. It lowercases only ASCII so positions still line up with the original text. New tests cover a malformed close tag, a non-ASCII character before the title, and a page full of unclosed `<title` openers.
5. **Lookbehind in `shell.js`:** I removed the lookbehind from the pattern instead of wrapping it in `try`/`catch`. The emoji before a kept joiner or variation selector is now matched along with it, so the module parses on browsers without lookbehind support and needs no fallback.
6. **Behavioral parity test:** a fast-check property checks `clipName(s) === sanitizeClipName(s)` and that running the rule twice gives the same result as once. The inputs lean toward joiners, variation selectors, flags and tag characters. It runs 2000 cases with and without `Intl.Segmenter`. Making the rule idempotent without `Intl.Segmenter` needed one more change: both copies now re-filter the name after cutting it to length.

**Should-fix items I also did:**
- `cancelled` → `canceled`.
- The timeout constants are renamed (`DEFAULT_READ_TIMEOUT_MS`, `DEFAULT_QUEUE_WAIT_MS`) and their comments state the unit.
- `ENDO_SOCK` in `test/clip-names-http.test.ts` now points into the test's temporary directory instead of a fixed `/tmp` path.
- `designs/clip-shell-framework.md` has a sentence on how title reads are limited.

**Not done:**
- No changeset: the repo has no `.changeset/` directory.
- I left the PR body alone, so the reason the name isn't recorded once at `publish` still isn't stated there.
- Swallowed errors still don't record where they came from.

**Local checks:** `npm run typecheck` passes. In `npm test`, 1057 tests pass and 1 fails: `test/git-remote/capability.test.ts > projectPartition`. This PR doesn't touch that code, and the same test passed in CI both on the previous head and on this push, so it looks like a problem with the local environment.

**Follow-ups:** none from this stage. The driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (2207418 cached reads)
- Output: 22291 tokens
- Cost: $1.6996875999999992
- Wall-clock: 1019s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
