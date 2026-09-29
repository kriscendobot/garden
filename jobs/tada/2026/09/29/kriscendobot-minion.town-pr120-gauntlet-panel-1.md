Panel round 1 on kriscendobot/minion.town PR #120 came back **must-fix**. `panel.sh` exited 0 in single-round mode; all 33 seats ran `ok`. I made no fixes and the PR is still a draft.

**How it ran:** in an isolated checkout of head `claude-agents-delegate` @ `ed25945`, against base `main-c815041` (`c8150415`). The run is recorded at `panel-runs/kriscendobot-minion.town-120/c7a3f68fe009.md`.

**Why must-fix:** the phase/evidence pre-pass came back BLOCKED, which sets the result to must-fix on its own. The PR body has no Phase/Disposition/Design ledger for `designs/claude-agents-capability.md` (phases 1–6 and the acceptance evidence are missing), and it names an unlanded prerequisite (endojs/endo-but-for-bots#1015). Several seats also found real defects:
- **`create`/`dismiss` race:** a `dismiss` on the same key can free the quota slot while `create` is still running, so a live child gets past the quota caps.
- **Fault rollback:** when provisioning fails, the quota slot is freed but the directory child is left behind.
- **Restart teardown:** after a restart, teardown doesn't reach grandchildren, so their guest formulas are orphaned.
- **Boundary objects:** the objects handed to other guests are plain literals without `Far`/`harden`, so CapTP will reject them.
- **Names:** a caller-supplied name containing `::` can collide with another caller's quota key.
- **Style:** the new functions abbreviate `ctx` and `rec` instead of spelling them out.

**Posted:**
- The review is at https://github.com/kriscendobot/minion.town/pull/120#pullrequestreview-5346211657. It opens with a heading that states **disposition: must-fix** and lists what to fix, followed by the per-seat reports.
- GitHub refused a request-changes review because the bot also wrote the PR, so it went up as a COMMENTED review. If the next-stage check requires a request-changes review, it will need to read the must-fix heading instead.
- The per-seat reports that didn't fit GitHub's size limit are in a follow-up comment: https://github.com/kriscendobot/minion.town/pull/120#issuecomment-5881181904
- The first post was blocked by the gh wrapper's check for bare issue numbers. I rewrote `#1015` as endojs/endo-but-for-bots#1015 and `#97` as kriscendobot/minion.town#97, then posted.

**One seat was wrong:** the archivist flagged `deployment.quotaFor()` as undefined, but it is declared at `src/endo/claude/wiring.ts:238` and implemented at `:347`. The review says to disregard that item.

**Next:** the fix loop should add the ledger and fix the listed defects. The PR should stay a draft until steps 1 and 3–6 of the design's production sequence have landed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1072963 cached reads)
- Output: 6968 tokens
- Cost: $0.9148246
- Wall-clock: 617s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
