The fix job posted. The security review is complete.

## Security review: `tools/claude-harness` (minion.town `e7b3b5a..45e43bb`, landed via PR #99)

Reviewed the installer's verification logic and failure modes, the release.json/signature trust model, the new `minion-mcp.service` exposure surface, and deploy-app.sh's new verification step. **No High/Critical vulnerabilities.** The feature is carefully engineered (assert-based abort, minimal exec env, ownership-enforced read-only, loopback binding, non-root user, thorough tests + CI). Two low-severity hardening findings, both routed to a posted fix job.

**Findings (Low / defense-in-depth):**

1. **Signature→release.json binding is not re-verifiable at install time.** `install.mjs`, the Dockerfile, and deploy-app.sh trust the git-tracked `release.json` (checksums/version only). The Anthropic PGP signature is checked *only* at manual `refresh.mjs` time, and the signed upstream manifest+sig are discarded (tmpdir, never committed). `check.mjs`/CI only assert version pins agree across package.json/lock/release.json — they do **not** re-verify checksums against a signed manifest. So a `release.json` edit (repo write + review bypass) could point the installer at an older, genuinely-Anthropic-signed version's real checksums (a **downgrade/substitution**) and it would install with no freshness/signature gate. Compensating control: git is the trust root and PR review is required; a tampered-but-unserved checksum fails closed. Fix: retain the signed manifest + `.sig` in-repo and re-verify `release.json` against them in `check.mjs`/CI.

2. **Node.js runtime tarball extracted as root without integrity check (pre-existing, adjacent).** deploy-app.sh step 4a fetches `SHASUMS256.txt` only to resolve the filename, never to verify `node.tar.xz` before `sudo tar -C /usr/local`. The verified `claude` binary then runs on an unverified Node. Not introduced by this feature, but in the same trust chain. Fix: `sha256sum -c` against the fetched SHASUMS.

**Answers to the job's explicit questions:**
- **Verification mismatch → aborts, never silently proceeds.** All checks are `assert`; failure throws, the CLI sets `exitCode=1`, and the output binary is renamed into place only on the all-pass path (verified by `install.test.mjs`: compressed/binary checksum + byte-count + version + flag-contract rejections).
- **release.json tamperable independently of signature check?** Yes — that is the confirmed basis of finding #1 (install trusts git, not the signature).
- **`minion-mcp.service` exposure:** well-hardened; the feature only added `DISABLE_UPDATES=1` + doc comments, no new exposure. Loopback-only behind Caddy, non-root dedicated user, `NoNewPrivileges`/`ProtectSystem=strict`/`ProtectHome`/`PrivateTmp`/`ReadOnlyPaths`, no Anthropic/Claude credentials in env, binary off-PATH and not spawned, secrets via `0600` root EnvironmentFiles.
- **deploy-app.sh verification step:** sound — artifact `sha256sum -c`, `env -i` minimal-env on-box smoke as `minion-mcp`, root-owned read-only binary (no self-rewrite), atomic guarded promote/rollback.

**Follow-up:** posted fix job `fix-minion-town-claude-harness-supply-chain-hardening` covering both findings with fix directions and the positive confirmations. No completion report existed in the journal and no prior PR/branch work was found, so this was a clean re-derivation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-claude-harness-45e43bb-security-review.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 34 tokens (1004179 cached reads)
- Output: 15407 tokens
- Cost: $1.6787525 (1 engagement(s) unpriced)
- Wall-clock: 274s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
