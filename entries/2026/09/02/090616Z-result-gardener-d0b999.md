---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-02T09:06:21Z
---
---
kind: result
role: integrator
repo: kriscendobot/minion.town
project: minion-town
---

Panel seat `integrator` — PR #68 (`feat/weblet-publish-dir`), diff base `origin/main`.

### integrator

**Verdict:** request-changes

**Findings:**

- **must-fix — title and description name a tool that does not exist at head.** Title says `weblet_publish_dir tool`; head registers `publishDirectory` (`src/endo/guest-tools.ts:566`). The body cites `test/endo-weblet-tools.test.ts`; the tests are in `test/endo-clip-tools.test.ts`. And `weblet_publish_dir` is exactly the prefixed snake_case form `README.md:70-79` § Naming convention (landed by #77) retires — the merge commit would advertise a retired spelling for a tool that landed under the new one. `9a6ece8` swept code and tests but not the PR surface or the commit subjects. [rule: skills/rename-discipline/SKILL.md] [rule: skills/pr-formation/SKILL.md]

- **must-fix — `publishDirectory` reads against the project's own naming rule.** `README.md:88-94` reserves `<method><Facet>` camelCase for *collision qualification*, so `publishDirectory` parses as "the `publish` method of a `directory` facet", which does not exist. This tool mirrors no method (it composes `evaluate` + `publish.publish`), so `README.md:70-75` requires it to *name its operation*; "directory" is already load-bearing twice here (the clip's front/back directory; the guest pet-name directory). Pick an operation name (e.g. `publishStored`), and fix `README.md:74` — "the only composed tool on today's surface" is false once this lands. [rule: skills/pr-formation/SKILL.md]

- **must-fix — unreconciled with in-flight #79.** #79 (`feat(mcp): reserve reconciled tool names`, open) centralizes the flat namespace in `src/endo/mcp-tool-names.ts`, a maximal-surface manifest rejecting duplicates at load, and re-routes every registration in this same file. #68 hand-registers a bare literal outside it and declares no `garden-related-design`. Name #79/#77 in the body and state the manifest entry this tool takes. [rule: roles/jurors/integrator/AGENT.md § Current-related-design reconciliation]

- **should-fix — the round-trip test narrates instead of asserting.** `test/endo-clip-tools.test.ts:250-254` claims text was UTF-8-encoded, bytes base64-decoded, "both interned … under paths we can read back", then asserts only that the hash appears in `listSites`. A swapped encoder or a dropped file passes. `makeFsClipStore(root)` is in the fixture; `store.read(hash)` pins both manifest paths. [rule: roles/jurors/integrator/AGENT.md § Test pins what it claims]

- **should-fix — stale file contract.** `test/endo-clip-tools.test.ts:10-11` still says "all four publication tools mount"; the `it()` title was updated to five, the header docstring was not. [rule: skills/rename-discipline/SKILL.md]

- **should-fix — commit grouping.** The mock-AS scope fix (`dev/mock-as.ts`) is unrelated to guest-value publishing yet rides inside `f801479 feat(weblet): add weblet_publish_dir tool` and is touched again by `9a6ece8`; two of four content commits are same-PR self-corrections, so the merge-commit reader watches the tool get rewritten twice before it ships. Split the mock-AS fix out; squash the corrections in. [rule: roles/jurors/integrator/AGENT.md § Commit grouping]

**Notes (out of scope but worth flagging):**

- `src/endo/guest-tools.ts:170` re-checks the non-empty string that the tool's `z.string().min(1)` already enforces. [rule: roles/jurors/integrator/AGENT.md § Type-level discouragement over runtime guard]
- New `@endo/bytes` runtime dependency for one `bytesFromText` call, where `src/endo/captp-client.ts:78` already sets `new TextEncoder()` as this repo's UTF-8 convention. [rule: roles/jurors/integrator/AGENT.md § Convention probe]
- `ContentDirectory` (`src/endo/guest-tools.ts:151-157`) drops sibling `publish`'s `.min(1)` on the array and on `path`/`contentType` and its per-field `.describe()`; the next adopter pastes-and-edits rather than extends a base. [rule: roles/jurors/integrator/AGENT.md § Forward-compose probe]
- `dev/mock-as.ts:41` is `request.query?.scope ?? (request.query?.scope as unknown)` — the same expression on both sides of `??`. Critic/pedant overlap. [proposed-rule: a `??` whose branches are the same expression is dead code and should be flagged.]
- The body cites issue #65, which asks for a CI test telling the Waldo counter-weblet story; this adds unit coverage of the new tool, not that story. Say so, or #65 reads as addressed. [rule: skills/pr-formation/SKILL.md]

Self-improvement: § Current-related-design reconciliation caught the #79 collision, but the brief scopes that axis to *design* PRs; the live conflict here was an open **implementation** PR restructuring the same namespace. Proposed widening for `roles/jurors/integrator/AGENT.md`: read the axis as "any open PR the seam depends on", design or build.
