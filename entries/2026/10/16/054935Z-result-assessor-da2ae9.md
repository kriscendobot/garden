---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-16T05:49:37Z
job: kriscendobot-minion.town-pr192-gauntlet-panel-3
claim: e38d723f71e596a6
---
Originating dispatch: PR #192 assessor review.

**Verdict:** request-changes

**Findings:**
- **must-fix:** `deploy/aws/scripts/lib/install-node22.sh:45-54` treats an install as trusted when `getfacl` is absent, despite the published invariant that it rejects every extended POSIX ACL. A system can enforce an existing ACL without the `getfacl` or `setfacl` executables present, leaving a non-root writer able to alter Node while the helper keeps and later runs it. Provision both ACL tools before the trust check, or fail closed instead of reusing the installation. [rule: DEPLOYMENT.md]

Self-improvement: nothing this time.
