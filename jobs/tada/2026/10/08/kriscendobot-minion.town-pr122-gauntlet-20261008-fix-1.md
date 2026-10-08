I fixed the one blocking item from the round-1 panel review of kriscendobot/minion.town PR #122 and pushed it; CI is green (3 of 3 checks passed).

**What the panel asked for.** The latest review (request changes, 33 seats, head `8f60883`) had one must-fix: in `deploy/aws/scripts/deploy-app.sh`, `NODE_SHA256` came straight from the downloaded `SHASUMS256.txt`. It was inserted into the remote install script without any format check, and that script runs with `sudo` on the instance.

**What I changed.** Two follow-up commits on `fix-minion-town-claude-harness-supply-chain-hardening`, pushed with `safe-push-pr-head.sh` (`8f60883` → `2fde356`):
- `fc845f4` fix(deploy): `NODE_SHA256` must now match `^[0-9a-f]{64}$` before use, or the deploy stops with an error. This mirrors the existing `CLAUDE_VERSION` check. `bash -n` passes on the edited script.
- `2fde356` docs(claude-harness): one should-fix that was cheap to clear. The comment in `tools/claude-harness/refresh.mjs` claimed that an older signed release could not be substituted. Nothing checks version order, so the comment now says only what the signature guarantees and that version order isn't checked.

**Should-fix items I left for later rounds or the maintainer:**
- Deploy never checks the release signature: `deploy.yml` doesn't depend on `claude-harness:check`.
- The gpg verification is duplicated between `check.mjs` and `refresh.mjs`, and the two copies have drifted. They should move into `release-verifier.mjs`.
- No tests cover signature failures: a flipped byte, the wrong key, or an empty or missing `.sig`. The fixtures also use the same checksum for both platforms, so an architecture swap goes undetected.
- Commit cleanup: squash `098d41a` into the Claude-pin commit and put the generated manifest files in a separate commit. That needs a history rewrite, which a follow-up fix round shouldn't do.

The comment-only findings are also unaddressed: expired-key and subkey handling, the unsigned Node SHASUMS file, gpg not being documented as a prerequisite, and a duplicate import in `check.mjs`.

The PR is still a draft; the driver re-runs the panel next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (613565 cached reads)
- Output: 3815 tokens
- Cost: $0.583357
- Wall-clock: 294s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
