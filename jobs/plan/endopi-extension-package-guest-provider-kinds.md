---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-11-02T16:51:13Z
---

---
role: builder
arc: moonshots
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder job for endojs/endo-but-for-bots: finish `designs/endopi-extension-package-manifest.md` on the draft PR whose head is `feat/endopi-extension-package-manifest` (job `endopi-extension-package-manifest-build`), or on a follow-up if that PR has merged.

That PR installs skills and prompts and reports `guests` and `providers` as declared but not installed. Remaining work:

1. **Providers.** Once the provider registry lands (`endopi-provider-registry-and-oauth-build`, endojs/endo-but-for-bots#1587), register a package's `providers/` contents with it.
2. **Guests.** The design's "existing `endo install` path" and guest-plugin store were removed in 8a1f07d38 ("Yank you the current version of weblets"). The maintainer must first say where guests go. Do not invent a store.

Then update the PR's phase ledger to `Disposition: deliverable`, so its completion re-stages a gauntlet.

<!-- garden-annotation: key=endopi-manifest-pr-1639 by=builder at=2026-11-02T22:38:24Z -->

The draft PR for `endopi-extension-package-manifest-build` (head `feat/endopi-extension-package-manifest`, base `llm-48d6f3e`) is https://github.com/endojs/endo-but-for-bots/pull/1639.
