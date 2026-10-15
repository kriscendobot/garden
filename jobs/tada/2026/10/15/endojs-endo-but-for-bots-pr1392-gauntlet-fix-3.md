Fix round 3 for endojs/endo-but-for-bots#1392 is pushed, and CI is green on the new head `1dfaf54aa02` (35 checks, 0 failed; `ci-wait-merge.sh` returned 0). The updated PR body and the review-response comment are not posted yet. This host's bot token gets a 403 on endojs PR writes, so I posted a job for an endolin host to do both.

**Panel must-fixes applied**
- **Rank order (assessor):** two distinct containers holding the same Parcel, like `compareRank(harden([p]), harden([p]))`, used to compare equal. They now throw. Identical remotables nested in distinct containers still compare as 0.
- **Hostile `globalThis.Parcel` (warden, spec-keeper, breaker, corner-prober):**
  - Any error while checking the global, including a Proxy trap, now just means "not a Parcel" instead of escaping.
  - The prototype's `constructor` must be non-enumerable. I didn't require it to equal `Parcel` as breaker suggested, because a child compartment's shared constructor legitimately differs.
  - The brand check's first answer for each object is cached, so a stateful `isParcel` can't change the classification.
  - Four new adversarial cases: a Proxy global, an enumerable constructor, a stateful check, and a throw followed by a genuine answer.
- **Generated tests (fast-checker):** randomized properties now nest a Parcel up to 8 levels deep in arrays, records and tagged values. They cover marshal (both encode formats and both body formats), patterns (`isKey`, `isPattern`, `matches`) and pass-style (`isPassable`).
- **Smaller test and type items:**
  - Renames: `fc` → `fastCheck`, `arbPassable` → `passableArbitrary`, `p` → `parcelPattern`.
  - A type test that `ParcelObject` is not `PassByRef`.
  - Removed the two narrating test comments.
  - The marshal property is retitled.
- **Docs:** Parcel now has its own "Dormant capability" section in the pass-style README instead of sitting under pass-by-reference. Both READMEs say `Passable` is classified locally and a Parcel can't cross a vat boundary yet.
- **Changeset:** `@endo/patterns` goes from patch to major, because `M.kind('parcel')` is new and `Pattern`/`Matcher` no longer accept nested errors or Parcels. The "type-level change" wording is fixed.
- **History:** I split the changeset typography fix out of `a762738561` into its own commit and force-pushed with a lease. The final file contents are identical to before the split.

**Declined, with reasons in the comment the endolin job will post**
- **decomplector (remove the `'parcel'` pass style) and purist (use a trusted brand function instead of the global):** both conflict with the accepted Parcel design (#1460) and the #695 request. Changing either is a maintainer decision, not a fix-loop item.
- **migrator (`@endo/marshal` major):** marshalling a Parcel already threw before this PR; only the error message improves, so patch stands.
- **integrator (move types from `.d.ts` to `.ts`):** all of pass-style's types already live in `types.d.ts`, so moving them belongs in its own PR.
- **spaces-util tests and changeset:** the package is private and has no test harness at all.
- **XS test and commit-history regrouping:** both were should-fix only, and these packages have no XS harness.

**Local checks:** the Parcel tests pass in every test configuration for pass-style, marshal and patterns. Lint has 0 errors, and the type builds and type tests are clean. The full marshal and patterns suites had a few local crashes on unrelated test files, each a "file not found" error in AVA's own cache directory, not a test failure.

**Follow-ups**
- I posted `endojs-endo-but-for-bots-pr1392-fix3-body-summary`, pinned to `endolin-garden-ece02cb4`. It replaces the PR body (trimmed per the pruner) and posts the response comment.
- An older handoff, `endojs-endo-but-for-bots-pr1392-fix2-body-summary`, is still unclaimed in `todo/`. My new body already includes its Security paragraph, so whichever runs second won't undo the other. Its summary comment is out of date and can be withdrawn.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (7693895 cached reads)
- Output: 38240 tokens
- Cost: $3.542739
- Wall-clock: 3890s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
