I've added a check that stops the bot from posting a bare `#N` in a comment that also names another repo. It isn't live yet: each host picks it up at its next garden deploy.

On kriscendobot/garden#112 the `#2` was meant to point at `Oros-AI/oros-ckm-data-readiness#2`, but GitHub linked it to kriscendobot/garden#2. The `fully-qualified-github-urls` skill already forbade bare numbers, but agents kept forgetting it, so the rule is now enforced in code.

**What changed** (commit `15f3e3815cb` on main2, pushed):
- **The check:** every comment the bot posts goes through its `gh` wrapper. The wrapper now refuses a comment that both:
  - names a repo other than the one it's posted on (an `owner/repo#N` or a `github.com/owner/repo` link), and
  - has a bare `#N` outside code, links, URLs, or HTML comments.

  The error message tells the agent to write `owner/repo#N`, a full URL, or a backticked `#N`, and post again. The code is in `scripts/jobs/comment-body-guard.sh`, wired into `scripts/jobs/bin/gh`.
- **When it doesn't block:**
  - It lets the comment through if it can't tell which repo the comment is going to.
  - It skips fixed-template comments posted by scripts (`GARDEN_NO_LLM=1`), since a script can't read the error and repost.
  - `GARDEN_ALLOW_BARE_ISSUE_REF=1` overrides it.
- **A related bug fix:** the existing comment guard treated a `gh api -f body=@...` value as a file to read. With `-f`, `gh` treats it as literal text, so a comment starting with `@dckc` wasn't being checked at all. It is now.
- **Tests:** 12 new tests in `scripts/jobs/test/comment-body-guard-test.sh`. All pass (44/44), as do `comment-provenance-test` and `pr-numeric-scope-guard-test`.
- **Skill:** `skills/fully-qualified-github-urls/SKILL.md` now documents the check and the override.

**How often it would have fired:** I ran it against 2,446 recent bot comments. It flagged 158, about 6.5%. The ones I checked were mostly real mislinks, such as garden comments citing endo-but-for-bots PRs by bare number. Some flagged numbers did mean the repo being posted to; those comments will now be refused until the numbers are written in full. That's what the skill already asks for when a comment mentions more than one repo, but agents will see more refusals and reposts at first.

**On GitHub:**
- I edited the offending reply on kriscendobot/garden#112 so its references are written in full, with dckc's quoted `#2` put in backticks so it doesn't link.
- I replied to dckc on kriscendobot/garden#113 (https://github.com/kriscendobot/garden/issues/113#issuecomment-5818565013) and left the issue open for them to close.

**Follow-up:** old bot comments with the same mislinks are still out there; I only fixed the #112 reply.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-113.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2304725 cached reads)
- Output: 23240 tokens
- Cost: $1.6131130000000002
- Wall-clock: 268s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
