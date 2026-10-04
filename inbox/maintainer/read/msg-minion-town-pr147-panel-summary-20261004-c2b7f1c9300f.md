from_host: endolin-garden-ece02cb4
from: gardener:minion-town-pr147-panel-summary-20261004
reply_to: minion-town-pr147-panel-summary-20261004
msg_key: msg-minion-town-pr147-panel-summary-20261004-c2b7f1c9300f
notice_count: 1
first_seen: 2026-10-04T04:52:07Z
last_seen: 2026-10-04T04:52:09Z
sent_at: 2026-10-04T04:52:09Z
---
kriscendobot/minion.town#147 (design: MCP resources + getting-started guide for a cold agent; one file, designs/mcp-resources-getting-started.md, +601) — merge-decision summary

Status: draft. The gauntlet stopped at its review budget: 6 panel rounds, every one must-fix, but each round raised NEW items rather than repeating old ones, and fix-6 addressed all 5 round-6 must-fixes.
Panel coverage: none on the latest head c340df2. Round 6 reviewed 8bed1aa, and fix-6 (c340df2) was never re-paneled.
CI: green on c340df2 (test, Claude harness amd64 + arm64). No human review threads.

Open objections after the last round:
1. Must-fix before merge (small): this is a defect that fix-6 introduced, which I found by reading the fix diff; no panel has seen it. The new § 4 "App compatibility" rule checks `git diff --quiet A R -- src/`, where R is "the newest main commit that touched resources/". It then claims that a forward deploy-app.sh "has R = A and passes by construction". That is false whenever an app release changes src/ without touching resources/: R is older than A, so the rule logs a spurious skew warning on ordinary forward deploys. Fix: key the check on the commit each copy was cut from (A for app deploys), not the newest resources/-touching commit. One paragraph.
2. Follow-up-worthy: the guide's error-string table is aligned to kriscendobot/minion.town#95 § 1, but that PR is still unmerged and nothing re-checks the alignment when it lands (skeptic). The pet-name grammar (length, reserved @-names) has no behavioral task (skeptic). § 4's default mode, with no symlink, does not say what loadGuide's `commit` is (decomplector). Table 2 does not list the live symlink as durable state (decomplector). These are build-time details.
3. Taste/noise: `instructions.md` is identified by having no `uri` rather than by an explicit kind (decomplector, which itself calls this taste). Three copyedit sentence splits. "Endo" is never introduced. The pedant wants § spelled out, but the rule doesn't list §. The novice wants the "Grounded against" block moved. None of these change the design.
4. Not panel items but yours to answer: the three § 9 open questions (an eval principal vs the shared test principal; whether to publish the guide off-MCP; how the confined in-guest Claude gets the guide).

Bottom line: merge after one named small fix, the § 4 R-vs-A compatibility key in item 1, made by hand or as a single fixer commit with no new gauntlet. The convergence pattern (new, shrinking nits each round; the critic spot-verified the grounding claims) says the design is sound. Further panel rounds would keep finding prose-level items.
