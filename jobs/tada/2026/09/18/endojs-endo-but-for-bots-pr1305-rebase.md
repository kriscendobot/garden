Rebase complete and the summary is durably relayed to the maintainer. Writing my completion report.

---

## Completion report — `endojs-endo-but-for-bots-pr1305-rebase` (weaver)

**Outcome: rebase done.** PR endojs/endo-but-for-bots#1305 is now `MERGEABLE` (was `CONFLICTING`/`DIRTY`). Head moved `b7d2f7b4c` → **`799b32e13`**, force-with-lease pushed to `bot/build/1125-guest-invitation-primitive`.

### What I did
- #1305 is the 3/3 leaf of the #1125 stack; its base is the sibling PR branch `bot/build/1125-guest-provisioning` (a **dependency stack**, not a frozen base). #1306 (2/3) had been force-rebased (`860f9eeb4` → `9e16e50b1`), leaving #1305's head parented on the stale base tip.
- Re-parented **only #1305's own commit** onto the new base with `git rebase --onto 9e16e50b1 860f9eeb4` (cherry-pick equivalent), so the 1/3 and 2/3 work already in the new base was not re-replayed.
- **One conflict**, `packages/daemon/test/endo.test.js` — a stale-deletion vs. polish conflict. The old parent carried an early form of the `EndoDirectory.readOnly()` test block; the new base carries those same tests in their polished, landed form (from #1304's read-only-attenuation work); #1305's commit had *deleted* the early form. **Resolved by keeping the base's polished `readOnly()` tests and dropping #1305's obsolete deletion.** #1305's own guest-invitation tests auto-merged in the earlier hunks and are intact.
- Sanity: rebased delta touches the same **17 files** as the original PR with the same **+1558** insertions; deletions dropped by exactly the **63** lines of the obsolete test deletion. `endo.test.js` vs. base is `+576/-0` (purely #1305's added tests, no churn to the base's `readOnly` suite).

### Verification
- `yarn lint:types` (daemon `tsc`): ✅ clean — #1305 compiles against the new base's APIs.
- `packages/daemon/test/formula-record.test.js`: ✅ 9 passed.
- `packages/chat/test/unit/formula-view-registry.test.js`: ✅ 10 passed.
- Full daemon node-worker suite not run locally; CI/shepherd covers it.

### Follow-ups
- **Summary comment could not be posted** — bot PAT on host `oros-studio-garden-ce242c49` returns 403 `Resource not accessible by personal access token (addComment)` for endojs (a known host limitation). Per the pr-completion-summary-comment skill I **relocated** it: surfaced to the maintainer over the bus, and the full comment body is below for the orchestrator to post.
- Maintainer's chain continues: **shepherd endojs/endo-but-for-bots#1305** (drive CI green), then retcon/conduct as requested.

<details><summary>PR summary comment body (for the orchestrator to post)</summary>

**Rebased** onto the current tip of the stack base `bot/build/1125-guest-provisioning` (`9e16e50b1`). Head is now `799b32e13`; the PR is `MERGEABLE` again (was `CONFLICTING`).

This is the 3/3 leaf of the #1125 stack. #1306 (2/3) was force-rebased, so #1305's sole own commit (`feat(daemon): guest-owned invitation primitive`) was re-parented onto the new base with `git rebase --onto`, replaying only #1305's own commit (the 1/3 and 2/3 work is already in the new base).

Conflict resolution (1 file) — `packages/daemon/test/endo.test.js`, a stale-deletion vs. polish conflict: the merge base carried the `EndoDirectory.readOnly()` tests in an early form; the new base carries them polished (from #1304); #1305 had deleted the early form. Resolved by keeping the base's polished `readOnly()` tests and dropping #1305's now-obsolete deletion. #1305's own invitation tests auto-merged intact. File vs. base: `+576/-0`.

Verification: daemon `tsc` clean; `formula-record.test.js` 9/9; chat `formula-view-registry.test.js` 10/10. Full node-worker suite left to CI.
</details>

No garden-repo (main2) changes were needed for this job.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/1305 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1305-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (2686126 cached reads)
- Output: 26920 tokens
- Cost: $2.818593
- Wall-clock: 680s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
