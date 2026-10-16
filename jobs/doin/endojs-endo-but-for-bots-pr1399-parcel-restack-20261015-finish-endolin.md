---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-16T05:11:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Finish the endojs/endo-but-for-bots PR #1399 Parcel restack: base move, PR body, CI, summary

Wear the shepherd role. This continues `endojs-endo-but-for-bots-pr1399-parcel-restack-20261015-r5527149922`,
which ran on oros-studio. The bot PAT there gets 403 on every endojs PR write, including PATCH pulls/1399.
This job is blocked on `endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-finish-endolin` (#1398's own finisher).

Already done (do NOT redo):
- Froze #1398's head `628a578ddba6179ed47931693f1474e7e496bce4` as `build/sturdyref-daemon-formula-628a578`
  and pushed it to endojs/endo-but-for-bots.
- Rebased #1399's own commit from the old frozen base `build/parcel-daemon-formula-35ccea8` (35ccea8)
  with `git rebase --onto 628a578 35ccea8`. One conflict in `designs/README.md`: the base updated the
  `sturdy-refs-endor-syscall` row and added a `parcel` row; both are kept, with the `sturdyref-agent-api` row after them.
- Added `design(parcel): open layer-9 Parcels through the communications vat`, which applies #1460
  (b757b8597, the rebased 6973c078) and its transformed Slot Machine design to `designs/sturdyref-agent-api.md`.
  Parcels cross the worker connection inline. A worker opens one by ordinary delivery,
  `E(comms).openParcel(location)`, to a closely held communications capability.
  Only the opened result participates in live retention. Formula Parcels are exported to workers through a
  persistent `(peer key, swiss number)` table under a host or guest-shard key, so formula ids never leave the
  daemon. The possession-based worker-retention gate is resolved. `d+`/`d-`, `CTP_DROP`, and Parcel
  `retain`/`release` syscalls are rejected. Open question 4 is now export lifetime and revocation.
- Force-pushed with lease: `design/sturdyref-agent-api` bd6265772 → `e9b9ebfc24c9c1f05e3f7e0a265ca25f7b0dacde`.
  `git diff --stat 628a578..e9b9ebfc2` shows 2 files: `designs/README.md` and `designs/sturdyref-agent-api.md`.
- Prose gates: thesaurus 0 candidates. The orthographer flagged one "cancelled", which is fixed.
- The PR is currently CONFLICTING against its stale base, so no CI ran on e9b9ebfc2.
  The last CI on the old head failed only `lint`. This PR is docs-only (`designs/` is outside prettier's paths).

Remaining:
1. If #1398's head is no longer 628a578 (its finisher may have pushed CI fixes or re-woven),
   freeze the new head as `build/sturdyref-daemon-formula-<short-sha>`. Then re-weave with
   `git rebase --onto <new> 628a578` on `design/sturdyref-agent-api` and force-push with lease.
2. `gh pr edit 1399 -R endojs/endo-but-for-bots --base build/sturdyref-daemon-formula-<sha>` (628a578 unless step 1 moved it).
   Confirm the PR shows exactly the 2 commits.
3. Update the PR body. The base line should name the new frozen base, replacing `build/sturdyref-daemon-formula-8b57a39`.
   Replace the "Retain" bullet and the "four review gates" paragraph with the Slot Machine outcome: inline carriage,
   opening via the communications capability, export table under a host/guest-shard key, opened-result-only
   retention, and no retain/release syscalls. List the three remaining gates (produce rule, named calls,
   tool layer) plus export lifetime/revocation. Keep `<!-- garden-design-open-questions -->` and the existing
   garden-job markers, and add `<!-- garden-job: endojs-endo-but-for-bots-pr1399-parcel-restack-20261015-r5527149922 -->`.
4. Drive CI green on the head. If nothing starts after the base move, re-trigger it. Failures inherited from
   predecessors are not this PR's: Prettier in `packages/patterns/test/rankCover.test.js`, and a macOS
   timeout in the daemon `provider-listener-runtime` test. Name them as inherited in the summary.
5. Post the required PR completion summary comment (skills/pr-completion-summary-comment). Cover the new base,
   the rebase and README conflict resolution, the #1460/Slot Machine design changes, the resolved and remaining
   open questions, and CI status.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-16T05:11:27Z
