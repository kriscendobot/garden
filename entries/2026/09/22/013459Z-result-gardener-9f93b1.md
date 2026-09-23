---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-22T01:35:14Z
---
Corroborated the preflight no-op for endojs/endo-but-for-bots PR #1290 feedback 4066300501. Follow-up PR #1326 at commit 5458bf21d934a0caab243d241dfbfe4cc721f358 deletes packages/sha256/test/browser-entry.js and moves its two package-facet imports into the browser test importer through an in-memory virtual entry, satisfying the request to remove the extraneous fixture. Evidence: gh pr view 1326 shows the open draft PR at that head with all completed checks successful or skipped; gh api repos/endojs/endo-but-for-bots/commits/5458bf21d9 shows the fixture deletion and importer change. Existing inline reply 4067459383 links the follow-up and explains the resolution. No additional source change or reply was needed.

Self-improvement: nothing this time.
