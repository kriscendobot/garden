I opened the draft PR: **https://github.com/endojs/endo-but-for-bots/pull/1639**.

- **Repo:** `endojs/endo-but-for-bots`.
- **Branches:** head `feat/endopi-extension-package-manifest` at `6836200e18`, matching the remote; base is the frozen `llm-48d6f3e`.
- **Title:** `feat(cli): install packages of skills and prompts with one command`.
- **Body:** the body from the job, word for word, including the phase ledger (`orchestrated-slice`).
- **Packages affected:** `@endo/cli`, `@endo/tar`.
- **How it was opened:** `ensure-pr.sh` with the original job base `endopi-extension-package-manifest-build`, so the durable marker matches that job. It warned that the "Decisions for the maintainer" heading isn't in the base branch's PR template; that is allowed.
- **Not recorded on the board:** `ensure-pr.sh` didn't record the PR, because there is no `work/endopi-extension-package-manifest-build` claim here. Whatever stages the gauntlet will need the PR number from this report.

I didn't change any code, run the panel, or take the PR out of draft.

**Parked successor `endopi-extension-package-guest-provider-kinds`:** its body never contains the phrase "the matching PR". It names the PR only by its head branch and job. So instead of editing the text, I added a note with the PR #1639 link using `annotate-plan.sh` (key `endopi-manifest-pr-1639`, so re-running it won't add a duplicate).

**Follow-ups:** stage the gauntlet for #1639. The successor stays parked until the maintainer gives the go-ahead.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-extension-package-manifest-build-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (372825 cached reads)
- Output: 3902 tokens
- Cost: $0.561085
- Wall-clock: 73s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
