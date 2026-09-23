All four panel-1 must-fix items are applied, pushed as a follow-up commit, and CI is green.

## Completion report

**Job:** FIX round 1 of the `build-minion-town-claude-harness-provisioning` gauntlet — kriscendobot/minion.town PR #99 (`build/claude-harness-provisioning`).

Applied the panel-1 must-fix items once, in a single follow-up commit `a15a117`:

1. **assessor** (`deploy/aws/scripts/deploy-app.sh`) — Folded the post-promotion `claude --version` re-check into the guarded restart/`is-active`/healthz `&&` chain, so under `set -e` a broken `claude` now routes to the `else` rollback branch instead of killing the script and leaving a broken deploy live. Made the informational `systemctl status` line `|| true` so it can't defeat the rollback either.

2. **transplanter + wire-watcher** (`tools/claude-harness/claude-code.asc`, README) — Stripped the two leaked interactive-shell diagnostic lines and **re-exported the key verbatim from the documented provenance channel** `https://downloads.claude.ai/keys/claude-code.asc`. Verified the freshly-downloaded canonical key is byte-identical to the committed body and its gpg fingerprint is exactly the pinned `31DD DE24 … 1A7E CACE` with the genuine `security@anthropic.com` UID. README now records the source URL, the setup-guide citation, and the out-of-band `gpg --fingerprint` confirmation + rotation procedure.

3. **engine-realist** (`package.json` ×2, `install.mjs`, `refresh.mjs`) — Declared `engines.node >=22.15.0` in `tools/claude-harness/package.json` (zstd floor) and reconciled the stale root floor (`>=20.12` → `>=22.15.0`, matching the app's actual `node:22-slim` deploy everywhere). Added a `typeof createZstdDecompress === 'function'` assertion at the top of both zstd-using scripts so an older runtime fails with a clear message rather than a bare TypeError.

**Verification:** harness suite 21/21 pass, `claude-harness:check` green, `bash -n` on deploy-app.sh clean, both package.json parse, all `.mjs` `node --check` clean.

**CI:** watched to terminal — 3/3 checks GREEN (rc 0).

Did not re-run the panel (the driver re-posts panel-2). The remaining panel verdicts (stylist, breaker, purist, corner-prober request-changes) were should-fix/comment-only, not in the must-fix summary, so per the stage instructions they were left for a later round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-harness-provisioning-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3091393 cached reads)
- Output: 17792 tokens
- Cost: $2.9930695
- Wall-clock: 554s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
