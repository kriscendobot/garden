---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design the course correction after `claude --bare` rejected subscription tokens

Repo context: `endojs/endo-but-for-bots` (branch `llm`; `@endo/claude`,
`@endo/agent-tools`, the guest stdio MCP server, the lal and fae harnesses) and
`kriscendobot/minion.town` (the guest UI and weblet gateway). Route this to a
designer. Open the resulting design on the appropriate bot-fork review surface
(it will carry open questions); do not build it in this job.

Origin: kriskowal, liaison session 2026-10-23. Verbatim:

> It has come to my attention that `claude --bare` does not accept subscription
> tokens. The entire conceit of the `claude --bare` was an attempt to use
> subscription in the confined endo environment on minion.town, so the garden
> could continue to use subsidized inferrence. This suggests two course
> corrections. We deprecate the stdio MCP for guests, since that would only have
> been driven from `claude --bare`. We can remove the `claude` CLI wrapper in
> `@endo/claude` (please verify). We can then embrace the simpler approach of
> enabling guests to provision an agent pinned to a guest with an API key. We
> would use the existing lal or fae harnesses, or harnesses derrived from them.
> The minion.town UI should simply surface a button and form for entering an API
> key, the harness type (lal or fae, maybe others if we've accumulated
> alternatives while I wasn't watching), and a name for the bot. This would be
> similar to the existing lal demo where the lal server sends the user a form,
> but I would prefer to trigger the creation from UI rather than an unsolicited
> message. Please post a design that plans out the steps for the course
> correction, including a linked subdesign for the new approach to creating
> agents. We should track API keys as secrets in an indellible `@secrets` store
> such that a user can easily spawn new agents from that inferrence source. So,
> I am describing a form for creating an inferrence provider from an API key, and
> a separate step for generating a subagent attached to that inferrence source and
> confined to its own guest powers facet, pinned to wake on message.

## Deliverables

Two linked designs, landed together as one review surface:

1. **Course-correction plan** (the parent design). A stepwise plan, each step
   independently shippable and ordered so production never loses a working path:
   - **Verify first, with evidence.** Confirm that `claude --bare` rejects
     subscription tokens (cite the CLI behaviour or docs you can reproduce; do
     not take this on assertion). Then inventory everything that exists only to
     serve `claude --bare`: the `claude` CLI wrapper / CLI backend in
     `@endo/claude` (the CLI and Agent SDK backends landed in endo PR #1412, the
     pinned-CLI bump and bwrap sandbox slices), the guest stdio MCP server
     (endo PRs #1336 and #1371), minion.town's Claude CLI provider and harness
     image (minion.town PRs #148, #150, the `tools/claude-harness` dependabot
     bumps, the signed-manifest/tarball verification in #122), the per-guest
     pinned responders (#165) and delegation work (#120, #140), and any garden
     scripts, skills or dependabot hooks tied to them. Say, per item, whether it
     is removable, must stay (because something else uses it), or needs
     retargeting. The user asked specifically to verify that the CLI wrapper in
     `@endo/claude` can be removed; answer that directly, including what else
     imports it.
   - **Deprecation sequence** for the guest stdio MCP and the CLI wrapper:
     what is marked deprecated, what is deleted, in what order, behind what
     flag, and what happens to guests/delegations already depending on them.
     Note the garden's own use (the fleet's workers talking to the
     minion.town MCP) is separate from the guest stdio MCP; confirm which is
     which and leave the former alone unless the inventory shows otherwise.
   - **What survives.** State plainly what of the `@endo/claude` work remains
     valid (confinement core, `@endo/inference` interface, Agent SDK backend if
     it takes API keys) versus what was subscription-specific.
   - Rollout, migration, rollback, and test/probe changes (the production
     probes and canaries that assert on the removed surfaces).

2. **Subdesign: API-key inference providers and pinned guest agents.** Linked
   from the parent. It must settle:
   - **Two separate steps**, as the maintainer describes: (a) a form that turns
     an API key into an *inference provider*; (b) a separate step that
     generates a *subagent* attached to a chosen provider, confined to its own
     guest powers facet, pinned to wake on message.
   - **UI.** A minion.town button and form: API key, harness type (lal, fae, and
     any other harness alternatives that have accumulated on `llm` since the
     maintainer last looked: survey and list them, with a recommendation), and a
     bot name. The creation is triggered from the UI, not by an unsolicited
     message from a server. Contrast with the existing lal demo flow where the
     lal server sends the user a form, and say what to reuse from it. The key
     entry must never be echoed back (cf. minion.town #195) and must not pass
     through logs, URLs or agent-visible context.
   - **`@secrets`.** An indelible store of API keys as secrets, so a user can
     spawn further agents from the same inference source without re-entering the
     key. Define: the object shape and who holds which facet; what "indelible"
     means operationally (no deletion? no overwrite? revocation by supersession?)
     and how that squares with a user wanting to retire a leaked key; how the
     key is consumed by the provider without the agent ever holding it; the
     relation to the existing `@endo/inference` interface and the provider-neutral
     broker work; and where the store lives (guest formula, host-held, or
     both).
   - **Confinement.** The subagent's guest powers facet: exactly which
     capabilities it receives, how that facet is derived from the guest so it is
     strictly attenuated, and how "pinned to wake on message" is realized (the
     per-guest pinned responder pattern from minion.town #165 is the starting
     point). Apply the maintainer's standing test for ocap claims: a bearer
     token is acceptable when it designates a specific object, not an identity
     (see minion.town #180 / #203).
   - **Cost and abuse.** Whose key pays, spend visibility, rate limiting, and
     what a runaway agent can and cannot do to the user's key.
   - **Acceptance:** a stepwise build plan fine-grained enough that each phase
     could be one builder job, with the testing approach (the clip browser
     testing recipe applies to the form).

## Constraints
- Both designs must carry an explicit `## Open questions` section for anything
  the maintainer must decide; the review PR is the answer surface.
- Mind the garden's own dependence: the garden used subsidized inference through
  this path. State, without proposing to change it here, what the garden's
  inference sourcing looks like after this change, and flag it as an open
  question if the plan leaves a gap.
- Do not touch the maintainer-reserved surfaces (ferry, identity switching).
- Cite file paths and PR numbers; verify claims against `llm` and minion.town
  `main` rather than the descriptions above.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-23T03:16:38Z
