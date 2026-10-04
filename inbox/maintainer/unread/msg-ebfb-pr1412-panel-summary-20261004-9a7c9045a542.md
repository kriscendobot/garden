from_host: endolin-garden-ece02cb4
from: gardener:ebfb-pr1412-panel-summary-20261004
reply_to: ebfb-pr1412-panel-summary-20261004
msg_key: msg-ebfb-pr1412-panel-summary-20261004-9a7c9045a542
notice_count: 1
first_seen: 2026-10-04T04:50:42Z
last_seen: 2026-10-04T04:50:43Z
sent_at: 2026-10-04T04:50:43Z
---
endojs/endo-but-for-bots#1412 (endo-claude CLI + Agent SDK backends, phase 2): panel summary for a merge decision

STATE: draft. Head aa09ea465a. CI fully green (all required legs pass; the ironhorse legs skip as expected). The gauntlet stopped at its review budget after 6 rounds.

PANEL COVERAGE: the latest head has NOT been reviewed. Round 6 reviewed 0674323ba9. Three commits came after it: f4fae43852 (race and ceiling fixes plus a new turn-guard.test.js), d88d3e9859 (a GC retention test), and aa09ea465a (docs/README). Together they change about 300 lines, most of them tests. I read the race fix by hand and it is correct: once termination fires, `terminated` is returned directly and no longer raced.

ROUND-6 MUST-FIXES (all 5 addressed in those 3 commits, per the 10-03 follow-up comment):
- breaker: Promise.race let an eager SDK stream outrun termination. FIXED in f4fae43852.
- saboteur: a fractional maxTurns made infer() reject instead of returning a result. FIXED: it now resolves to unavailable.
- prover: the retention fix had no test that could fail without it. FIXED: GC test in d88d3e9859.
- archivist: the design's Status row contradicted its Status section. FIXED.
- integrator: endojs/endo-but-for-bots#1369 Gap 2 was not acknowledged. Now DOCUMENTED, not fixed (see below).

STILL OPEN:
1. endojs/endo-but-for-bots#1369 Gap 2: the guest's stdio MCP server inherits the credential from the binary's environment. Class: FOLLOW-UP-WORTHY, and a deployment constraint. Reason: the design and README now record it as acceptable only for a single-principal deployment, and the phase-3 broker delivery is what closes it. Don't deploy multi-principal until the broker lands.
2. saboteur (should-fix): the SDK backend runs JSON.stringify on a whole message before checking the byte ceiling, so one huge guest-influenced message can spike memory. Class: FOLLOW-UP-WORTHY. Reason: it is a real but bounded resource gap and does not affect correctness. The fix is a small incremental or capped count.
3. engine-realist (should-fix): `instanceof Error` in messageOf/checkPinnedVersion drops the message of an error-like value thrown across realms. Class: FOLLOW-UP-WORTHY. Reason: it only matters once the response-shape table gets message-matching rows, and that table is empty until gate 3.
4. spec-keeper (should-fix): serializedByteCount's cycle handling has no direct tests. Class: FOLLOW-UP-WORTHY. Reason: it feeds a limit path, but it is test debt, not a defect.
5. fast-checker: property tests for the limits.js accumulators and the classify.js delay gate, plus fast-check in @endo/inference. Class: TASTE/NOISE. Reason: the example tests already cover the behavior.
6. curator: the `./types.js` export has no `default` condition. Class: TASTE/NOISE. Reason: latent, since nothing imports it at runtime. It is a one-line fix if wanted.
7. transplanter: one test spawns its fixture through the shebang, which is POSIX-only. Class: TASTE/NOISE. Reason: the package is already Node/POSIX-only.

BLOCKER OUTSIDE THE PANEL: this PR is stacked on endojs/endo-but-for-bots#1403 (phase 1, @endo/inference), which is still an open draft. The diff carries phase 1 through merge commits, and the PR body itself says to keep it draft until endojs/endo-but-for-bots#1403 merges and a weave shrinks the stack.

RECOMMENDATION: MERGE AS IS on substance, but only after endojs/endo-but-for-bots#1403 lands and a weave reduces the stack. Nothing must-fix is open. If you want panel coverage of the final head before un-drafting, that weave is the natural point for one more panel round. File items 1–4 as follow-ups. Item 1 also gates any multi-principal deployment.
