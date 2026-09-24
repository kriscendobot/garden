I answered dckc's comment on kriscendobot/garden#112 and found the root cause, but the fix needs a human on the leader host. I've asked the maintainer to do it.

**Why dckc's comments got no 👀:**
- **Oros comments** (the PR #2 review thread from 2026-09-17 and the PR #3 comment from today): the pull requests are on upstream `Oros-AI/oros-ckm-data-readiness`. The watch set only covers the `kriscendobot` fork, so the only watcher that could see these comments is the GitHub-wide mention watcher, `garden-mention-watcher`. It isn't running on the current leader (`endolin-garden-ece02cb4`): its journal cursor `cursors/mentions/kriscendobot` hasn't moved since 2026-07-08. `install-units.sh` never turns this watcher on automatically, so it was not re-armed when the leader changed hosts. The latency watch had already raised `comment-watcher-dead-Oros-AI-…` notices.
- **dckc's 16:51 comment on kriscendobot/garden#112**: the issue-inbox watcher missed it. The watchdog flagged it about 20 minutes later, and the 17:19 repost was acknowledged within 32 seconds. I couldn't find the cause because the leader's logs aren't visible from this host. The newest commit on `main2`, `fe918d22339` (it retries the cursor advance when journal pushes collide), may be related, but I haven't confirmed that.
- **The PR #2 review feedback**: nothing saw it when it was posted. The earlier job only came across it while building PR #3, then chose not to apply it because the request was "otherwise just like #2". My reply says that was the wrong call.

**What I did:**
- **👀 added** to all four missed comments: two review threads on PR #2, the PR #3 comment, and the issue comment from 16:51.
- **Answered dckc's PR #3 questions** (https://github.com/Oros-AI/oros-ckm-data-readiness/pull/3#issuecomment-5818928346):
  - `Requested-by` is the garden's own convention from kriscendobot/garden#111, not part of the ASF guidance.
  - "Adopt it on the record" means one of two things: approve the PR through the GitHub buttons with a one-line ICLA statement, or re-submit it as their own commit (I gave the exact git commands).
- **Posted job `fix-oros-ckm-pr2-pr3-review-feedback`** (fixer; it confirmed on `origin/journal2` `jobs/todo/`). It carries the ISSUE NOTE verbatim. It will:
  - cut `CONTRIBUTING.md` to one or two sentences;
  - move the typecheck step into the existing CI workflow if there is one, instead of adding `lint.yml` (the base branch `ckm-poc-build` has no `.github/workflows`, so the fixer has to check other branches);
  - make the same change on PRs #2 and #3, reply in each review thread, and post on #112 when done.
- **Messaged the maintainer**:
  - asked them to run `systemctl --user enable --now garden-mention-watcher.timer` on the leader;
  - warned that its first run will pick up every addressed mention since 2026-07-08 as a job, so they may want to move the cursor forward first (to around 2026-09-17);
  - asked whether this watcher's on/off state should be a journal flag, so it moves with the leader;
  - passed on the unexplained issue-inbox miss.
- **Replied on the issue** (https://github.com/kriscendobot/garden/issues/112#issuecomment-5818937406) with the plain explanation and what is now in progress.

**Still open:**
- Re-arming the mention watcher (needs the maintainer).
- The cause of the issue-inbox miss.

No garden code changed and nothing was committed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5818804304.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2088014 cached reads)
- Output: 16257 tokens
- Cost: $1.3494228
- Wall-clock: 195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
