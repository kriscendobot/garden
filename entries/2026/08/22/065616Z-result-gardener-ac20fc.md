---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:56:20Z
---
result: review-retrospective (prosecutor) on endojs/endo-but-for-bots PR #475

refs: endojs/endo-but-for-bots#475:review:4965591929:retro
primary: endojs-endo-but-for-bots-pr475-review-c85b88c9 (DOOMED, requeue-exhausted 2026-08-19 — never executed)

Verdict: MISS (naming). The maintainer review asked for a whole-PR pass to
confirm no stale references to the former byte-immutability API toBytes/fromBytes
survived after the rename to frozenBytes/thawedBytes (earlier thawnBytes). The
rename target was already decided before the comment, so completeness is
mechanically checkable from the diff (grep old names -> zero) and is owned by the
stylist's rename-discipline backstop. Review-catchable, not new direction.

Grounded in the world, not the primary report: the primary job doomed and never
ran, yet the migration converged anyway — the cited file
(packages/ocapn/src/netlayers/websocket.js) and a PR-wide sweep of changed .js on
head affe74453 are clean of the byte-immutability toBytes/fromBytes (the lone
BufferReader.fromBytes in syrup/decode.js is an unrelated pre-existing API).
Discrepancy noted: the feedback was satisfied by later commits / maintainer work,
not by the doomed primary.

Recorded to cluster incomplete-rename-old-name-sweep (count=1, prs={475}, open) —
the code-identifier sibling of the docs-side stale-identifier-reference-sweep
cluster (count=1, prs={475}); same review-capability gap (no systematic old-name
sweep against the PR's rename map), kept separate because the store binds one
taxonomy category per cluster (naming->rename-discipline vs docs-drift->archivist).

Threshold: HELD below floor. Neither cluster meets K>=3 across >=2 distinct PRs;
together they are 2 misses on the single PR #475, failing the >=2-PR requirement
that guards against one messy PR masquerading as systemic. Severity minor, so the
single-major standing-rule bypass does not apply. No review-improve job dispatched.
Watch: if this rename-sweep gap recurs on a second PR, either cluster trips the
floor and a builder job should add a whole-PR old-name/deleted-path sweep gate
that covers code AND prose (unifying both siblings).

Self-improvement: the two rename-sweep clusters (code + docs) describe one gap
split by the store's one-category-per-cluster binding; a future improvement job
should note the unified sensing fix rather than treating them as independent.
