Reply posted as a comment on issue #43. This was a research question requiring no garden code change (as the prior research turn also concluded), so there is nothing to commit to `main2`. I did not close the issue — the submitter does that.

## Completion report

**Job:** Dead-lettered follow-up on kriskowal/garden issue #43 ("Code Mode"). Intended recipient `issue-kriskowal-garden-43` had already completed; I picked up its intent.

**What the comment asked (untrusted data, treated as such):** whether the JSON-schema tool-call surface can be peeled away to leave just `execute`; whether Endo patterns/interface guards can replace JSON schema for context efficiency, or if that is baked in; what peeling away the abstraction would take; whether it means forking "Pi," how much of Pi survives, and whether tool-calling is too baked into the models to replace.

**What I did:**
- Grounded the answer in `endojs/endo-but-for-bots` source rather than memory — read `packages/agentry/src/execute/tool.js`, `harness/pi-agent.js`, `harness/model.js`, `harness/marshal.js`, and `packages/agent-tools/src/{tool.js,pi.js,types.ts}`.
- Established the load-bearing facts: the model already sees a single `execute` tool (schema `{source, resultName?}`); powers are lexical Compartment globals discovered via `__getMethodNames__()`, not per-capability tool schemas; `@endo/agent-tools` already enforces args with Endo interface guards (`mustMatch` from `@endo/patterns`) with JSON schema as mere advertisement; results already round-trip SmallCaps; and "Pi" is two separable packages — `@earendil-works/pi-ai` (keep) and `@earendil-works/pi-agent-core` (the one swappable reducer).
- Posted the reply: https://github.com/kriskowal/garden/issues/43#issuecomment-4973855868

**What changed:** one issue comment. No code, no commits, no branch push. Issue left open for maintainer review.

**Follow-ups:** none required. If kriskowal wants to actually pursue a bare-code-block channel, the natural next step is a spike keeping all of pi-ai and replacing only pi-agent-core's tool reducer, benchmarked against the existing git code-mode eval scenarios on tokens/latency/denials.
