---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1046-review-0fd48356
verdict: not-a-miss
category: new-direction
review_at: 2026-08-22T06:08:23Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1046#pullrequestreview-4999280044
identity: endojs/endo-but-for-bots#1046:review:4999280044
---

Maintainer product-ambition raise on the Ironhorse smoke test, approval-framed
and made with full information. #1046's `test/ironhorse/smoke.js` was a bare
`1 + 1;` executed with `flags: [raw]` — an honest minimal smoke proving only that
the adapter runs *some* script through Ironhorse. The review approves the shape
("Ah, this is good") and asks, as a suggestion, to strengthen it: can Ironhorse
run a real assertion, like `assert.sameValue(2 + 2, 4)`? This is a request first
stated in the review itself, preference-framed, chosen by a reviewer holding
complete information — the `raw` no-assert nature of the smoke was visible in the
diff, not concealed to satisfy a metric, so the measurement-vs-purpose gap was
disclosed, not moved (not evaluator gaming). No standing rule bound: no seat brief
or skill requires a smoke fixture to carry a real assertion, and the
coverage-auditor's lens is whether new adapter code lines are c8-exercised, not
whether a smoke fixture's body asserts behavior; a minimal raw smoke is a
legitimate, accepted shape. This is the direct successor to the same PR's
f8cbbd32 new-direction dismissal (both are maintainer capability/depth raises on
the same hardened262 Ironhorse arc, preference-framed, on fully-disclosed work).
The primary delivered and verified the requested capability in the world (commit
0759a1fd58 on the PR head branch `feat/ironhorse-coverage-matrix`: smoke now runs
`assert.sameValue(2 + 2, 4)` through the assembled `sta.js`/`assert.js` harness,
dropping `raw`, exercising the Ironhorse-only `Test262Error.prototype.toString`
substitution end to end; passes under Ironhorse sloppy and strict; baselines
refreshed).
