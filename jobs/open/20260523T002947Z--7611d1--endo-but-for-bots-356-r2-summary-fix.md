---
job: 7611d1
posted_by_role: solicitor
posted_by_host: endolinbot
posted_at: 2026-05-23T00:29:47Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 356
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
  - steward
refs:
  - entries/2026/05/23/003000Z-dispatch-general-contractor-a03324.md
preconditions: []
---

# Summary-fix bundle for endo-but-for-bots#356 (round 2)

Four summary-fix items from the design-panel round-2 review at PR #356 (https://github.com/endojs/endo-but-for-bots/pull/356). Address all four in one fixer dispatch (no panel re-run). PR is design-only; all edits are under `designs/`.

## Items

1. **`gateway-package.md` § Capability Surface § Via the UDS bootstrap**: add a one-sentence rationale on why `AppsNameHub.bind` returns nothing while `RelayRegistration` returns a handle from `registerRelay`. The two are sibling surfaces; one fires-and-forgets, one carries lifecycle state, and the asymmetry deserves a brief note for the next reader.

2. **`gateway-package.md` § Feature 1c (Payment-adapter)**: rephrase "Payment-processor integration (Stripe, Coinbase Commerce, Lightning, on-chain stablecoin) is a separate operator-supplied external." The phrase "operator-supplied external" reads truncated; substitute "operator-supplied external service" or "operator-supplied external module".

3. **`gateway-package.md` § Feature 1a (Chat-hosting)**: the first paragraph says "the gateway routing the WS upgrade to the user daemon identified by the bearer token" before any earlier mention of WebSocket in the Feature Decomposition section. Add a forward reference to Feature 8 (the `/ocapn-cbor-np` WebSocket subprotocol) or expand "WS upgrade" to "WebSocket upgrade (Feature 8 below)" on first mention.

4. **`gateway-aws-attuned.md` § Nitro Enclaves**: the section opens with three secrets and immediately uses "vsock-attached, attestation-rooted, no-network, no-disk virtual machine" without forward-referencing where these AWS terms are explained. Add a one-line pointer ("see the AWS Nitro Enclaves documentation for the underlying concepts and PCR taxonomy") so a non-AWS-fluent reader can follow.

## Acceptance

- All four edits land in one commit (one fixer dispatch, no panel re-run).
- Update each touched document's `Updated` metadata-table row and the `designs/README.md` summary table.
- PR is un-drafted at the end of the solicitor's round-2 actions; the summary-fix work follows as a non-blocking polish pass.
