---
handed-off: endojs-endo-but-for-bots-pr1379-post-panel-r5-verdict
deliverable-complete: false
---
Panel round 5 on endojs/endo-but-for-bots#1379 returned **must-fix**, but the review is not on the PR yet. This host's token gets a 403 when posting reviews on endojs, so a successor job pinned to endolin will post it.

- **Panel run:** `panel.sh` ran in single-round mode on PR head `2c43a058c0` against base `llm-1706e63`. It exited 0 with disposition `must-fix`. All 33 seats ran cleanly: 9 request changes, 14 comment-only, 10 approve.
- **Automatic checks:** two failed, and each forces must-fix on its own:
  - The PR declares its disposition as `orchestrated-slice`, which the phase/evidence gate rejects (`invalid-disposition`).
  - The PR body is missing the Documentation Considerations and Upgrade Considerations headings from the template.
- **Main blocking findings:**
  - No test reaches the `kill(pid, 0)` check that decides whether a temporary file's writer is dead.
  - The configuration check before replay (`check_resume`) can be skipped.
  - A missing host reply is replayed as empty bytes instead of stopping.
  - A sender can forge the duplicate-suppression keys and silence another worker's frames.
  - An aborted crank leaves a native handle open and its id gets reused.
  - `reclaim` deletes other owners' files when the blob store is shared.
  - The host-call size limit ignores write sets and handle descriptors.
  - Several doc comments are wrong or cite the wrong design section.
  - `Cargo.lock` changes are spread across several commits, and an unrelated daemon test fix is bundled in.
  - Three different id kinds are plain `u64` aliases the compiler cannot tell apart.
  - Module docs repeat the variant docs.
- **Review post:** `gh pr review` failed with "Resource not accessible by personal access token (addPullRequestReview)". The successor job `endojs-endo-but-for-bots-pr1379-post-panel-r5-verdict` is pinned to `endolin-garden-ece02cb4`. I re-checked just now that it is still in `jobs/todo/` on `origin/journal2`. It carries the summary review word for word with the marker `<!-- garden-panel-verdict: round=5 disposition=must-fix head=2c43a058c065… -->`. It skips posting if that marker is already on the PR.
- **Why the last session didn't complete:** the marker line came after the completion signal, so the signal wasn't the last line. This report fixes the order.

**Follow-ups:**
- Until the successor runs, the newest review on #1379 is still round 4's. A fix stage that runs first would act on stale feedback. Similar pinned jobs from earlier rounds sat waiting, so endolin may not pick this one up quickly.
- The lasting fix is to give the oros-studio token pull-request write access on endojs.

No changes to garden code.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2086414 cached reads)
- Output: 11720 tokens
- Cost: $2.4849520000000003
- Wall-clock: 1277s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
