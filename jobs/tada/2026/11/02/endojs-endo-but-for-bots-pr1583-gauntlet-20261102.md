## PR #1583 gauntlet: not run, maintainer decision needed

I did not run the gauntlet on endojs/endo-but-for-bots#1583, and nothing was pushed or posted to the PR. Running it would repeat a refusal that still stands, so I sent the open decision back to the maintainer instead. The clean, panel, fix-loop and un-draft stages did not run.

**The job's premise is wrong.** The job says #1583 has no gauntlet in the completed list, but `jobs/tada/2026/10/` holds two:
- **`endojs-endo-but-for-bots-pr1583-gauntlet`:** completed on 2026-10-29 with `panel_head` `82de63bdb4`.
- **`endojs-endo-but-for-bots-pr1583-gauntlet-a08c450`:** run on the current head and refused at viability on 2026-10-30 as `overtaken`, recommending close as superseded. The maintainer notice was delivered, but I found no decision on the PR or in the journal files I searched.

**The refusal still holds, from GitHub and journal reads today:**
- **Head:** still `a08c4505c0`. The PR is open, not a draft, and mergeable, with no failed checks.
- **Overlapping PRs:** #1431 (`1286f427b5`), #1576 (`02dbd31bf2`) and #1584 (`6ff4138d1a`) are still open and unmerged. The #1431 head matches the viability report; the other two were not named in it, and none has been updated since 2026-10-29.
- **Conflict:** #1431, #1576 and #1583 all edit `designs/hardened-text-codecs-shim.md`, and the viability report found they rewrite the same sections.
- **False claim in the diff:** #1583 still says no open pull request carries the XS smoke coverage, but #1584 does.
- **`llm`:** 8 commits past the `9a14ddf660` base, with no changes to the design doc, `designs/README.md` or `cauterize-property.js`. I could not test directly whether `679d9afaa4` is an ancestor because the compare API returned 404, so "the fix is still not on `llm`" is inferred from `cauterize-property.js` being unchanged.

**Why no new gauntlet:** a fresh record would most likely get the same refusal and a duplicate notice. A panel on a PR that may be closed would also be wasted spend.

**Maintainer message:** delivered as `msg-endojs-endo-but-for-bots-pr1583-gauntlet-20261102-6fc75a5d5d52`. It recommends closing #1583 as superseded and moving its one unique point (separating the XS repair owned by #1425) into #1431. If they keep #1583 instead, it needs the XS text corrected to cite #1584, #1431 and #1576 closed or reconciled, and a fresh gauntlet. The open re-review item on their docket depends on the same decision.

**Follow-ups:**
- **Maintainer:** decide whether to close or keep #1583.
- **Unfixed, could recur:** whatever generated this job missed both completed gauntlets, possibly because their names differ from the expected base. I did not trace the cause, so another backlog sweep could post this job again until #1583 is decided.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `82de63bdb4f65cbff15c83f6177274b5274789b5`; this job presented `a08c4505c09e66f6f7df31ac5df392b4be5db9d5`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1583-gauntlet-20261102.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (888145 cached reads)
- Output: 10934 tokens
- Cost: $1.1159810000000003
- Wall-clock: 394s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
