I recorded this review as **not a review miss**. It was new direction from the maintainer, not something the review process should have caught.

**What the review asked for:** Review 5527149922 by kriskowal (changes requested) on PR #1460 made two requests.
- **Body:** address the feedback, then post an orchestration that restacks each existing SturdyRef pull request onto the Parcel changes, one at a time.
- **One inline comment** on `designs/sturdy-refs-endor-syscall.md`: decide whether that design is superseded or needs a full rewrite now that Parcel exists. The comment also proposed new architecture:
  - Slot Machine has to carry Parcels, so "syscall" is probably the wrong framing.
  - Parcels should be opened through the comms vat.
  - Each vat may need its own key pair.

  The maintainer said they didn't remember the current Slot Machine wire format.

**Why it isn't a miss:**
- Every requirement in the comment was stated for the first time there. No seat brief, skill or standing rule covers it.
- The review process had no chance to catch it. Before the review (02:06Z), the gauntlet had only run viability (proceed) and clean (no-op, docs only). No panel had run. The PR merged at 03:04Z, and the panel stage then skipped because the PR was already merged. The gauntlet wasn't skipped; the maintainer reviewed while it was still running.
- The existing cluster `stale-related-design-direction` doesn't fit. It covers work that continues after related maintainer direction already exists, and here the direction first appeared in this review.

**Checking the primary job's claims:** I checked GitHub and the board directly rather than relying on the primary job's report, and nothing disagrees with it.
- PR #1460 merged at 2026-10-15T03:04:42Z (merge commit `b11661caf3`).
- It includes commit `6973c078f6` ("docs(parcel): design Slot Machine carriage and opening"), which rewrites the syscall design as Parcels across Slot Machine.
- The restack orchestration `endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922` and its per-PR restack child jobs are all in `jobs/tada/`.

**What changed:** One dismissal record, written by `review-miss-record.sh` to `review-misses/dismissed/endojs-endo-but-for-bots-pr1460-review-5f2333db.md` on journal2. It paraphrases the review; none of the untrusted text was copied. No cluster was created or updated, and no improvement job was posted. There were no garden code changes.

**Follow-ups:** None.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1460-review-5f2333db-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (629230 cached reads)
- Output: 5181 tokens
- Cost: $0.778562
- Wall-clock: 84s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
