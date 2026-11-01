gauntlet-status: not-viable
viability-result: overtaken
repo: endojs/endo-but-for-bots
pr_number: 1621
# gauntlet endojs-endo-but-for-bots-pr1621-gauntlet - not viable

the premise was overtaken. Deciding question: Is #1621 still the only change in flight for the fixes and test262 rows it carries (+10)? Option: close as superseded.

## Viability report

PR #1621 has been overtaken: three earlier open PRs already cover every row it flips, so it shouldn't enter the gauntlet.

Deciding question: Is #1621 still the only change in flight for the fixes and test262 rows it carries (+10)?
Answer: No.

Evidence:
- **PR state:** open draft, created 2026-11-01T15:51Z, with no reviews or comments. It is based on frozen `llm-9a14ddf`, and live `llm` is 0 commits ahead of that base. Nothing has landed on `suspend.rs`, `regexp.rs` or the touched shards since, so nothing is merged yet.
- **#1615** (opened 14:42Z, base `llm-9a14ddf`, "seventeenth slice") makes the same `suspend.rs` change for async generators. It flips the same 6 `AsyncGeneratorPrototype/return/*-broken-promise` rows and makes the same `AsyncFromSyncIteratorPrototype/next` shard edit.
- **#1616** (opened 14:59Z, stacked on #1615, "fifteenth slice") extends that change to every await. It flips the same 2 `for-await-of/ticks-with-async-iter-resolved-promise-and-constructor-lookup-two.js` rows and adds the same new test file, `await_promise_resolve_constructor.rs`. Its author says they built the same async-generator fix independently and dropped their copy.
- **#1619** (opened 15:49Z, base `llm-9a14ddf`, "nineteenth slice") makes a `regexp.rs` exec-result key fix for the same 2 `RegExp/match-indices/indices-groups-object-undefined.js` rows.
- **Net:** #1615 + #1616 + #1619 = 6 + 2 + 2 = 10 rows, exactly #1621's +10. All three were opened before #1621. Parallel crank slices raced for the same rows and #1621 combines all three.
- **Differences:**
  - #1621 seeds the RegExp keys with `intern_static_key` (boot keys, no new metered slot). #1619 instead regenerates the snapshot state goldens.
  - On `AsyncAwait`, #1621 says XS departs from the spec and adds a test pinning that. #1616 says it checked the XS oracle and XS agrees with Ironhorse.

  Neither difference adds a test262 row. A maintainer may still prefer #1621's RegExp approach to #1619's golden regeneration; if so, swap it into #1619 rather than reviewing all three duplicates.

Changes: none (viability gate only; no clean, panel, fix or CI budget spent).

Follow-up: the maintainer should choose one set of duplicates, probably keeping the earlier #1615/#1616/#1619 stack and closing #1621. The two disagreements above are worth checking before closing.

Option: close as superseded

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1621-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (243616 cached reads)
- Output: 2779 tokens
- Cost: $0.5078792
- Wall-clock: 39s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
