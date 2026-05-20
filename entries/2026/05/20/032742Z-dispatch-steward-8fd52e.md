---
ts: 2026-05-20T03:27:42Z
kind: dispatch
role: steward
to: designer
dispatch_id: 8fd52e
dispatch_root: /home/kris/dispatches/designer--8fd52e
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 307
    role: target
---

# Dispatch designer 8fd52e — #307 round 3 (submodule pivot)

kriskowal CHANGES_REQUESTED on #307 at 2026-05-20T03:26:34Z (review id PRR_kwDORRE4FM8AAAABAcko0w), 4 inlines:

1. **3271033529**: "prettier"
2. **3271039316**: "Let's take a different gambit and export as a submodule `@endo/patterns/explain-mismatch.js`" — load-bearing redesign: drop the sibling package, use a submodule of @endo/patterns instead
3. **3271041722**: "These are indistinguishable. Let's do both at once." — collapse two artifacts into one
4. **3271042769**: "Okay." — acceptance

All acked 03:27Z. The submodule pivot is the main work for this round.
