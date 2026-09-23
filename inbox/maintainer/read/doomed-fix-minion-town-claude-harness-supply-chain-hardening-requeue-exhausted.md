from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-18T08:23:21Z
doom_base: fix-minion-town-claude-harness-supply-chain-hardening
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-18T08:23:21Z
last_seen: 2026-09-18T08:23:21Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-minion-town-claude-harness-supply-chain-hardening; it stays HELD until a human promotes it
(promote-plan.sh fix-minion-town-claude-harness-supply-chain-hardening) or removes it, so nothing is lost.
Original job base: fix-minion-town-claude-harness-supply-chain-hardening

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Repo kriscendobot/minion.town. Low-severity supply-chain hardening surfaced by the security review of the tools/claude-harness feature (range e7b3b5a..45e43bb, landed via PR #99). No High/Critical vulnerabilities were found; these are defense-in-depth improvements. Two items:

1. **Re-verifiable signature binding for release.json (harness).** install.mjs (and the Dockerfile/deploy-app.sh install path) trust the git-tracked tools/claude-harness/release.json entirely — checksums/version only. The Anthropic PGP signature is verified ONLY at manual refresh.mjs time, and the signed upstream manifest+sig are discarded (written to a tmpdir, never committed). check.mjs / CI only assert the version pins agree across package.json, package-lock.json, and release.json; they do NOT re-verify release.json's checksums against a signed manifest. Consequence: anyone who lands a release.json edit (repo write + review bypass) can point the installer at an OLDER, genuinely-Anthropic-signed version's real checksums (a downgrade/substitution) and install.mjs installs it with no freshness or signature check. Fix direction: retain the signed manifest.json + manifest.json.sig in-repo and re-verify release.json against them in check.mjs and CI (offline gpg verify against the tracked claude-code.asc), so a release.json that diverged from a signed manifest reddens CI. This closes the signature→release.json trust gap without changing the install-time (network-free) model.

2. **Verify the Node.js runtime tarball (pre-existing, adjacent).** deploy/aws/scripts/deploy-app.sh step 4a downloads the Node 22 arm64 tarball and extracts it as root (sudo tar -C /usr/local) WITHOUT any integrity check: SHASUMS256.txt is fetched only to resolve the filename, never to verify node.tar.xz. The carefully-verified claude binary then runs on an unverified Node runtime, undermining the end-to-end supply-chain story the harness feature invests in. Not introduced by this feature, but in the same trust chain. Fix: verify node.tar.xz against the fetched SHASUMS256.txt (e.g. grep the expected line and `sha256sum -c`) before extraction. (Node.js publishes GPG-signed SHASUMS256.txt.asc for a stronger check if desired.)

Positive confirmations (do not need changes): verification mismatches ABORT (assert-based, CLI sets exitCode=1, output binary renamed only on the all-pass path — well tested in install.test.mjs); minion-mcp.service is well-hardened (loopback-only HOST=127.0.0.1 behind Caddy, non-root minion-mcp user, NoNewPrivileges/ProtectSystem=strict/ProtectHome/PrivateTmp/ReadOnlyPaths, no ANTHROPIC_*/CLAUDE_CODE_OAUTH_TOKEN in env, claude binary off-PATH and not spawned, secrets via 0600-root EnvironmentFiles); deploy-app.sh's new verification (artifact sha256sum -c, on-box `env -i` minimal-env claude --version/--help smoke as minion-mcp, root-owned read-only binary, atomic guarded promote/rollback) is sound.
