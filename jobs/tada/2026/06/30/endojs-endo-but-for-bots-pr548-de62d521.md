Inbox message had an empty body (a stray ping from `inbox-send`, nothing actionable). The work is complete.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #548 (design: inter-package plain re-exports rule, #543), source comment r3495955062 by erights.

**What I found:** The source comment was one of **three** new `COMMENTED` reviews erights submitted on 2026-06-30 (r3495955062, r3495957598, r3495960357), each an inline directive anchored to one of the design's three "Open questions." Per fleet practice I addressed all three in one pass rather than just the cited one. erights is maintainer-equivalent on this repo and commenting is standing-authorized.

**What the directives asked, and what I did** (commit `5055d0577` on branch `design/inter-package-plain-re-exports`, prose-only edit to `designs/inter-package-plain-re-exports.md`):

1. **`export *` aggregators** → Dropped the per-package "value-adding aggregate surface is a judgment call" carve-out. A non-renaming cross-package `export *` is now a plain re-export, treated identically to a named one. Used `@endo/far` as the worked example exactly as erights enumerated it: imports repointed in both directions at the originating export, every export deprecated. Also reconciled the `@endo/far` Examples bullet, which carried the same now-rejected "per-export residual-value judgment" language.
2. **Type-only re-exports** → Kept in scope, treated the same; made explicit that the smaller-bundles rationale doesn't apply to a type-position repoint but the remaining rationales (tooling disambiguation, readable layering) suffice.
3. **Deprecation mechanism** → Settled as an `@deprecated` JSDoc tag on the re-export; dropped the lint-rule alternative.

The section is renamed "Open questions" → "Resolved questions."

**Communication (all on the PR):**
- Inline thread replies: r3495967585, r3495967641, r3495967716.
- Top-level summary comment: https://github.com/endojs/endo-but-for-bots/pull/548#issuecomment-4839597153

**State:** PR remains a draft (design-only; no importers moved, nothing removed), pending erights' review of the resolved rule. No code/tests touched, so no CI follow-up needed.

**Follow-ups:** None required for this job. The downstream implementation work (the two-stage repoint-and-deprecate then remove pass described in the design) is separate future PRs, not part of this directive.

**Self-improvement:** nothing this time.
