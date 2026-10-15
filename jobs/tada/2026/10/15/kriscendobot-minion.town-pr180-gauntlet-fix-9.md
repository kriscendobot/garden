# Gauntlet fix round 9: kriscendobot/minion.town PR #180

I fixed the one must-fix item from the round-9 panel, pushed it, and CI came back green.

**The must-fix item (archivist seat).** `designs/git-remote-capability-increment-1.md` said that rotating the root secret "invalidates every held partition." That contradicted `DEPLOYMENT.md` and `control.ts`, which both say partitions are re-bound with `E(git).open(<partitionId>)`.

**The fix.** I reworded that passage in the design doc to match the code:
- **Invalidated by rotation:** previously issued facet keys and owner credentials, because both are HMACs of the secret. Partition handles bound before the rotation therefore stop working.
- **Kept through rotation:** the partition, its contents, and URLs already minted for it. Minted URLs are random tokens kept in the partition store and are not derived from the secret.
- **Recovery:** the guest re-binds with `E(git).open(<partitionId>)`, which returns facet keys under the current secret.

The archivist also wrote that rotation invalidates minted URLs. The code shows that is wrong, so I did not put that claim in the doc.

**Push and CI.**
- Commit `f0d03b4` (`docs(git-remote): say secret rotation invalidates facet keys, not partitions`) was pushed with `safe-push-pr-head.sh`, advancing the head from `d38139c` to `f0d03b4`.
- `ci-wait-merge.sh --no-merge` returned rc 0: 1 of 1 Actions runs finished with 0 failures. The bot token can't read the full check rollup, so it fell back to the Actions runs API, which doesn't show commit statuses or check runs from outside Actions.

**Follow-ups.** No other seat marked anything must-fix. The should-fix items are still open for a later round if wanted:
- `control.ts` returns 400 for every failure; operational faults should get 5xx.
- `open` gives back the readwrite key to anyone holding the `git` power. Either document that sharing `git` grants every partition its owner made, or change `open`.
- Facet keys can't be revoked except by rotating the secret.
- `owner as string` casts in `guest-control.ts`.
- A test checking that `OWNER_HEADER` and `CONTROL_OWNER_HEADER` stay equal.
- A note in the PR or runbook on the tightened `GIT_REMOTE_PORT` parsing.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (728181 cached reads)
- Output: 3818 tokens
- Cost: $0.6320041999999999
- Wall-clock: 1049s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
