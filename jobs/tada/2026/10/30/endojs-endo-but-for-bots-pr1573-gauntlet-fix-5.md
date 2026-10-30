**PR #1573, gauntlet fix round 5: done, CI green**

I applied the round-5 panel review (5712372458) to endojs/endo-but-for-bots#1573 and pushed two follow-up commits with `safe-push-pr-head`, moving the head from `ecfbdb2ac9` to `10519bbc8f`.

**What changed**
- **`ac908cf448` (daemon fix + test):**
  - **Orphaned bytes (saboteur 1):** revoking a `provisioning` secret whose backend `recover` failed left the record with no backend reference, and delete then skipped cleanup, leaving the encrypted file on disk. Delete now recovers the reference first, the same way revoke does.
  - **New test (saboteur 2):** it injects a failing `recover` during revoke, then calls delete, and checks that the bytes are gone.
  - **Masked error (saboteur 3):** in `writeSecretRecordWithGrant`, the rollback now has its own guard, so if the rollback itself fails the caller still sees the original error.
- **`10519bbc8f` (changeset):** rewrote it for upgrading users (releaser 1–2, pruner 2, locksmith 2):
  - "New:" line for `provideBase64`.
  - "Migration:" line for the new `SecretState` value.
  - Separate "Behavior change:" line for the backend's replay behavior.
  - A statement that stable IDs must be unguessable.
  - Internals removed.
- **PR body:**
  - **Pruner 1:** removed the duplicated testing text. I kept the one-row-per-phase ledger because `phase-evidence-gate.sh` reads one row per phase, so collapsing it would break the gate.
  - **Decomplector 1:** added a paragraph explaining why `createBase64` plus a name check isn't enough.
- **Scribe:** posted a summary comment that maps every earlier-round finding to the commit that addressed it, lists what was declined and why, and gives CI status and gauntlet state: https://github.com/endojs/endo-but-for-bots/pull/1573#issuecomment-6524584075

**Declined, with reasons given on the PR**
- **Changeset for `@endo/hosted-agent`** (changeset-auditor 1, releaser 4): the package is `"private": true` and no other changeset names it.
- **Structural should-fix items** (decomplector 2–4, locksmith 1 and 3): a separate `operationId` ledger, splitting the registry journal, required recovery methods, capability-keyed `grant`, and narrower module powers. These reshape a reviewed design, so I left them for the maintainer to decide.

**Verification**
- The daemon `secret-manager` suite passes locally (29 tests). eslint reports no errors.
- The first `ci-wait-merge` run (3600s deadline) returned rc 4 with two macOS/ubuntu test jobs still running. I waited longer, and a second `ci-wait-merge` returned rc 0: 36 checks, 0 failed (26 pass, 10 skipped).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2119488 cached reads)
- Output: 11803 tokens
- Cost: $1.2853016000000002
- Wall-clock: 4414s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
