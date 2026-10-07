## Completion report: `review-miss-prefer-endo-primitives-round2`

All three parts are done and the cluster is closed. If the code panel rerun on minion.town#146's reviewed head (`1258647`), it would now return **request-changes** with a should-fix finding to add `@endo/cancel` as a dependency and use it instead of the vendored `makeCancelKit`.

**main2 `1f090cba7a7`**, pushed directly:
- **(a) Provider index.** Indexing endo exports for minion.town needed a fix besides the journal row. Both callers handed the detector the provider index without the provider's repo location (the pre-push probe even pointed at the state directory), so it could never read provider source. `ensure-export-index.sh --providers` now prints `<index>=<provider bare clone>`, and both callers pass that line through unchanged.
- **(b) Should-fix for a missing `@endo/*` dependency.** When the detector finds a local copy of an `@endo/*` export whose package isn't a dependency yet, and the name is distinctive, the procurer seat now reports should-fix: "add the dependency and consume it". No model call is spent on it. A waiver turns it into a comment. A generic-name clash or a non-`@endo` provider still gets only a comment.
  - To support this, `detect.cjs` now also records the strength a blocked hit would have had.
- **(c) Rules.** The builder brief and the purist juror's checklist now say an unpublished upstream is no license to vendor a copy. The fix is to consume it (dev registry, workspace / `file:` / `link:`, or a pinned git dependency), fix packaging problems upstream, or block and ask. The procurer brief and the skill and design docs are updated to match.
- **Extra, to cover minion.town#140.** I added an `abort-controller` row to the idiom catalog: a raw `new AbortController` is flagged toward `@endo/cancel`, and the flag is waived when the file imports `@endo/cancel`. `@endo/cancel` is now in the builder's catalog. This wasn't in the job spec.
- **Tests.** I added cases to three suites: `export-index-test` (the `--providers` output), `seat-gate-procurer-test` (should-fix, waiver, non-`@endo` provider, generic name, never sent to the model) and `review-convention-probes-test` (`AbortController` flagged, and waived on an `@endo/cancel` import). All four affected suites pass, with `TMPDIR` set to an exec-capable directory:

| Suite | Result |
|---|---|
| `export-index-test` | 15/15 |
| `seat-gate-procurer-test` | 16/16 |
| `build-vs-buy-probe-test` | 9/9 |
| `review-convention-probes-test` | 32/32 |

**journal2:**
- **`config/export-index-providers` seeded** with `kriscendobot/minion.town endojs/endo-but-for-bots@llm`.
  - I checked it against #146's reviewed head `1258647` (base `af7af618`). It indexes endo-but-for-bots@llm and finds `src/endo/cancel-kit.ts:46 makeCancelKit` → `@endo/cancel`.
  - The real procurer seat produces the should-fix finding above.
  - The pre-push probe still passes, because it only blocks on strong, importable hits.
- **Cluster `prefer-endo-primitives` closed** (`improvement-dispatched` → `closed`). `improved_by` names `1f090cba7a7` (round 2) and `37b04ec909` (round 1), so any later miss is flagged as a recurrence. The closing note reconciles the three misses since 08-04:
  - **endojs/endo-but-for-bots#1336:** already covered by the build-vs-buy detector that landed on 09-24.
  - **minion.town#140:** now caught by the new `AbortController` row. No panel ran on that PR, which the separate `builder-pr-gauntlet-bypass` cluster covers.
  - **minion.town#146:** now caught by (a) plus (b), with the rule from (c).
  - Membership was already consistent: 9 members, 9 PRs.

**Follow-ups:**
- Neither the pre-push probe nor the procurer looks at a hit until the copy is already written. Only the new builder rule stops a builder from vendoring in the first place. A stronger fix would be a pre-push note when an `@endo/*` package isn't yet a dependency, but I didn't add one, to keep the gate's "strong hits only" contract.
- The minion.town provider index follows the `llm` tip rather than a pinned commit. That is how the design defines provider rows.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-miss-prefer-endo-primitives-round2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4206045 cached reads)
- Output: 27060 tokens
- Cost: $2.318537
- Wall-clock: 333s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
