---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-08T18:56:11Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: the end-to-end evaluation, both the MCP flow and the CapTP flow

Repo: `kriscendobot/minion.town`. Child of arc
https://github.com/kriscendobot/garden/issues/89 (item 7).

Nothing designed for this yet. minion.town is multi-modal, drivable from MCP or over
CapTP, so a credible end-to-end validation of Claude-on-minion.town needs both.

**Flow A, MCP (prompt-driven).** An agent is directed to use the minion.town MCP surface
to create a new bot guest with a particular Claude credential, subscription or API token.
The evaluation is a prompt to that effect, followed by directions to send the guest bot to
use its capabilities. For example, endow it with a capability to increment a counter, then
verify from outside that the counter was incremented. A more elaborate scenario asks the
agent to publish a clip, then validates the clip with a `fetch`.

**Flow B, CapTP (deterministic).** An Endo CLI sends messages to a minion.town agent,
establishing the same scenarios as a shell script that can simply be run. This route is the
one amenable to deterministic evaluation and should be treated as the primary one.

Design the evaluation, covering at least:
- **The scenarios themselves.** Start with the counter, since its verification is
  unambiguous. Then the clip-publish scenario, verified by fetching the published URL.
  Specify each scenario's setup, the exact external observation that constitutes a pass,
  and what a partial pass looks like.
- **Evaluator cheating. This is the maintainer's explicit concern and the reason this is a
  design job rather than a build.** Enumerate the ways an evaluator inadvertently cheats:
  observing state it also wrote, verifying through the same capability path under test,
  accepting a cached response, an agent that satisfies the prompt without exercising the
  intended capability, a counter incremented by the harness rather than the guest. For
  each, state the structural defense. Prefer defenses that make cheating impossible over
  defenses that detect it.
- **Why Flow B is more trustworthy.** Make the argument concrete, and say what Flow A is
  still needed for despite being weaker.
- **Credential handling in the evaluation.** Both credential kinds must be exercisable. No
  credential may enter a report, a journal entry, a worktree, or an image.
- **The dependency.** Flow B requires the invite/accept workflow such that an Endo CLI can
  send messages to a minion.town agent. `EndoGuest` today has neither `invite` nor
  `accept`; those are exclusive to `EndoHost`, and the guest-owned primitive is open at
  https://github.com/endojs/endo-but-for-bots/pull/1125 (draft). Design against that
  primitive's interface, state the dependency explicitly, and do not design an
  app-mediated or host-authority fallback.
- **Where it runs.** Whether the evaluation runs against the live minion.town deployment,
  a local two-daemon fixture, or both, and what each proves that the other does not.

Deliverable: one design document plus a concrete, reviewable sketch of the Flow B shell
script. Do not build the evaluation.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-08T18:56:39Z
