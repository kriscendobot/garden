---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T14:04:39Z
---
refs: endojs/endo-but-for-bots#1046:review:4999280044:retro

Prosecutor retrospective on endojs/endo-but-for-bots PR #1046, review 4999280044
by kriskowal (surface: pr-review-body; the assertable content was one inline
comment on `test/ironhorse/smoke.js`).

Verdict: not-a-miss / new-direction. The maintainer approved the smoke test
("Ah, this is good") and, as a suggestion, asked whether Ironhorse could run a
real assertion like `assert.sameValue(2 + 2, 4)`. This is a product-ambition
raise first stated in the review itself, preference-framed, made with complete
information — the prior smoke was a visible bare `1 + 1;` under `flags: [raw]`,
not concealed to satisfy a metric, so no evaluator gaming and no standing rule
bound (no seat brief or skill requires a smoke fixture to carry a real assertion;
the coverage-auditor measures c8 coverage of new adapter code, not smoke-body
behavior). Direct successor to the same PR's f8cbbd32 new-direction dismissal.

Grounded in the world: re-fetched the PR, the review, its inline comments, and
the PR commits; confirmed the primary's deliverable EXISTS (commit 0759a1fd58 on
head `feat/ironhorse-coverage-matrix` — smoke now runs the assertion through the
assembled sta.js/assert.js harness, dropping `raw`, exercising the Ironhorse-only
`Test262Error.prototype.toString` substitution end to end) — no #721 false-no-op
discrepancy.

Recorded: review-misses/dismissed/endojs-endo-but-for-bots-pr1046-review-0fd48356.md
(paraphrase only; CAS-committed to journal2). A dismissal mints no cluster, so no
threshold evaluation and no improvement job. Second loop closes here.
