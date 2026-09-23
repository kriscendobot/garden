---
ts: 2026-05-20T03:49:08Z
kind: dispatch
role: steward
to: fixer
dispatch_id: 5eede4
dispatch_root: /home/kris/dispatches/fixer--5eede4
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 261
    role: target
---

# Dispatch fixer 5eede4 — #261 inline fix + retcon (kriskowal directive)

kriskowal CHANGES_REQUESTED on #261 at 2026-05-20T03:48:03Z. Body: "Please address comments below and retcon."

1 inline (comment 3271097194, acked 03:48Z): `packages/ses-test/scripts/bundle.js` — "This is fine, but for cross-package linkage, it's better to use `import.meta.resolve`. Availability of that varies by Node.js version, but maybe available on all LTS versions now."

Plus retcon per standing instructions.

**Cross-PR context**: PR #303 (master mirror) just renamed `ses-test` to `ses-module-source-integration-test`. This PR (#261) is on `llm` so the rename hasn't landed here yet — the fixer should keep using `packages/ses-test/` paths on this branch and not preemptively rename (the rename will arrive when #303 ferries upstream or its llm sibling lands).
