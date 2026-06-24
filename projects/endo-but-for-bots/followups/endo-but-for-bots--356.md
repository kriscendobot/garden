---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 356
created_at: 2026-05-23T00:30:00Z
last_appended_at: 2026-05-23T00:30:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#356

Created from the design-panel verdict (7 seats, in-band fallback) on `design(gateway): packaging + AWS deployment + AWS-attuned Gateway (stacked siblings of #343)` round 2. The PR is the second commit in a stacked design family (`gateway-package` -> `gateway-packaging-ci` -> `gateway-aws-deployment` -> `gateway-aws-attuned`) introducing 3954 lines of new design prose. Round 1 produced 5 must-fix + 18 summary-fix dispositions; round 2 terminated with 0 must-fix, 4 summary-fix (bundled as a job-board post), 3 follow-up items below, and 6 acknowledge dispositions. The PR un-drafts on this round.

## Items

- [ ] **Connect admin-authority (Feature 7) to the shared-UDS implication for multi-user hosts with group-relaxed sockets.**
  **Source juror(s)**: critic.
  **Round**: 2.
  **Recommended action**: open a follow-up PR amending `designs/gateway-package.md` § Feature 7 to add a paragraph noting that the admin daemon (UDS bootstrap with `GatewayAdmin` exo) and relay registration share the same socket; on a host that has relaxed the UDS to 0770 with a group whitelist (per Feature 4), any group member can reach the admin exo as well as the relay-register exo. Surface as an explicit threat-model entry alongside the existing "operator running a multi-user host therefore restricts the UDS socket's group whitelist" note in Feature 4.

- [ ] **Add `verify()` operation to the `GatewayEnclaveService` signature so the grace-period read path is explicit.**
  **Source juror(s)**: skeptic.
  **Round**: 2.
  **Recommended action**: open a follow-up PR amending `designs/gateway-aws-attuned.md` § Nitro Enclaves § Enclave responsibilities to add `verify(token: BearerToken, durableKeyVersion?: string): Promise<VerificationResult>` to the interface. The grace-period read path (current and prior key versions both verify) currently only implies the verify operation; naming it makes the resolution of parent Open Question 4 fully concrete on the verification side.

- [ ] **Add a "where to start reading" pointer on `designs/gateway-package.md` for the stacked design family.**
  **Source juror(s)**: novice.
  **Round**: 2.
  **Recommended action**: open a follow-up PR adding a short reading-order pointer to `designs/gateway-package.md` (above the Dependencies table, ideally) that names the four-document stack: grandparent (`gateway-package.md`) -> packaging-CI (`gateway-packaging-ci.md`) -> AWS deployment (`gateway-aws-deployment.md`) -> AWS-attuned (`gateway-aws-attuned.md`). Today the stack is reachable through the README's dependency graph; the in-document pointer would help a reader who lands directly on one of the docs.
