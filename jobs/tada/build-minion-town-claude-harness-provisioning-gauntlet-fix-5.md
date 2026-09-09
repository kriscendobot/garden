CI is **green** (rc 0). All four must-fix items plus the folded-in comment-only cleanups are applied, pushed as a follow-up commit, and CI passed. Stopping here (fix stage does not re-run the panel).

## Completion report

Applied panel round-5 must-fix items to PR #99 (`kriscendobot/minion.town`, `feat(deploy): provision pinned Claude harness`) as a single review-feedback follow-up commit (`1b5507e`) on `build/claude-harness-provisioning`.

**Must-fix (all four):**
1. **Rollback-doc/code disagreement** — Rewrote `tools/claude-harness/README.md` Receipt+rollback paragraph. It now correctly states the *staged* pre-promotion smoke aborts under `set -e` with nothing restored and no receipt; the `.old` restore fires *only* on a post-promotion restart-smoke failure with a predecessor; and a first deploy with no predecessor leaves the tree in place. Matches the correct `DEPLOYMENT.md` account.
2. **Stop-gate honesty** — Reworded `designs/claude-agents-capability.md:3` to scope the claim to Step 1's *harness-pin sub-clause*, explicitly noting the rest of gate 1 (Endo substrate, subscription path, confinement probe, `infer`-exo recheck, `setup-token` confirmation, entitlement premise) has not shipped, so gate 1 is not cleared.
3. **Capability-denial invariant in the Docker image** — `Dockerfile`: moved the pinned `claude` off the default PATH to `/opt/minion-town/bin/claude` (matching the EC2 layout), made it root-owned `0555` / release manifest `0444`, and added `USER node` so the unprivileged runtime process cannot self-update it. Consistent with the EC2 posture where the server already runs unprivileged as `minion-mcp`. `inspect-image.sh` now asserts off-PATH (`! command -v claude`), non-root (`id -u != 0`), and not-writable, and smokes the binary by full path.
4. **Credential-env family gap** — Added `CLAUDE_CODE_OAUTH_TOKEN` to both the `test -z` probes and the `Config.Env` grep in `inspect-image.sh`.

**Folded-in comment-only:** retyped `≥`→`>=` and `…`→`...` (typist), renamed receipt field `precedingArtifactSha256`→`previousArtifactSha256` for vocabulary consistency (stylist), and reflowed a long `DEPLOYMENT.md` line (integrator).

Reverted an incidental `package-lock.json` engines-churn from the worktree warm-cache so the commit stays focused. `claude-harness:check` and all 30 harness unit tests pass. Docker isn't available in this container, so the image build/smoke is validated by CI, not locally.

**CI: GREEN** (3/3 checks, 0 failed) via bounded `ci-wait-merge.sh` (rc 0), no merge.

Follow-ups: none blocking. The Dockerfile `USER node` + off-PATH change is exercised by the `claude-harness-images` CI job (amd64+arm64), which passed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-harness-provisioning-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (3232443 cached reads)
- Output: 29393 tokens
- Cost: $3.1495375
- Wall-clock: 703s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
