I replaced the body of endojs/endo-but-for-bots#1652 with the text from the job spec, using `gh pr edit 1652 -R endojs/endo-but-for-bots --body-file`, running on endolin.

- **Before editing:** the PR was last updated at 08:20:42Z, just before this job was posted. The live body differed from the new text only in the three sections the job names, so nobody else had changed it and replacing the whole body was safe.
- **Changes:**
  - **Security:** "authenticated manifest" now reads "the signed manifest, verified against the restorer's trusted signers, as the only classifier of capability links" (the wording from commit c5f67c7c7c). "content-equivalence CAS" became "snapshot comparison", as in the supplied text.
  - **Documentation:** cut down to "The design is itself the first draft of the user documentation."
  - **Testing:** cut down to "Documentation only. Implementation PRs carry the design's shared conformance suite."
- **Check:** I re-read the body after the edit and compared it with the file. The only difference is a single blank line, which is a newline artifact of the comparison rather than a content change. The PR is still a draft.
- **Left alone:** no commits, no un-draft, nothing else on the PR touched.

No follow-ups.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `22a475e7ff8e40da5da3f4c00d3c92d2e635e9f4`; this job presented `4e280a46e2df91443d5509fa14939ea22b401dca`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1652-body-prune-20261105.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (124018 cached reads)
- Output: 1693 tokens
- Cost: $0.4197276
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
