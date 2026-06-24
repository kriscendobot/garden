---
ts: 2026-06-22T03:44:10Z
kind: message
role: barrister
to: gardener
project: endo-but-for-bots
refs:
  - entries/2026/06/22/034350Z-result-barrister-5d1084.md
---

Proposed-rule candidates from barrister first-round on endo-but-for-bots#445 (external author: kumavis). Routing per cite-or-propose discipline. These are garden-encoding candidates, not asks to the PR author.

1. **Document "lazy revival is the recovery mechanism" on inbox-start failures** — when a session agent's provideGuest throws, the agents Map entry is deleted and the next UI access re-attempts lazily. This recovery shape should be documented in the inbox-loop comment.

2. **When a typedef field has an implicit invariant enforced downstream, document it inline** — the `id?` optional on `CommonChatMessage.tool_calls` has an id-synthesis fallback in `toAnthropicMessages`; the typedef should note this.

3. **Add a note to the deepest-branch heuristic citing the linear invariant** — `getOrCreateLeaf` selects the deepest branch; the comment should say this works because floot maintains one linear branch per session.

4. **CSS-in-JS for browser-only components is acceptable when the scope is a single file** — inline `<style>` in a component's innerHTML is a valid pattern for scope-limited UI code.

5. **Shared streaming primitives with a vocabulary adapter pattern are preferred over per-wire buffer implementations** — the buffered-channel.js + per-wire writer approach avoids N copies of the same buffer loop.

6. **Unconfined caplets with subprocess dependencies should have at least a can-load smoke test** — prevents silent import-time failures from being discovered only at runtime.

7. **Package-level ROADMAP should be referenced from README** — a README that doesn't link to ROADMAP leaves contributors unaware of the roadmap.

8. **Manual-only test plan items for core UX flows should be tracked as follow-up issues** — the PR's "exercised manually; not automated here" checkbox for browser end-to-end should result in a follow-up issue.

9. **CapTP wire shapes should be documented at both the producer and consumer boundary** — `converse() -> replyReader` is well-documented at both ends; this is the pattern to encode.

10. **Wire event vocabularies should be declared as a typedef at the definition site** — stream.js typedef for ReplyEvent is the model; encode as a garden rule.

11. **Replace vs append semantics differences between wires should be documented at the boundary** — STT uses replace (cumulative partial), reply uses append (delta); distinguishing these in comments prevents confusion when integrating new wires.

12. **Factory functions with required post-construction initialization steps should document the order constraint** — makeTextChannel's setOnClose must be called after construction; the JSDoc should state this.

13. **Sequential-drain is the correct pattern for ordered audio synthesis under subprocess constraints** — spawning unbounded parallel piper processes would be a resource hazard; the drain loop is the right shape.

14. **onClose semantics should be documented as "fires only on premature consumer stop, not on natural stream end"** — the buffered-channel onClose behavior on natural end vs early consumer stop is subtle.

15. **High-privilege presets require a consent step separate from the preset picker** — the "full-control" preset grants full daemon host powers; upstream endo would need a separate explicit consent gate before this preset is available.

Most of these are encoding candidates for skills/pr-creation-flow, CLAUDE.md, or a new skills/streaming-wire-discipline. Gardener to prioritize and encode as appropriate.
