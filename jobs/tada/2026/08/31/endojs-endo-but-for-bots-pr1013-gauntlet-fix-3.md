CI is green. Fix stage complete.

## Completion report

**Job:** FIX round 3 for endojs/endo-but-for-bots PR #1013 (`design: relative routing for CapTP/OCapN locator hints`).

**Panel round-3 must-fix items applied** (to `designs/relative-routing.md`, one commit `31d3afe98`):

1. **Typist-hostile code points** (pedant/copyeditor must-fix): removed all em-dashes (lines 54, 75, 132–135, 145, 170, 182–183, 191, 208, 234–236) and the typographic ellipsis (line 171), rewritten as commas, colons, periods, parentheticals, and ASCII `...`. Verified none remain; only the intended `§` section symbol persists.
2. **Algorithm/encoding generality** (critic must-fix): resolved the `via=`/`dest=` cost inconsistency by *narrowing the encoding* to match §4's fixed gateway cost — `dest=<kind>:<id>` → literal `dest=gateway:<id>`, with an explicit note that `gateway` is the one destination kind this design settles and that generalizing `dest=` (and the ranking to `costOf(h.dest.kind)`) is deferred to the gateway-relayed-introduction follow-on.
3. **Async-discovery race** (critic must-fix): added an Open Question naming the race between async-learned `lan`/`hub`/`gateway` tags and the synchronous `LocalScope.has`, its cost-half consequence for cases 1/5, and two deferred resolution shapes (bounded discovery window before first attempt; re-run `selectRoutes` on tag arrival and promote a cheaper route mid-flight).

**Push:** advanced `endojs/design/relative-routing` `ce8b0615` → `31d3afe9` via `safe-push-pr-head.sh`.

**CI:** `ci-wait-merge.sh --no-merge` → **rc 0, CI GREEN** (5/5 checks, 0 failed).

Should-fix items (comma splice line 27, `§1`→`§ 1` spacing line 332, `selectRoutes` naming, empty-array failure mode, producer-audience-scope premise) were left for the driver's next panel round per the must-fix-only stage scope. No follow-ups required from this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1553719 cached reads)
- Output: 12033 tokens
- Cost: $1.7137274999999998
- Wall-clock: 559s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
