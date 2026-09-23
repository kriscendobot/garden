---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 361
created_at: 2026-05-23T06:33:43Z
last_appended_at: 2026-05-23T06:33:43Z
status: actioned
actioned_at: 2026-05-29T01:47:43Z
merge_event: 2026-05-25T19:41:18Z
actioned_via: jobs/open/20260529T014743Z--88f3bc--action-followups-361.md
---

# Follow-ups for endojs/endo-but-for-bots#361

Created from the twelve-seat code panel first-round verdict (in-band fallback) on the netlayer-tcp-syrup test port. The PR is a single-file test-only restoration (+63 / -34 in `packages/ocapn/test/netlayer-tcp-syrup.test.js`) after upstream merge `bdb9ddc50` left the file importing the pre-#59 `makeClient`. Four follow-ups warrant revisit at merge time, all on property-testing or coverage-augmentation that is out of scope for the restoration.

## Items

- [ ] **Add a property-based round-trip test for syrup framing values.**
  **Source juror(s)**: fast-checker.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding `fc.assert(fc.property(fc.string(), s => /* round-trip via E(echoRef).echo(s) and t.is(result, s) */))` to `packages/ocapn/test/netlayer-tcp-syrup.test.js` (or to a peer file dedicated to property tests). The current restoration pins one input (`'hello syrup'`); the contract is universally quantified over all values representable in the codec's domain. `fast-check` is already a devDependency in several packages in the workspace.

- [ ] **Add a property-based wire-format test for the syrup sniffer.**
  **Source juror(s)**: fast-checker.
  **Round**: 1.
  **Recommended action**: generalize the first test's assertions (`<digits>:<payload>` prefix shape; no `,` at netstring-terminator position) over `fc.uint8Array()` payloads via the sniffer. The current restoration pins one handshake-shaped payload; the wire-format invariants are universally quantified over payload bytes. Land alongside the round-trip property test above.

- [ ] **Add a property-based framing-option-rejection test.**
  **Source juror(s)**: fast-checker.
  **Round**: 1.
  **Recommended action**: generalize the third test's `'bogus'` example via `fc.string().filter(s => !KNOWN.has(s))` where `KNOWN` is the documented framing-option set. The current restoration pins one example; the rejection contract is universally quantified over the complement.

- [ ] **Parametrize a codec-network mismatch test across the project's codecs.**
  **Source juror(s)**: corner-prober.
  **Round**: 1.
  **Recommended action**: add a test case for the codec-network mismatch path at `packages/ocapn/src/client/index.js:651-657` ("network.codec does not match codec"), parametrized across the two codecs the project ships. Out of scope for the netlayer-tcp-syrup restoration; the appropriate home is a `makeOcapn` lifecycle test file rather than a netlayer-specific file.
