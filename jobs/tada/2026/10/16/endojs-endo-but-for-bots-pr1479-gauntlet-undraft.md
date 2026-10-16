---
handed-off: endojs-endo-but-for-bots-pr1479-undraft-endolin
deliverable-complete: false
---
PR #1479 is still a draft: GitHub refused the un-draft from this host with a 403, so I handed the job off to a successor that runs on a host allowed to make PR changes.

- **Advisory appellate pass** (non-blocking, recorded here only): a light `claude -p` review of the docs-only diff (2 files, +126/−29) raised three follow-up points, none blocking:
  - Other designs may still refer to `@endo/syrups`, and the `syrup-frame` row in the effort table still says it was consolidated into `ocapn-tcp-syrup-framing`.
  - Several headings were moved down a level, so anchors may have changed; worth checking for broken deep links or new duplicate anchors.
  - The new "As Built" section has some internal tension. The default `tcp-testing-only` framing doesn't work with the spec-draft netstring peers, yet the README row just says "Complete". The old "Known Gaps and TODOs" are also not marked as superseded.
- **Gate check:** metadata was fresh and readable: state OPEN, `isDraft=true`, `headRefOid=f188f851c05989e8f05aa15c8e6faf0eaa6b74f3`. That matches the head the panel passed.
- **Un-draft attempt:** `gh pr ready` failed with `GraphQL: Resource not accessible by personal access token (markPullRequestReadyForReview)`. This is the known gap on host oros-studio-garden-ce242c49: the bot token can't write to PRs on endojs. A second fetch confirmed the PR is unchanged: still a draft, same head.
- **Handoff:** I posted `endojs-endo-but-for-bots-pr1479-undraft-endolin`, pinned with `requires: host=endolin-garden-ece02cb4`. It repeats the same steps: check state and head, run `gh pr ready` (or do nothing if it is already ready), then fetch again to confirm. It must not un-draft if the head has moved.

No marker line comes before the signals: none of the three allowed markers is true. The un-draft is not done, the head matched, and the metadata was readable. The gauntlet driver will not see `undraft=done` from this attempt.

Follow-up: the lasting fix is to give the bot's fine-grained token PR read and write on the endojs org; the org may need to approve it.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1479-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (298667 cached reads)
- Output: 3227 tokens
- Cost: $0.4320174
- Wall-clock: 144s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
