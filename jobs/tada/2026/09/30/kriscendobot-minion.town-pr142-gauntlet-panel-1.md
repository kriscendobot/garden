Panel round 1 on kriscendobot/minion.town#142 ("design(clips): clip lifecycle authority as capabilities") came back **must-fix**.

- **Panel run:** I ran the panel in single-round mode against head `0e2ccb8`, in an isolated project worktree, with base `origin/main-33aac61`. It exited 0 with disposition `must-fix`. It was a design panel with nine seats: critic, skeptic, decomplector, ergonomist, novice, copyeditor, pedant, orthographer and thesaurus. The ownership-map pre-pass flagged ATTENTION, so the decomplector seat was forced on.
- **Main findings:**
  - **must-fix (critic):** the design doesn't say how the caretaker and revoker persist across a daemon restart. A restart could silently undo a revocation.
  - **should-fix (critic):**
    - Re-registering is no longer idempotent, and a guest that loses its controller has no way to get it back.
    - Nobody has checked that an MCP-driven guest can actually adopt a delegated controller.
    - The migration plan in § 8 doesn't cover guests that were renamed or deleted, or third parties already holding the old swiss numbers.
    - The rationale in § 2.1 leans on a temporary gap left by #85.
  - The other seats add dependence on the unmerged #85 head, the ambiguous naming under #88, and copyediting and clarity notes.
- **Verdict posted:** GitHub refused `--request-changes` because the bot wrote this PR ("Can not request changes on your own pull request"). I posted it as a COMMENTED review instead (kriscendobot, 2026-09-30T09:37:31Z), headed "Panel verdict: must-fix (gauntlet round 1)". It carries the full aggregate from `round-1.md` and a `garden-job` marker.
- **Link-check override:** the gh wrapper blocked the post because the text has bare `#85`/`#88` alongside an `endojs/endo-but-for-bots` reference. I confirmed both numbers are minion.town PRs (#85 is the in-place front-content upgrade, #88 the immutable-content clip design), so the links are correct, and posted with `GARDEN_ALLOW_BARE_ISSUE_REF=1`.
- **No other changes:** no garden commits, no fixes and no un-draft, as the stage requires.

**Follow-up:** the next-stage heuristic is expected to accept a comment-review with an explicit must-fix header. That holds for any PR the bot wrote itself, since GitHub always refuses request-changes there.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr142-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (693285 cached reads)
- Output: 4263 tokens
- Cost: $0.566821
- Wall-clock: 1386s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
