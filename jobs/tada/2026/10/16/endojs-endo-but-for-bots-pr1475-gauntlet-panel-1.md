# Panel round 1: endojs/endo-but-for-bots PR #1475 — panel-error (verdict reached, but GitHub refused the post)

The panel judged the PR a **pass**, but GitHub rejected the review post with a 403, so the verdict is not on the PR. I'm completing with `panel=panel-error` so the driver retries this round on a host whose token has write access to endojs pull requests. A false `pass` marker would let the gauntlet move on with no verdict on the PR.

**What ran**
- **Project checkout:** `/Users/dom/garden/scratch/project-wt-endojs--4dee1c256251-ea6c9eb6`, at head `453413b83` on `kriscendobot/endo-but-for-bots:design/ocapn-noise-cryptographic-review`. The base is `llm-61cd656` (61cd656cb).
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 1475 61cd656cb` exited 0 with disposition **pass**. All 9 seats came back `ok`: critic, skeptic, decomplector, ergonomist, novice, pedant, copyeditor, orthographer and thesaurus.
- **Run record:** saved to the journal as `panel-runs/kriscendobot-endo-but-for-bots-1475/454fba9ec06b.md`, so a retry with the PR head unchanged can reuse it.

**What the reviewers found**
- Most findings are should-fix design-prose items:
  - the replayed-SYN cap can be used to block legitimate connections;
  - the arguments for its recommendations R2 and R3 (session identity and dropping Resume) depend on each other, so open question Q2 is effectively answered by R3;
  - the joint-security proof is cited as a direct match but is only an analogy;
  - it never says what removing Resume costs;
  - the identity-hiding numbers aren't checked against the Noise spec;
  - some acronyms are undefined.
- The pedant marked one item must-fix: a typo in § 7, "25519" where it should say "X25519". The decider graded it non-blocking.
- The thesaurus seat couldn't fetch the live PR title or body, so the PR body was not checked for AI-cliché phrasing.

**Why the post failed**
- `gh pr review --comment` returned `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`.
- This is the known gap on host `oros-studio-garden-ce242c49`: the bot's token has no PR write access on the endojs org.
- The review body is ready at `<rundir>/review-body.md` (26 KB, under GitHub's size limit), but that directory is scratch and won't survive this job.

**Follow-ups**
- The lasting fix is granting the bot's token **Pull requests: write** on endojs; until then, panel posts on endojs fail from this host.
- I added this occurrence to the memory note about the endojs PR-write gap.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1475-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (806504 cached reads)
- Output: 4548 tokens
- Cost: $0.6641568
- Wall-clock: 949s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
