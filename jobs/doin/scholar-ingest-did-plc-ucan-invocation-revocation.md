Scholar: continue issue #34 source ingestion after W3C DID Core 1.0.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-34
issue_url: https://github.com/kriscendobot/garden/issues/34#issuecomment-5100277860
submitter: kriskowal
----- END ISSUE NOTE -----

In priority order, ingest (idempotency check first):
1. did:plc method spec https://raw.githubusercontent.com/did-method-plc/did-method-plc/main/website/spec/v0.1/did-plc.md as a repo source, anchored to the file-specific commit; cover genesis-hash derivation, rotation-key ordering, 72-hour recovery window, and bounded PLC-directory trust.
2. UCAN Invocation (ucan-wg/invocation README) and UCAN Revocation (ucan-wg/revocation README) as repo sources, file-specific commits. Record that Invocation reads Version 1.0.0, Revocation self-describes v1.0.0-rc.1, and neither repository has tags/releases.
3. If the cycle budget permits, ingest the named deferred sections of the already-indexed UCAN and Delegation sources; otherwise post the next scholar job naming their remaining Lifecycle/Time/Token-Resolution/Nonce/Metadata/Implementation-Recommendations/FAQ/Related-Work, Policy, and Semantic Conditions sections.

Use scholar staging + lander, scoped integrity checks, and regenerators. When the full issue #34 sequence (including its successors) is complete, add one short comment to the issue naming the primary specs now durable in journal/library/sources; do not close the issue.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-29T17:30:56Z
