---
role: builder
---

Build Phase 2 of the accepted git-capability stack (daemon-git-next-steps § Phased Build Plan, sequenced by PR #691) in endojs/endo-but-for-bots: the commit-identity boundary — formula-owned, guest-immutable `{ authorName, authorEmail }` construction options on `provideGit` / `provideGitClone`, threaded per invocation through the existing `withGitEnvOverrides` seam in `native-git-backend.js` and defaulting to today's hardcoded `Endo <endo@invalid.local>`.
