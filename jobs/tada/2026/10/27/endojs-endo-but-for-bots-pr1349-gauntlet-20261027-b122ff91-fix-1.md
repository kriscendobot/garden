Fix round 1 for endojs/endo-but-for-bots#1349 is done. I pushed four follow-up commits addressing panel review 5675072198, and CI is green on the new head `fe74338e19` (15 of 15 checks; `ci-wait-merge` returned 0).

**Commits**
- **`84e4622474` (breaker, purist, corner-prober):** `tameTextCodec` now replaces a codec constructor when either `caller` or `arguments` is a non-configurable own property.
  - Before, it only checked whether `arguments` existed. A constructor with only `caller` made `lockdown()` throw.
  - A configurable `arguments` caused a needless replacement; it is now left for the permits pass to delete, so the host constructor stays the same object.
  - A new test file, `text-codec-restricted-property-shapes.test.js`, covers both cases. I confirmed it fails on the old head with "failed to delete intrinsics.TextEncoder.caller".
- **`9d4669d9ca` (corner-prober):** adds tests for `encodeInto` into a zero-length buffer, with empty, one-letter and surrogate-pair input.
- **`4c30f3387e` (transplanter, pruner):** the Playwright config and `server.js` now read the port from `BROWSER_TEST_PORT`, defaulting to 3000. I also removed the comment in the browser test that only pointed to the issue.
- **`fe74338e19` (archivist, releaser):**
  - Both guides now say `TextEncoder` and `TextDecoder` are exceptions to the "no browser features" rule.
  - The changeset is rewritten as release notes for upgraders, and now says hosts without the codecs "remain without them".

**Other changes**
- **PR body (gateway, pruner):** I replaced the paragraph listing each workflow edit with one sentence on why those edits have to be in the shared root workflows.
- **Security text in the PR body:** it now describes the new detection rule.

The ses tests for this area pass locally (35 tests), and eslint, prettier and `tsc` are clean. I posted a follow-up comment on the PR explaining each change: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6454860174

**What I declined or deferred (reasons are in the PR comment)**
- **decomplector:** declined. It proposed dropping the replacement constructors and instead permitting the `caller`/`arguments` properties as fixed `null` values. That would put the host constructor itself inside the locked-down object graph. Earlier panel rounds and the maintainer's request to ferry the PR settled on the current design, so this would be a redesign rather than a fix.
- **benchmarker:** no benchmark. `fd5f23ef31` stops XS from running the codec repair a second time; it was a structural cleanup, not a speed claim.
- **packager:** squashing the three fixup commits (`59295f2`, `c4d9aef`, `37fdc32`) is deferred to the ferry's history cleanup. This stage only adds commits and does not rewrite the branch.

**Follow-up:** the ferry is staged, but this round changed the PR head. The ferry directive should be checked against `fe74338e19`, and it needs to squash those fixup commits.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-b122ff91-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1494942 cached reads)
- Output: 11126 tokens
- Cost: $1.1663884
- Wall-clock: 718s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
