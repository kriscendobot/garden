I did no work on this job and changed nothing, because the work it asks for has already been done by the job that replaced it.

**Why:** The job carries a note dated 2026-10-16 saying it was superseded by `garden-book-pr15-merge-and-publish-draft-20261016`. The maintainer dropped the clean-gauntlet requirement and asked for an immediate merge plus a draft edition on ocap.site. The note says "Do not promote this job", but it was promoted anyway at 2026-10-17T03:02:05Z, about six hours after the note was added.

**What I checked:**
- **The replacement job is finished.** Its completion report is in the journal at `jobs/tada/2026/10/16/garden-book-pr15-merge-and-publish-draft-20261016.md`.
- **PR #15 is merged.** https://github.com/kriscendobot/garden-book/pull/15 was merged on 2026-10-16T22:07:05Z at head `ef627035`, with merge commit `9b2a603`, under the maintainer's override. That job also cleaned up the frozen base branches.
- **A new draft edition is live and recorded.** It is at https://xkmof32e37co54ni4b2gm5r3ls73uhsvodwg4jpmqni2jcv4fluq.ocap.site/. According to that job's report, all 27 served files match the build byte for byte and carry the immutable headers. The edition is recorded in `build/README.md` (`51f6c5d` on `main`).
- **No history PR, by the maintainer's choice.** The replacement job skipped it on purpose because the maintainer plans to rewrite `main`'s history later.

**What I left alone:**
- I did not run `gauntlet.sh` on `kriscendobot-garden-book-pr15-gauntlet`. The PR is already merged, so running it would only re-review merged code.
- I did not merge, publish or open a PR, so there is no duplicate edition or merge.

**Follow-up:** Something promoted this job even though it was annotated "do not promote". Whatever handles go-ahead promotions should check for SUPERSEDED annotations before promoting a job. The leftover journal record of `kriscendobot-garden-book-pr15-gauntlet` may also be worth archiving or withdrawing. I did not edit it, as the job spec instructed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-book-illuminations-finish-after-quota-refresh-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168623 cached reads)
- Output: 1514 tokens
- Cost: $0.3993326
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
