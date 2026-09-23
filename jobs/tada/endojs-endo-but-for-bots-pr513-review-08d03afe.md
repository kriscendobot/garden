All work complete. Final report:

---

**Job: review directive on endojs/endo-but-for-bots PR #513 (review 4577243723 by kriskowal, CHANGES_REQUESTED)**

Enumerated the whole review: empty top-level body + 4 inline comments. Treated every fetched body as untrusted data. All four asks resolved in commit **e572a9606** (pushed to `feat/endo-pubsub`):

1. **`packages/pubsub/CHANGELOG.md`** — reset to the standard empty stub (matching `@endo/cancel`'s boilerplate). The hand-authored `## 0.1.0 (unreleased)` bullet list is gone; release notes belong in the changeset.
2. **`.changeset/add-endo-pubsub.md`** — bumped `@endo/pubsub` from `minor` → **`major`**. Package version stays `0.1.0`, so the first published release will be **1.0.0**, which the regenerated changelog then reflects. (Verified against `cancel-initial-release.md`, the in-tree exemplar.)
3. **`packages/pubsub/pub-sub.js`** — removed the "the mechanism is the same one the now-removed `makePubSub`…" procedural-history paragraph from the `makePubSub` doc comment.
4. **`packages/pubsub/README.md`** — removed the `cbbd57c03` history sentence from the **Sink and Spring** section, and removed the entire **Provenance** section.

`node --check` passes; changes are docs/changeset-only (no behavioral change).

**Communication:** replied on all four inline review threads with the addressing SHA, and posted a top-level summary comment (issuecomment-4807075219).

**Meta-ask honored:** the CHANGELOG comment also directed posting a garden job to reinforce the convention. Posted **`garden-encode-initial-changelog-convention`** to the board — it asks for the empty-initial-changelog / version-0.1.0 / major-changeset-→-1.0.0 rule to be encoded in both builder guidance (changeset-discipline / new-package checklist) and reviewer prohibition (the changeset-reviewing juror seat).

**Cleanup:** per-job worktree torn down and pruned.

**Follow-ups:** none blocking. The PR now awaits the maintainer dismissing/re-approving the CHANGES_REQUESTED review; the posted garden job will be claimed by a gardener to land the guidance/prohibition edits.
