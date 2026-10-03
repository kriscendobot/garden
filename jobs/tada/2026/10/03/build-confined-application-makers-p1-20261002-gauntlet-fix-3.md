# Gauntlet fix round 3: endojs/endo-but-for-bots#1417

I fixed both of the panel's round-3 must-fix items and five of its nine should-fix items, and pushed the code changes. CI is green: all 33 checks passed, with `ci-wait-merge` returning rc 0.

## Must-fix (both done)
1. **PR body now follows the upstream template.** I restored the two missing sections, `### Scaling Considerations` and `### Documentation Considerations`, so all seven headings appear in template order.
2. **PR body is shorter.** It went from 375 to 253 words. I cut the description of how validation works from the Security section, removed the test counts, and replaced the five bullets that began with code spans with prose. The `garden-job` marker is kept.

## Should-fix items I folded in
I pushed these as one follow-up commit, `4444a44691`, with `safe-push-pr-head.sh`; the head advanced by fast-forward from `608cafdbcf`.
- **Original error kept:** if the walk that checks whether an entry is absent throws, `maybeRead` now rethrows the original `lookup` error.
- **Lone surrogate:** `encodeSegment` now turns the raw `URIError` into a tree error. The `canonical` hook's output is now checked with `encodeSegment`, the same encoder used when building the location.
- **Root escapes:** `assertRoot` now refuses malformed percent-escapes (`%zz`, a bare `%`) and separator escapes (`%2F`, `%5C`, `%00`).
- **Design doc:** it now lists `{ root, canonical }` and says the Phase 1 default `canonical` is the identity and does not behave like realpath.
- **Tests:** I added three, one for each code change above. The test file passes locally (38 tests), and ESLint reports no problems in `src`.

## Should-fix items I left for the next panel
- Regrouping the commit history into four commits. That needs a history rewrite, so I did not do it in this round.
- Replacing the segment check with `assertChildName`. Its error messages are different (EINVAL).
- Using one predicate to decide "file or directory".
- Handling different spellings of one location in the default `canonical`.
- The path codec matching only one Node version.

I did not re-run the panel; the driver posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1521474 cached reads)
- Output: 8623 tokens
- Cost: $1.0085468000000002
- Wall-clock: 2209s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
