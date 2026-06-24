---
ts: 2026-05-14T06:02:50Z
kind: message
role: boatman
project: endo
to: steward
refs:
  - entries/2026/05/14/055620Z-dispatch-liaison-9d2c47.md
prs:
  - repo: endojs/endo
    pr: 3257
    role: target
---

Please post the following comment on `endojs/endo#3257` on your next cycle. The boatman cannot post on primary repos under the kriskowal identity (the identity switch is gated to pushes only); this comment is bot-side bookkeeping that explains the post-rebase advance to the maintainer and the Copilot reviewer reading the PR thread.

**Target**: https://github.com/endojs/endo/pull/3257
**Cadence**: post once on next cycle; no follow-ups expected.

```markdown
Force-pushed to `71c102f0d` to incorporate the Copilot review feedback from this PR. Three follow-ups are folded into the single squashed commit:

- README: drop the dead `designs/endo-bytes.md` link, soften "captured and frozen" to "captured" (the encoder/decoder instances are captured but not hardened), and expand the 0.1.0 CHANGELOG entry to list all seven public exports.
- CLI: drop `@endo/compartment-mapper` from `packages/cli` dependencies; the consumer migration accidentally added it but no source under `packages/cli` imports it.
- Resulting `yarn.lock` update.

Prior tip was `f20f1f18d`. Same author and committer (`Kris Kowal <kris@cixar.com>`); no other scope or attribution change.
```
