---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-60fc33cf
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T21:30:16Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4976914415
identity: endojs/endo-but-for-bots#475:review:4976914415
---

Review (CHANGES_REQUESTED, empty body, one inline comment) from a senior maintainer on
the narrow-bytearray PR. The inline point was a security follow-up: the maintainer had
noticed that an earlier bot reply lost its `inline-code` spans, the bot explained the loss
came from the comment body being interpolated into a shell word, and the maintainer now
asked whether that is a shell command-injection vulnerability, to treat it as an emergency
if so, and to report on any flaws in the bot's generation logic or guardrails it cannot fix.

Grounds: this is not an indictment of the PR review process. Grounded in the world (the
review metadata, the primary's pushed garden commit, and the addressed PR thread, not the
primary's self-report): the feedback is about the garden's OWN comment-posting automation
(a command-injection sink where Bash command-substitutes backticks/`$(...)` in a body
placed on a `gh` command line before `gh` runs), triggered by the maintainer observing the
bot's own reply corruption. That surface is never in any PR panel's reach. The gauntlet
reviews the endo-but-for-bots diff; a command-injection flaw living in the garden's `gh`
comment-posting shell discipline is not part of PR #475's code product, and the garden runs
no PR gauntlet on its own scripts, so no juror seat (locksmith/warden included), skill, or
standing instruction had any surface on which to catch it. This is a garden-automation
defect, the mentor loop's domain (the machinery misbehaved), not the prosecutor loop's
review-process domain, and no reviewer in the PR cycle could have anticipated a Socratic
security question about the bot's own tooling behavior.

The primary was a genuine fix, not a no-op: garden commit `9af1194301` (confirmed present
on `main2`) landed a standing shell-injection rule in `roles/COMMON.md` and rewritten
file-based-posting guidance in `skills/pr-review-thread-replies/SKILL.md` (verified — the
COMMON.md section "Never put a comment/PR/issue body on a shell command line" and the skill's
"Pass the body as a file" guidance both exist), and the reply was posted via the file-based
path with all code spans intact. The primary also honestly retracted a prior false claim
that a deterministic `gh`-wrapper guard existed, and offered mechanical enforcement as an
un-owed follow-up. That prevention already lives in the correct artifacts through the
mentor/automation channel; there is no review-cycle check to add here because there is no
review cycle that reviews garden shell scripts. New direction (a garden-tooling security
question first raised in this comment), not a review-process miss.
