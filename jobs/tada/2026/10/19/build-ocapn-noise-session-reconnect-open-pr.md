Opened the draft PR: https://github.com/endojs/endo-but-for-bots/pull/1502

- **Before opening:** `ensure-pr.sh --find-only` found no PR carrying this job's marker. Running `gh pr list --head llm-ocapn-session-heartbeat --state all` also came back empty, so nobody had opened one already.
- **The PR:** I ran `ensure-pr.sh --draft` from the isolated project checkout (`scratch/project-wt-build-o-12c990ee43ee-6d3fb750`, detached at `e8e42fbea9`). The phase-evidence gate found `designs/ocapn-noise-session-reconnect.md` there. The PR uses the job's title and the PR body word for word.
- **Checked on GitHub afterwards:** the PR is a draft, its head is `llm-ocapn-session-heartbeat` at `e8e42fbea9e4c27fb4f22e47a9b3241698a50c41`, and its base is `llm-330cf99`. `ensure-pr.sh` recorded #1502 on `work/build-ocapn-noise-session-reconnect-open-pr`.
- **Unchanged:** I didn't edit any code or garden files, and made no commits to `main2`.

**Follow-ups:** none from this job. The normal gauntlet (clean → panel → fix-loop → un-draft) should be staged when this job completes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-noise-session-reconnect-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (235660 cached reads)
- Output: 2942 tokens
- Cost: $0.471212
- Wall-clock: 71s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
