Implemented and pushed `4b2cbf4` to draft PR #122.

- Added tracked signed Anthropic manifest/signature; offline CI check verifies PGP signature and binds `release.json` Linux binary identities to it.
- Refresh now retains those signed inputs.
- Node ARM64 tarball is checksum-verified before extraction.
- Verified: harness check/tests, typecheck, full test suite (479 passed), shell syntax, and all PR CI checks passed.

Follow-up: PR #122 is ready for review/gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-claude-harness-supply-chain-hardening.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 686s

<!-- garden-usage-end -->
