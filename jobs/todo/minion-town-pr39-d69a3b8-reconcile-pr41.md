---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (fork worktree `worktrees/kriscendobot-minion.town.git`). Target PR: https://github.com/kriscendobot/minion.town/pull/41 (branch `design/git-remote-capability`, open).

`designs/git-content-substrate.md` merged to `main` via https://github.com/kriscendobot/minion.town/pull/39 (merge commit 289d1a3). Its final commit d69a3b8 ("design(git-content-substrate): pin the deployment root in the document, not the URL or a cookie") resolves @kriskowal's review objection ("Can we alternately use a cookie? Changing the content root damages hyperlinks") and changes a serving-side decision the merged doc explicitly hands off: it says #41 is the superseding design and that #39 "retains only the projection, publication, caching, and serving invariants that the broader design can reuse."

The decision now recorded in #39 § 1 item 4, § 5, § 8 and its Definition of Done: deployment-coherent caching carries the content root in the served document's own immutable sub-resource references — **not** in the top-level URL (no redirect to a root-qualified prefix, which rots shared/bookmarked links) and **not** in a cookie (origin-scoped shared mutable state; breaks two tabs on different deployments, re-introduces per-request state into the deliberately cookie-free static boundary). Entry and navigational hyperlinks stay clean and deploy-stable; coherence is a per-top-level-document property; navigation deliberately tracks the latest deployment.

Task (designer, design-doc only — no live/runtime change): read the merged `designs/git-content-substrate.md` at 289d1a3 (especially § 5 and § 8) and `designs/git-remote-capability.md` on the #41 branch at 609fdd5. `git-remote-capability.md` currently discusses the mutable-ref/immutable-blob read-path discriminant but does not carry the deployment-coherence decision at all (no treatment of cookie vs URL vs in-document pinning, and no hyperlink-durability requirement). Absorb the decision into #41 — either by restating the invariant in #41's serving/caching section or by an explicit normative reference to #39 § 5 — so the superseding design does not silently re-open a question the review already closed. Push the update as a review-feedback follow-up commit on `design/git-remote-capability` and note it on PR #41.

Do not propose landing the #39 projector experiment upstream; that document is deferred by its own status line.
