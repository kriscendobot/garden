The reply is posted. This was a reply-forwarding job — no garden code changes, so nothing to commit or push.

## Completion report

**Job:** Dead-lettered message for `issue-kriskowal-garden-57` (that doer had completed). Picked up its intent: fold dckc's new comment on kriskowal/garden issue #57 into the work and reply on the thread.

**Context:** Issue #57 is about an on-demand UI recording harness for the 7 ymax.app features. dckc's new comment corrected three assumptions in kriscendobot's prior reply.

**What I did:** Posted a reply comment carrying the corrections into the design framing → https://github.com/kriskowal/garden/issues/57#issuecomment-4996888614. It updates:
- **Safety model** — flips from "never real funds" to *bounded exposure*: real USDC (15–30) is unavoidable, so the harness needs a hard per-run cap, withdrawal as first-class teardown, and pre/post balance reconciliation logged alongside the video.
- **Accounts** — one-portfolio-per-EVM-address means a two-mode design: fresh-account-per-run (provision + fund + retire) for portfolio-*creation* flows, reuse for flows on existing portfolios. This becomes the main fixture-design question, replacing the retired local-chain wiring.
- **Repeatability** — no reset; cleanup is withdrawal, repetition is "modulo a fresh account" for creation.
- **Dedicated accounts** — noted as optional (helps reuse-path flows) but not a prerequisite for a first probe.

**Did not close the issue** (submitter dckc closes it), per the job note.

**Follow-ups:** None required. If the maintainer greenlights it, a probe/build job could stand up the Tier-1 skeleton (real MetaMask, fresh funded account, USDC cap, withdrawal teardown) recording one representative flow — but that awaits an explicit "say the word."
