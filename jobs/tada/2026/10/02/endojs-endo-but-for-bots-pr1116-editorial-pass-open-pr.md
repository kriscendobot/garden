I opened the PR, CI is green, and the conductor job to merge it is on the board.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1416, a draft with head `design/guest-native-invitations-editorial` @ 9a054a55f9 and base `llm-ca1794f`. I opened it with `ensure-pr.sh` under the original job's marker. I checked first and no earlier PR existed.

**Changes to the planned PR body:** `ensure-pr.sh` refused it twice:
- **Template gate:** the body didn't follow the repo's PR template. I rebuilt it as `Refs: #1116`, then `## Description` holding the original text, with "What was cut" and the fact-location table as bold labels instead of headings. Each `###` Considerations section got one sentence saying it doesn't apply to a docs-only change. The essential-facts table and the job marker are unchanged.
- **Phase/evidence gate:** this check runs against the current directory, which was the garden worktree rather than the project. Re-running from an isolated project checkout of the head branch passed it.

**CI:** green. 6 checks passed and 22 were skipped as docs-only. Nothing needed fixing.

**Merge:** I posted a conductor job, `endojs-endo-but-for-bots-pr1416-conduct`, now in `jobs/todo/`. It cites kriskowal's #1116 review ("Then, shepherd and conduct.") as the merge authorization. It tells the conductor to switch the base back to live `llm`, un-draft, and merge without naming a merge method. If it judges an approval given on #1116 insufficient for a merge of #1416, it should ask the maintainer instead.
- The first post attempt was silently dropped as a duplicate: `post-job.sh` took the #1116 review URL in the body as the job's identity, and this job already owns that identity. I reposted with an explicit identity, `endojs/endo-but-for-bots#1416:conduct`.

**Follow-ups:**
- The PR isn't recorded under `work/endojs-endo-but-for-bots-pr1116-editorial-pass`, because that record doesn't exist on the board. The job marker in the PR body is what lets a retry find it.
- Two script gaps:
  - `ensure-pr.sh` runs the phase/evidence gate against the current directory, so a shepherd working from the garden worktree has to know to cd into the project checkout first.
  - `post-job.sh`'s identity-from-body dedup silently swallows a follow-on job that cites the parent job's review URL.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-editorial-pass-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1174745 cached reads)
- Output: 6889 tokens
- Cost: $0.863761
- Wall-clock: 1119s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
