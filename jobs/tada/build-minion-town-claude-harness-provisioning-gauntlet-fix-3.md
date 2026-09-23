CI is GREEN (rc 0). The fix stage is complete.

## Round-3 FIX stage — kriscendobot/minion.town PR #99

Applied the panel-3 must-fix items (deduplicated across 30 seats) as follow-up commit `340a0e1`, pushed to the PR head via `safe-push-pr-head.sh`, posted the scribe-required round summary comment, and watched CI to **green** (all 3 legs: `test`, `Claude harness amd64`, `Claude harness arm64`).

**Deploy safety (`deploy-app.sh`):**
- Rollback no longer empties `/opt/minion-town` on a fresh box — the failed tree is moved aside only when a restorable `.old` exists; the swap-aside is now `if/then/fi` (no `&& … || true` swallowing a failed `mv`).
- Integrity-pinned binary + provenance files are chowned `root`, read-only to `minion-mcp` → self-modification denied by ownership, not just `DISABLE_UPDATES`.
- Receipt written **after** the restart gate, recording the observed `promoted`/`rolled-back`/`failed`; dropped the duplicate `rollbackArtifactSha256`.
- Truncated/malformed predecessor files degrade to `unknown` (shape-gated) instead of aborting under `set -e`; `GITHUB_SERVER_URL` defaulted under `set -u`.
- Reproducible tarball (`--sort`, zeroed mtime/owner, `gzip -n`) so the content-addressed S3 key is stable.

**Verifier (`lib.mjs` → `release-verifier.mjs`):**
- zstd Node-version guard made reachable (namespace `import * as zlib` — the named import SyntaxErrored at link time).
- `buildTime` round-trips through `Date`, rejecting in-grammar overflow (`2026-02-30`).
- `signingKeyFingerprint` and `requiredHelpFlags` single-sourced from the module (both shells + `refresh.mjs` + tests now import rather than re-type).
- `parseArguments` on a null-proto object + duplicate-flag rejection; dead pin assertion reordered; minimal probe env; `fileURLToPath` for the gpg import.

**Tests:** byte-count-mismatch + `DISABLE_UPDATES` cases (both **mutation-verified** load-bearing: deleting either guard reddens the suite), calendar-overflow rejection, hostile/duplicate-flag coverage; shipped `hashFile` exercised; invented lint directive replaced with prose. 30/30 `node --test`, `claude-harness:check`, `typecheck`, 336 vitest all green locally.

**Config/docs:** root `engines` reverted to `>=20.12` (zstd bump is harness-only); premature `claude` PATH grant removed from `minion-mcp.service` (provisioning-only); README/DEPLOYMENT.md/design updated.

**Deferred (noted on PR, out of scope for an append-only fix push):** packager's `c5a3c14`/`507e951` bisect-ordering (a history rewrite/retcon, not a follow-up commit; current HEAD is green); integrator's node:test→vitest (deliberately kept `node:test` — it's a zero-dependency bootstrap verifier).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-harness-provisioning-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 190 tokens (13337627 cached reads)
- Output: 75647 tokens
- Cost: $10.404048499999998
- Wall-clock: 1181s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
