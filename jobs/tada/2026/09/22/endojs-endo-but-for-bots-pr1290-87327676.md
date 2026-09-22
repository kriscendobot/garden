Every ask in the directive is corroborated as already satisfied by a prior claimant of **this** job (a reaper-requeue left #1328 in place). No further work is needed.

## Completion report

**Directive** (PR #1290 inline comment `r4066300501` by kriskowal, on `packages/sha256/test/browser-entry.js`): *"This seems extraneous. The importer could import these facets directly."*

**Preflight**: exit 2 (HINT). I corroborated rather than closing on the hint.

**State found** — #1290 itself is already **merged/closed**, so the fix could only land as a follow-up against `llm`. Two follow-ups exist; I verified both against the board/GitHub directly:
- **#1326** — closed, superseded (earlier attempt on base `llm-38cce7e`).
- **#1328** — **open**, draft, `mergeable: clean`, base `llm-db664fa`, head `pr1290-inline-browser-entry`, commit `d9077c4d08`. Carries **this job's durable marker** `<!-- garden-job: endojs-endo-but-for-bots-pr1290-87327676 -->`; `ensure-pr.sh --find-only` adopts it (creates nothing).

**Each ask, corroborated by the #1328 diff:**
- *Delete the extraneous file* → `packages/sha256/test/browser-entry.js` is removed (−7 lines).
- *Importer imports the facets directly* → the two re-export lines (`sha256` from `@endo/sha256`, `sha256Async` from `@endo/sha256/async`) are inlined into the sole importer's `read` power in `browser-test/tests/sha256.spec.js`, served from a **virtual** location under `packages/sha256/test/` (never written to disk), preserving package-self-import resolution so conditional-export selection stays exercised.

**Reply to maintainer** → already posted on the same inline thread (`in_reply_to=4066300501`, comment id `4067990104`) pointing to #1328.

**Outcome**: no-op — the directive's deliverable (follow-up PR #1328 deleting the file and inlining the imports) already exists, is mergeable, and is tied to this job. It remains a **draft** per the manual-gauntlet regime; promotion to review is a maintainer trigger (`run the gauntlet #1328`), not this job's scope.

**Follow-up for maintainer**: #1328 is ready for review/gauntlet whenever desired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-87327676.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 11 on 2 host(s) (3 unmetered)
- Input: 154 tokens (3474874 cached reads)
- Output: 47712 tokens
- Cost: $6.884186999999999 (3 engagement(s) unpriced)
- Wall-clock: 1830s
- Model(s): claude-opus-4-8 ×8

<!-- garden-usage-end -->
