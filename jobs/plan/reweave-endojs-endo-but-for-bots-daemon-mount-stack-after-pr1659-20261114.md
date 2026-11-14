---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1659
priority: high
role: weaver
posted_by: shepherd
posted_at: 2026-11-14T14:23:06Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reweave the daemon mount-import stack after the shared zizmor fix lands

Repo: endojs/endo-but-for-bots.

This job owns the complete remaining disposition from
`shepherd-endojs-endo-but-for-bots-pr1592`.
PR #1592's reweaved head `63520477b19864b1e04c4e6725783b9a59e9289e`
has one current CI failure: zizmor run 43591800657 reports
`ref-version-mismatch` on the two
`peter-evans/create-pull-request@5f6978f... # v8` comments.
All other current-head checks passed or were skipped.
The feature diff does not touch workflows.

The shared fix already exists as endojs/endo-but-for-bots PR #1659, head
`7c100929afcbd42998a471be29e190e397f43440`: it changes those comments to the
exact `# v8.1.1` tag without changing the action SHA, has passed its gauntlet,
is green, and is ready for maintainer review.
Do not duplicate that fix in any daemon feature branch.

When #1659 merges or closes:

1. Confirm live `llm` carries the exact-tag comment fix. If #1659 closed
   without the fix landing, stop and message the maintainer; do not copy the
   patch into the daemon stack.
2. Reweave the complete stack in order so the shared fix enters by ancestry:
   PR #1559 (`daemon-worker-import-from-mount`), then PR #1590
   (`daemon-worker-import-from-mount-phase-three`), then PR #1592
   (`daemon-worker-import-from-mount-phase-four-snapshot`). Create fresh frozen
   parent snapshots and preserve each PR's patch with range-diff.
3. Drive endojs/endo-but-for-bots PR #1592 CI to terminal green. Diagnose any
   newly exposed failure under the shepherd classification loop rather than
   stopping after the first red.
4. Post the required SHA-anchored completion summary on PR #1592, including the
   green run URL. Standing authorization for endojs/endo-but-for-bots applies.

PR URLs:

- https://github.com/endojs/endo-but-for-bots/pull/1559
- https://github.com/endojs/endo-but-for-bots/pull/1590
- https://github.com/endojs/endo-but-for-bots/pull/1592
- https://github.com/endojs/endo-but-for-bots/pull/1659
