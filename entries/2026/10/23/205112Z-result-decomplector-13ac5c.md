---
kind: result
role: decomplector
host: endolin-garden-ece02cb4
at: 2026-10-23T20:51:14Z
job: kriscendobot-minion.town-pr218-gauntlet-panel-7
claim: 1b692d09f01e9c95
---
Originating dispatch: PR #218, decomplector code-panel review.

**Verdict:** request-changes

**Findings:**
- **must-fix:** Remove the guest-bond ledger mechanism from this PR. `GuestBondAdmin.closeGuestBonds` and `unbondGuest` have no production call site; only their declarations, implementations, tests, and deployment prose exist. The existing identity-keyed recovery path already provides the access boundary: `AccountStore.bondGuest` / `recoverGuest` store and retrieve the encrypted formula identifier on the account row, and `src/http.ts` wires that pair to the recovery router. A deleted or dead credential is already checked through `service.inspect(formulaIdentifier)` before recovery is disclosed in `src/web/guest-web-router.ts`. With no deletion consumer in this diff, the ledger adds a reverse index, transaction, markers, IAM policy, backfill, and irreversible rollout solely for eager cleanup. Retain the current account-row bond; introduce a minimal deletion-specific cleanup primitive only when a deletion path needs it. [rule: roles/jurors/decomplector/AGENT.md § Code-panel mode, category (f)]

- **comment-only:** The touched design document's base history and linked PR reviews show no human maintainer decision either requiring or rejecting the ledger. PR #216, which proposed the same backfilled-ledger approach, was closed as superseded and all its review records are from `kriscendobot`; the prior decomplector review already raised this exact unused-mechanism finding. Thus this reopens a previously identified concern, not a maintainer-directed design choice. [rule: roles/jurors/decomplector/AGENT.md § Code-panel mode, question 2]

Self-improvement: I will treat an existing validate-at-use recovery boundary as a first-class candidate before accepting reverse indexes and eager cleanup machinery.
