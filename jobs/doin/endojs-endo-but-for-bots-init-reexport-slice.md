---
role: builder
---

# build: @endo/init plain-re-export slice (#548 design, separate PR)

Requested by @erights on endojs/endo-but-for-bots#660
(https://github.com/endojs/endo-but-for-bots/pull/660#issuecomment-4942288215):
"Please do this in a separate PR."

Apply the inter-package plain re-exports recipe (design #548, addressing #543;
sibling to #590 and #660) to **`@endo/init`**, which plain-re-exports
`export * from '@endo/lockdown/commit.js'` (and the `pre.js` / `debug.js` /
`pre-remoting.js` variants).

NUANCE the PR author flagged: `@endo/init`'s value is the lockdown SIDE-EFFECT of
importing it, not the re-exported names, so it reads as *not* a plain re-exporter.
Investigate carefully before mechanically applying the recipe: if the re-exported
names are genuinely unused-as-names by in-repo importers and the value is purely
the import side-effect, a plain `@deprecated`-and-repoint may be wrong or a no-op.
Confirm the design intent (deprecate the name re-export while preserving the
side-effect entry point) and, if in doubt, ask @erights via a PR comment rather
than guessing. Repo endojs/endo-but-for-bots, base branch `llm`. Non-breaking
stage-1 (patch bump, deprecate + repoint in-repo importers, add workspace dep if a
package now imports directly), separate PR from #660.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  claimed_at: 2026-07-11T04:17:59Z
