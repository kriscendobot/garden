I didn't make any edits or open a PR for this job, because the text-codecs work it asks for is already in an open PR from another job, and the URL half is already done.

- **URL shim:** out of scope, as the job's annotation says. Upstream endojs/endo#3332 merged on 2026-08-21, and endojs/endo-but-for-bots#1355 already marks the design complete in `designs/hardened-url-shim.md` and `designs/README.md`.
- **Text codecs:** a sibling job (`design-hardened-ses-shim-status-reconciliation`) opened draft endojs/endo-but-for-bots#1381 on 2026-09-29 at 19:16Z. It does what this job asks:
  - It moves `designs/hardened-text-codecs-shim.md` from Not Started to **Implemented (Phases 1–2)**, citing endojs/endo#3322 (merged 2026-07-22) and endojs/endo#3340.
  - It adds a `## Status` section that lists #1349 as the open XS smoke-test residual.
  - It updates the `designs/README.md` index row and totals.
  - All of its CI checks that ran passed.

  I checked it against #1349's current state: #1349 is still a draft at head `d98467c6b5`, all CI checks green, no reviews. #1381 already records it that way. A second PR would only duplicate it.

No commits were made to `main2`, and my search for a PR marked with this job's name found none. My inbox was empty.

**Follow-ups:**
- Merging #1381 finishes this work.
- #1381 notes that #1355 and #1381 edit neighboring lines in `designs/README.md`. Whichever lands second needs a small conflict fix and should also move `hardened-url-shim` in the README totals, which #1355 doesn't do.
- #1349 still needs its gauntlet run before it can leave draft.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-hardened-ses-shims-plan-reconciliation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 12 tokens (394033 cached reads)
- Output: 2040 tokens
- Cost: $0.6773825999999998
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
