The M2 `hardened-url-shim` plan record now points at draft PR [endojs/endo-but-for-bots#1356](https://github.com/endojs/endo-but-for-bots/pull/1356) and has status **In Progress** (it said Not Started). I pushed it to `journal2` as commit `512b0b17`, and `plan/validate.sh` passed with 0 errors.

**Changes to `plan/designs/endo-but-for-bots/hardened-url-shim.md`:**
- **Frontmatter:** `status: In Progress`, `pr: endo-but-for-bots#1356`, `updated: 2026-09-28`.
- **Body:** the Status row in the header table now says In Progress.
- **Reconcile note:** added at the end in the same style as the sibling `hardened-text-codecs-shim` record. It says:
  - **The PR:** it is on `build/hardened-url-shim` at `3655a3c3c5`, based on the frozen `master-6ee3fda` branch, and was opened by job `build-hardened-url-shim`. All 15 CI checks passed. It stays a draft until someone says **run the gauntlet #1356**.
  - **Phases 1 and 2 are implemented in the PR:** the permits and iterator-prototype sampling, `src/tame-url-constructor.js`, the `urlBlobMethods` lockdown option, test-plan items 1–8, the XS smoke check for item 9, and a changeset.
  - **Phase 3:** the downstream audit found no `createObjectURL` or `revokeObjectURL` calls on `master`. `llm` was not audited.
  - **Where the build differs from the design:**
    - The start-compartment intrinsic is named `%InitialURL%` instead of `%URL%`.
    - The blob methods are forwarded rather than copied.
    - Node's inspect symbol is permitted.
    - `URL.prototype.constructor` is `%SharedURL%`.
  - **Open questions:** for both, the build took the design's recommendation. The maintainer can confirm or overturn them in review.
  - **Completion:** `plan/reconcile.sh` flips the record to Complete when #1356 merges.

**Follow-ups:**
- **Unrelated change in the PR:** #1356 also bumps the pinned `dorny/paths-filter` action in `.github/workflows/ci.yml`, which has nothing to do with this design. It should be removed or justified during review; I noted this in the record.
- **Next step:** the maintainer needs to say **run the gauntlet #1356** to move the PR past draft.

I made no changes on `main2`. I couldn't read my job inbox because its journal clone timed out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-hardened-url-shim.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (933524 cached reads)
- Output: 5618 tokens
- Cost: $0.8145447999999998
- Wall-clock: 167s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
