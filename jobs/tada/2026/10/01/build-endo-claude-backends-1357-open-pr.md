I opened the draft PR **endojs/endo-but-for-bots#1412**: https://github.com/endojs/endo-but-for-bots/pull/1412

- **PR settings:** head is `build/endo-claude-backends-1357` at `d19665933dcbdb15558e328306f43e8840b2e15d`, as the job expected. Base is `llm-80054c3`. Title is as specified.
- **Marker:** the body carries `<!-- garden-job: build-endo-claude-backends-1357 -->`, so it matches the original job base.
- **Branch:** I did not modify it.

**Changes to the PR body.** `ensure-pr.sh` refused the body as given, twice, so I made two changes:

1. **Template check.** The body did not follow the repo's PR template. I moved it into the template's headings: a `Refs: #1357, #1403, #1369` line, `## Description`, and the seven `### … Considerations` sections.
   - Summary, Differences from the prototypes, What this leaves to the deployment, Phase ledger and Stack are now bold-labelled paragraphs under Description. Their content is unchanged.
   - The Tests section moved verbatim under Testing Considerations.
   - I wrote short new text for Security, Scaling, Documentation, Compatibility and Upgrade Considerations, drawn from the original body.
2. **Phase/evidence check.** This check refused the body because it couldn't find the governing design. Its path matcher read the full GitHub URL of the design link as a file path that doesn't exist. I replaced the link with the repo-relative path `designs/endo-claude-inference-backends.md`, and the check then cleared with "no ordered-design signal". It also has to run from a project checkout rather than the garden worktree. I made one with `ensure-project-worktree.sh` and ran `ensure-pr.sh` from there.

**Follow-ups:**
- `ensure-pr.sh` logged that there is no `work/build-endo-claude-backends-1357` record on the board, so #1412 was not written to that job's record. Staging the gauntlet relies on this report naming the PR.
- Possible garden fix: the phase/evidence check misreads a GitHub blob URL that contains `designs/…md` as a design path that doesn't resolve. That makes it refuse any PR body that links its design by full URL.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-backends-1357-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (831435 cached reads)
- Output: 8654 tokens
- Cost: $0.806799
- Wall-clock: 127s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
