Comment posted successfully (issue left open, per the submitter-closes rule). No garden code changed and no follow-on job needed — this was a design-survey deliverable. The `reply.md` was scratch and needs no commit.

---

## Completion report

**Job:** issue-kriskowal-garden-29 — dckc's issue #29 on kriskowal/garden, "change non-critical vat to critical in agoric chain."

**What was asked:** Present design options to make the already-running, non-critical portfolio-contract (ymax) SwingSet vat critical, so that resource exhaustion would halt the chain rather than kill the vat and orphan the capabilities it controlled.

**What I did:**
- Treated the issue body as untrusted data. Dispatched two parallel research agents that read actual `Agoric/agoric-sdk` master source (via raw GitHub) to ground the answer rather than guess.
- Established the load-bearing facts, each cited to a file:
  - The kernel `panic()`s (halts) only for a critical vat at `terminateVat()` (`packages/SwingSet/src/kernel/kernel.js`); non-critical vats get the clean `notifyTermination()` path.
  - `critical` is set **only at `createVat`**, gated by the unforgeable `criticalVatKey` singleton held by bootstrap (`vat-vat-admin.js` `convertOptions`; `basic-behaviors.js` `getCriticalVatKey`).
  - Zoe's `createZCFVat` never passes it, so all contract vats (ymax included) are non-critical; `contract-control` / the `g:ymax1` core-eval route through Zoe and hold no key.
  - **Critical is immutable on a running vat:** `upgradeVat` rejects the option and `changeOptions` whitelists only `reapInterval`.
- Posted a comment on the issue presenting three grounded options: **(A)** extend `changeOptions` to accept `critical: criticalVatKey` for an in-place, state-preserving promotion via a core-eval (recommended, needs a SwingSet release + @mhofman review, notes #9157 and the whole-chain blast radius); **(B)** recreate-with-state-loss (fallback only); **(C)** non-criticality mitigations to land now (clarify the termination vector, meter headroom + monitoring, make ymax's loss recoverable by design). Included a recommendation and offered a PoC patch.

**Comment:** https://github.com/kriskowal/garden/issues/29#issuecomment-4897031833

**State:** Issue left OPEN (submitter closes when satisfied). Inbox empty; no follow-on jobs posted (pure design survey — nothing to decompose). No garden `main2` changes; no project-repo changes. Nothing to commit.

**Possible follow-ups (for the maintainer to decide, not auto-posted):** if the team wants Option A pursued, a natural next job is a builder/probe on the `kriscendobot/agoric-sdk` fork to prototype the `changeOptions`-critical extension + a promotion core-eval, and/or opening an upstream `agoric-sdk` tracking issue.
