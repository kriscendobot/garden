Inbox empty. The job is complete.

## Completion report — design-minion-town-guest-primer

**Deliverable:** Draft PR **[kriscendobot/minion.town#78](https://github.com/kriscendobot/minion.town/pull/78)** — `design/guest-primer` → `main`, one-file diff `designs/guest-primer.md` (249 lines), left draft with the `<!-- garden-job: design-minion-town-guest-primer -->` marker so the completion machinery auto-stages the design gauntlet. Both mermaid diagrams validated parse-clean (`flowchart-v2`) via the parse-only jsdom recipe.

**What I did.** Grounded the design by reading both session skills (`minion-town-clip-publishing`, `minion-town-mcp-playwright-login`), the minion.town design corpus (`clip-ocap-synthesis`, `mcp-endo-guest`, `git-content-substrate`), and the two adjacent jobs, then ran two parallel Explore agents over checked-out worktrees of `endojs/endo-but-for-bots @ llm` and `kriscendobot/minion.town @ main` to map guest provisioning, the pet-name grammar, the MCP tool surface, and the WebSocket/CapTP backend path. Wrote the design in the repo's own convention (`# Design:` + Status/Mandate/Grounded against/Companion block, numbered sections, mermaid), committed, pushed, and opened the PR through `ensure-pr.sh`.

**Key resolutions the design lands:**
- **Placement — resolved against the first-glance answer.** A default endowment "sounds Endo-side," but the evidence puts it **minion.town-side today**: the readable-tree *primitive* already exists in the Endo daemon (needs no work), and the plain-named provisioning pattern is demonstrated **daemon-change-free** in `endojs/endo-but-for-bots` `packages/lal` (a pet name `primer` bound to a checked-in tree, `storeIdentifier`-ed per guest) — the exact shape minion.town already uses to inject `sites`. Per `mcp-endo-guest.md` §2, `src/endo/` is the transplant candidate and the garden must not pre-emptively open `@endo/mcp` jobs. A *reserved* `@primer` (the actual daemon change) is deferred as an open question.
- **The `@main`-gap class is avoided by construction:** plain `primer` (not `@primer`) sidesteps the pet-name-grammar throw behind the `@main` bug (which is itself already fixed at my checkout's HEAD, PR #71); lazy, idempotent, self-healing `storeIdentifier` provisioning at guest *access* avoids stranding the existing guest population.
- **Minimal-prompt constraint met** via a self-announcing `primer` index that names its own onward `readText` targets, plus a physical shape (flat text entries now; content-addressed tree + a small guest-tool `lookup`/`readText` fix at platform scale) that fits the guest's real MCP surface — which has **no `lookup` tool and no directory recursion** today (the load-bearing constraint I discovered).
- **The front/back + WebSocket/CapTP backend recipe** the primer must teach, grounded in `clip-ocap-synthesis.md` / the gateway powers-plane (`/.well-known/endo-captp`, `connect-src 'self'`), including what is *not* live yet (`upgrade`, ocapn codecs).
- **Mutable-space analogy worked through, not forced:** the guest already holds the mutable half (its `writeText`/`readText` store ≈ `library/`; its mailbox ≈ the message bus); `primer` supplies only the missing static-reference half; the garden's *job board* has no clean guest equivalent and the design declines to invent one.
- **Staging + validation:** a mutable primer scoped to the bot's own guest first, gated by a minimally-prompted subagent evaluation before any platform rollout; cross-linked as complementary to `design-minion-town-eval-campaign` (garden #77).

**Follow-ups (for the maintainer, as §8 open questions in the PR):** reserved `@primer` (daemon change) vs. plain `primer`; whether/where the guest-tool `lookup`/`readText` fix lands; who authors/owns the primer content over time; and per-guest vs. strictly-uniform content. No garden-repo (`main2`) change was needed — the deliverable is the minion.town design PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-guest-primer.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 46 tokens (3764447 cached reads)
- Output: 29083 tokens
- Cost: $9.643789250000001
- Wall-clock: 1184s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
