Viability check for kriscendobot/minion.town PR #122, "fix(security): bind Claude pin to signed manifest". The result is **proceed**: the PR has not been superseded and its reason still holds.

**PR facts:** The PR is OPEN and still a draft, and it has not been merged. Head `fix-minion-town-claude-harness-supply-chain-hardening` at `4b2cbf4be2`. Base is the frozen `main-561472a`; `main` is now 199 commits ahead of it. There are no reviews or comments. It was opened 2026-09-27 by the garden job `fix-minion-town-claude-harness-supply-chain-hardening`.

Deciding question: Does current `main` still lack the two protections this PR adds — (a) checking Anthropic's signed release manifest and its detached signature offline in the harness CI check, and (b) checking the Node 22 ARM64 tarball's checksum before deploy extracts it as root?

Evidence:
- **(a) Signed manifest is still missing on main.** `tools/claude-harness/` on `main` has no `manifest.json` or `manifest.json.sig`. `main`'s `check.mjs` imports only `checkPinConsistency, parseJson` and has no signature or manifest check. `main` does have `release-verifier.mjs` and `claude-code.asc`, but those were already there at the PR's base (the PR builds on them). The harness commits since then (`578381f9`, `6e2afca8`, `65c7654e`, and dependabot PRs #103 and #158) only refresh or bump the pin to 2.1.283. None of them adds signed-manifest checking.
- **(b) Node checksum is still missing on main.** `deploy/aws/scripts/deploy-app.sh` on `main` (lines 83–86) reads `SHASUMS256.txt` only to find the tarball's file name. It never checks the tarball's hash against that list. The later `deploy-app.sh` commits (`b93d8452` … `02ddb6d9`) cover Claude production wiring and Caddy, not the Node checksum.
- **Nothing replaces it.** Searching the repo's PRs for "harness signed manifest" and "supply-chain" finds only #122 itself and unrelated or already-merged harness PRs.
- **The reason for it is stronger now.** Since this PR was opened, the Claude CLI provider has been turned on in production (merged #148/#150, `1537793f`, `a7a3f4b1`). Supply-chain checking of that binary now matters more than it did.

Things the fix loop will run into:
- **Stale pin:** the PR's `manifest.json` and signature were captured against an older pin. `main`'s `release.json` is now at Claude Code 2.1.283, so the branch needs a weave onto current `main` and a manifest refresh.
- **Possible clash with open migration PRs:** #151, #152 and #154 (moving scripts and deploy to JavaScript only) may touch `deploy-app.sh` and `refresh.mjs`. That is a risk for the rebase, not a replacement for this PR.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (220380 cached reads)
- Output: 2792 tokens
- Cost: $0.46102
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
