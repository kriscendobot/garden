---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-18T00:46:46Z
---
---
ts: 2026-07-18T01:05:00Z
kind: progress
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Job fix-endo-but-for-bots-pr626-stack-surgery-pass-path: implemented the scripted faux-model pass-path for the stack-surgery eval on PR #626. New reference solution (src/eval/scenarios/stack-surgery/reference.js) follows the no-reset split recipe (createBranch at the mixed commit's parent, filesystemAt read, write/add/commit, cherryPick + retargeted fixups + autosquash, side-branch replay, reword). Fixture powers flipped to allowHistoryRewrite: true; eval-live row un-skipped; stale comments and PR title/body refreshed. Local: 117/117 agentry tests pass, tsc clean, eslint no errors, prettier clean, gate probes pass. Also pinned rerere.enabled off in the eval fixture (host-level rerere broke a pre-existing conflict-rebase test locally). Pushed 73356f8ff5a; watching CI.
