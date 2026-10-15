**Gauntlet FIX round 11: kriscendobot/minion.town PR #180**

I fixed the panel's one must-fix item and pushed it to the PR head. CI is green: `ci-wait-merge.sh --no-merge` returned rc 0, with 1 of 1 Actions runs passing and 0 failed.

**What I did**
- **The must-fix (archivist):** the paragraph in `DEPLOYMENT.md` on rotating the control secret contradicted `src/endo/git-remote/control.ts` and the design doc. It claimed partitions a guest had bound before a rotation "stop working," and told operators to rebind them with a one-argument `E(git).open(<partitionId>)`, which is missing the required retention key. I rewrote it to match the code and the design:
  - Rotation invalidates owner credentials and facet keys, but no retained partition is lost.
  - A retained handle is `E(git).open(<partitionId>, <retentionKey>)`. It keeps working because `open` checks only the stored retention key and needs no owner credential.
  - The old caplet can no longer `create`, and a guest's `git` is rebound to the current caplet the next time its facet is resolved.
- I committed it as `2d14e79 docs(git-remote): rotation strands no retained partition` and pushed it to `kriscendobot/minion.town:design/git-remote-endo-binding` with `safe-push-pr-head.sh` (advance mode, `1a8c9c6 → 2d14e79`).

**Follow-ups (should-fix items I did not apply)**
This stage applies must-fix items only, so the panel's should-fix items are still open for a later round or a separate job:
- **Rescan guard:** every `mint`/`revoke` sidecar write moves the `root` directory's modification time. That defeats the guard meant to stop repeated full rescans when a guest at its partition cap keeps calling `create`. The breaker suggests rate-limiting rescans or keeping the counts incrementally.
- **Leaked partition slots:** `guest-control.ts` `create` counts the new partition against the guest's lifetime cap of 256 before binding its pet name. If both bind attempts fail, the slot is lost for good. Both the breaker and the assessor flagged this.
- **Concurrent provisioning:** two first-time `provideGuest` calls for the same guest can both call `makeUnconfined` with the same name. Nothing tests or handles this.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (821017 cached reads)
- Output: 5050 tokens
- Cost: $0.6900354
- Wall-clock: 1326s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
