Fix round 5 for kriscendobot/minion.town#180 is done and CI is green on the PR head (`3caa0b3`). I didn't need to write anything new: a previous attempt at this job had already pushed fixes for every must-fix item. I checked those commits against the panel's round-5 review instead of applying them a second time.

**What the panel asked for**
The review covered head `e825132`. Two seats requested changes:
- **breaker** found two problems. The create key was described as an authority boundary, but a guest can call `E(git).create(<key>)` with a key it picked itself. And there was no limit on how many partitions one owner can create.
- **pruner** asked to cut implementation narrative from `DEPLOYMENT.md` and from deferred-work item 2 of the design doc.

**What is already on the PR head**
- `333330f` fixes breaker's two items and one of its smaller suggestions:
  - **Create key:** the comments in `control.ts`, `git-caplet.ts`, `partition-store.ts` and `guest-control.ts` now say only the MCP tool path mints the key, and that a guest can supply its own. The key reaches no other owner's partitions.
  - **Partition cap:** each owner can now create at most 256 named partitions (`DEFAULT_MAX_PARTITIONS_PER_OWNER`). The count is rebuilt when the index loads on restart, and re-creating a partition an operator deleted reuses its slot.
  - **NUL owners:** an owner header containing NUL is now rejected (breaker's comment-only item 3). NUL is the field separator in the key derivation.
  - Tests were added in `capability.test.ts` and `control.test.ts`.
- `3caa0b3` makes pruner's cuts. The control-plane paragraph in `DEPLOYMENT.md` is trimmed, the guest-provisioning walkthrough becomes a pointer to `src/endo/mcp-tool-names.ts`, and design-doc item 2 is shortened back to a brief status note.

**CI**
`ci-wait-merge.sh --no-merge` exited with rc 0 (green). The bot's token can't read the PR's full status-check list, so the script fell back to the Actions runs API. That shows one Actions run for `3caa0b3` with no failures; any commit statuses or non-Actions checks were not visible to it.

**Follow-ups:** none from this stage. The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (372979 cached reads)
- Output: 2505 tokens
- Cost: $0.5103918000000001
- Wall-clock: 375s

<!-- garden-usage-end -->
