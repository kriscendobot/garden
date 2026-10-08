Clean stage report: kriscendobot/minion.town PR #169 (fix(deploy): preflight GUEST_RECOVERY_KEY before deploy-app restarts minion-mcp)

This stage was a no-op. I made no changes and pushed nothing.

- **PR state:** draft and open. The head is `d3f982ca22cb778c0d556029ab40781b7cd5e297` on `kriscendobot:fix/deploy-secret-preflight`.
- **Coverage:** already covered. The PR adds `test/deploy-secret-preflight.test.ts` (247 lines), which tests the new code in both scripts:
  - **`deploy-app.sh` preflight:** it checks that the script parses as bash. It covers a missing or unreadable file, a missing key, a key that is too short, and a later valid key line overriding an earlier short one. It also covers the passing case and checks that the secret value is never printed.
  - **Order in `deploy-app.sh`:** it checks that the preflight runs before any artifact promotion or restart.
  - **`deploy-account-endpoint-secret.sh` guard:** it checks that the script refuses keys that are too short or contain a space or quote. It also checks that a key the guard accepts would pass the `deploy-app.sh` preflight.
  - The other changes are only docs (`DEPLOYMENT.md`) and comments (the systemd unit).
- **Dead code:** none. The change only adds code and renames one comment, so nothing was orphaned.
- **CI:** `ci-wait-merge.sh kriscendobot/minion.town 169 --no-merge` returned rc 0, with 3 of 3 checks passing: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.

Follow-ups: none for this stage. The gauntlet moves on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-20261008-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (219834 cached reads)
- Output: 1805 tokens
- Cost: $0.4198028
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
