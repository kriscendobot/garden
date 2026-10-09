# Gauntlet fix round 1: kriscendobot/minion.town PR #174

I applied all of the panel's must-fix items in one commit, `4c257ff`, pushed to `build/credit-metering-no-ertp` with `safe-push-pr-head.sh` (`43177f6` → `4c257ff`). CI is green: all 3 checks passed, and `ci-wait-merge.sh --no-merge` returned rc 0.

**Must-fix items applied:**
- **A bad or torn ledger file (assessor, saboteur, corner-prober):**
  - A failed load used to be an unhandled rejection. Now every ledger operation fails with "credit ledger failed to load", and the gateway logs the failure at boot through a new `ledger.ready()`.
  - I also found and fixed a related bug: after the first failed call, `serialize` reset its chain, so the second call ran against an empty ledger. It now waits for the load before every operation.
  - A torn final line from a crash mid-write is dropped and cut from the file. A complete last line with no newline gets one added. Any other unreadable line fails with its `ledger.jsonl:<line>` location.
- **Charging before the content is stored (saboteur, wire-watcher):** a charge now returns a settlement that the publisher refunds if storing the content fails. The new `refund` record frees the id, so a retry pays again. A replayed charge returns no settlement, so it is never refunded.
- **Replayed id at a different price (wire-watcher):** reusing a settlement id with a different amount now throws instead of quietly keeping the earlier price.
- **Names (stylist):** in the CLI, `iss`/`sub` are now `issuer`/`subject`, and the ledger's `all` is now `allRecords`. The CLI's entry check also accepts a compiled `.js` file.
- **Docs (integrator):**
  - `CLIP_METERING` and `CREDIT_LEDGER_DIR` are added to `.env.example`.
  - The publish paragraph in `DEPLOYMENT.md` now covers the rollout order (grant credits, enable, restart), restarting after a grant, the one-writer-per-ledger rule, and the corrupt-file behavior.
  - The `minion-mcp` systemd unit has a commented-out `CLIP_METERING=1` line.
  - A new `npm run credits` script runs the operator CLI.
- **PR body (pruner):** I replaced the per-file "What changed" list with a short summary of behavior, cut the "Tests" list down to the note about the one existing failure, and added the one-writer limit to the known limitations.

**New tests:** a torn final line, a corrupt line in the middle (checking that grant and charge both fail closed), a replayed id at a different amount, and a refund when storing fails followed by a paid retry. I also updated the facet test, since the facet now has `refund`. `tsc` is clean. The full suite has one failure, `test/git-remote/capability.test.ts`, which also fails on `main` without this PR.

**Should-fix items left for later:**
- `InsufficientCreditsError` is not yet turned into a user-facing error at the publish or tool boundary.
- A grant made while the gateway runs still isn't seen until restart. This is documented, not enforced.
- The integrator's suggested cross-references in `designs/ertp-credits.md` § 6a and § 7.
- The stylist's naming suggestions (`postRecord`, `SettlementResult`, `measurementId`).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1872294 cached reads)
- Output: 17087 tokens
- Cost: $1.4029588
- Wall-clock: 1211s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
