Inbox empty. The job is complete.

## Completion report

Answered the maintainer (kriskowal) `rsvp` review on **endojs/endo-but-for-bots PR #264** (design/compartment-mapper-import-attributes), engaging all four inline comments. Design doc stays **Proposed**, so clear-cut items landed as edits and maintainer-facing choices were refined (not forced) into `## Open questions`.

**Doc edits** (pushed as `db011c31a` to `design/compartment-mapper-import-attributes`):
1. **`.zip` fix** — "typically a `tar.gz`" → "a `zip`".
2. **`moduleMapHook` question** — verified against source: `ses/types.d.ts` types both `ModuleMapHook` and `ImportNowHook` as `(moduleSpecifier) => ModuleDescriptor | undefined` (identical, distinct from the async `importHook`), and `link.js`'s sole `new Compartment(...)` supplies `moduleMapHook`. The maintainer is right that the two share a shape and may collapse. Added a "Hook-shape note" in `## link.js` making explicit that the `modulesWithAttributes` routing depends only on both hooks being specifier-keyed, not on their staying separate.
3. **`with` preference + ordering rule + invention finding** — folded into Open Questions §1 and the "Structural distinctness" section: it's our invention (no TC39/Node package-declared default-attribute precedent); recorded `with` as the leading spelling; added the after-`default` ordering rule (provably unreachable-as-a-condition under Node first-match, stronger than the prior reserve-plus-lint contract).
4. **`specifier` → `default` rename** — applied across the `ResolvedImport` type, `PersistedImport` union, `FileModuleConfiguration.imports` schema diff, and the worked example, with the graceful-degradation rationale captured; reconciled Open Questions §6(a). Left the sibling-defined parser record `{ specifier, attributes }` (raw source specifier) untouched.

**Replies (rsvp):** posted an inline threaded reply on each of the four comment threads (all with correct `in_reply_to_id`), plus one top-level summary comment mapping each item to its outcome and the commit SHA.

**Follow-ups (not owned by this job):** the doc still flags a needed edit to the sibling `ses-import-attributes.md` (`moduleMap` → `moduleMapHook` characterization) as an out-of-scope follow-up; and the implementation PR owns locking the final companion spelling and the outer persisted-field name.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr264-design-rsvp.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3242651 cached reads)
- Output: 25567 tokens
- Cost: $3.2325715
- Wall-clock: 391s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
