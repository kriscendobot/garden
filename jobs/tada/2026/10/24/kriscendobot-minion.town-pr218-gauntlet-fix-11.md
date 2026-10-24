I applied panel-11's must-fix items to PR #218 (kriscendobot/minion.town) as three follow-up commits, `036a8477..6ee426b9`, pushed with `safe-push-pr-head.sh`. CI is green: `ci-wait-merge.sh` returned rc 0 with 4/4 checks passing. No pre-pass block came with the job, so I worked from the latest panel review (5636686013).

**What I fixed**
- **Key version is now written atomically (wire-watcher).** `bondGuest` records the recovery key version inside the bond transaction, so a bond that fails leaves no version behind to break a later key rotation. The backfill script does the same.
- **Rebinding no longer piles up ledger rows (breaker).** A rebind deletes the old bond row in the same transaction, conditioned on the account still holding that bond, and retries if a concurrent rebind gets in between. `unbondGuest` now deletes the bond row along with the bond. Each identity keeps at most one bond row.
- **The close no longer holds every row in memory (engine-realist).** `closeGuestBonds` reads the ledger one page at a time in two passes: check every row, then unbond. It still makes no change if any row is malformed.
- **Markers must actually be markers (wire-watcher).** Both `closeGuestBonds` and the deploy preflight now check the marker's row kind instead of accepting any row at that key.
- **Backfill validates its input (saboteur).** The script checks that each scanned row's identity, sub, fingerprint and key-version fields are non-empty strings. On a bad row it stops before any write or marker.
- **macOS Bash 3.2 (transplanter).** The Bash 4 associative array is gone, and a test now fails if any Bash 4 feature comes back.
- **Separate in-memory objects (purist #2).** The in-memory backend now returns two separate objects, so the account-store side carries no admin methods at run time.
- **Docs and comments (archivist, pruner):**
  - The design now says the app's unrestricted `PutItem` can write any stored role or status, and that it's role resolution, not IAM, that limits the effect.
  - It also describes the new cost bounds and the atomic version write.
  - The `closeGuestBonds` docs no longer call closing "terminal".
  - I removed the "#220 follow-up" narration and the stale caller comment.
- **PR body (pruner, releaser, benchmarker).** I removed the caller tour and the #220 paragraph, and added an "Upgrading" note on the two-step migration (the repo has no changeset tooling). I also added a "Benchmarking: not pursued" rationale: the 60-second cache path is unchanged.

New tests cover each fix. Typecheck passes. The full local test run had one failure, in `test/git-remote/capability.test.ts`, a file this PR doesn't touch; CI's test job passed.

**Not applied**
- **decomplector (must-fix): remove the ledger entirely.** This would undo the PR's purpose, since it's the storage layer split out of #216 for #220. The design already explains why a secondary index won't do, and the PR stays draft until the maintainer confirms the wider IAM grant. Only the maintainer can settle this; until then, expect the panel to keep raising it in later rounds.
- **purist #1 (should-fix): use `@endo/sha256`.** That package isn't published, and the shell backfill has to compute matching hashes with `node:crypto`, so I left the file's exemption in place.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (5619919 cached reads)
- Output: 39688 tokens
- Cost: $3.1962638
- Wall-clock: 1499s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
