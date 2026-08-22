---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr987-review-a172f78f
verdict: not-a-miss
category: new-direction
review_at: 2026-08-17T22:23:32Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/987#pullrequestreview-4955075737
identity: endojs/endo-but-for-bots#987:review:4955075737
---

Changes-requested review on the merged design PR "design(endor): bind libgit2 with
Zig cross-builds" (`designs/endor-git-bindings.md`). The review bundles three
maintainer scope/prioritization decisions, none corrective of a defect: (1) treat
GNU/Linux as good enough for the first pass and defer the Windows/native-MSVC arm to
a parked follow-up; (2) an agreement note ("Aye") on the standing point that the
release owner must pick and test an explicit minimum-glibc floor before the Linux
artifacts go public; (3) keep the binding crate as a local, commit-pinned Cargo
dependency shared with Minion Town rather than publishing it to a registry.

Grounds: every point is new direction / scope / taste reserved to the maintainer, not
an anticipatable review miss. The design as authored was thorough — it specified the
full Windows+macOS+Linux Zig cross-build matrix — and the maintainer's call to ship
Linux first and defer Windows is a prioritization preference, not a defect a panel
seat could or should have flagged; a complete cross-platform spec is a strength, not a
violation. The publish-vs-local decision is a product/distribution choice first stated
in the comment (the PR's own Upgrade Considerations already described a commit-pinned
dependency; "don't publish to a registry" narrows it further and is the maintainer's
to make). The "Aye" is assent, with nothing to catch. There is no evaluator-gaming
avoidance shape: a full design gauntlet ran on #987 — gauntlet-clean, two panel rounds
(gauntlet-panel-1, gauntlet-panel-2), and gauntlet-fix-1, all in journal/jobs/tada/ —
so the evaluator was satisfied, not skipped. Verified against the world, not the
primary's report: the primary posted threaded replies recording each decision (commit
`f265f98c10`) and parked the Windows follow-up job
`design-endor-git-windows-followup`, which is present on the board (jobs/plan/), so the
directive deliverable genuinely exists and is not a false no-op claim. Nobody could
have anticipated these maintainer scope calls in the #987 gauntlet — they are the
maintainer answering a design's open scope questions, which is exactly what a design
review PR is for.
