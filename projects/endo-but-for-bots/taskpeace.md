---
created: 2026-07-07
updated: 2026-07-07
author: scholar
---

# TaskPeace competitive study: an MCP-native agent task queue vs. our ocap agent substrate

> Abstract: TaskPeace (<https://taskpeace.com/>) is mission-control for AI coding
> agents — one ranked priority queue that agents pull from via MCP
> (`get_next_task` → work → `complete_task`), with humans holding exclusive
> control of priority. Studied on maintainer request ([kriskowal/garden#30](https://github.com/kriskowal/garden/issues/30);
> full report at [issuecomment-4898795049](https://github.com/kriskowal/garden/issues/30#issuecomment-4898795049)).
> Its coordination shape mirrors both the garden's job board and the surface
> endo-but-for-bots circles but has not named as a first-class primitive. The
> two projects solve adjacent halves: TaskPeace ships the *coordination surface*
> with no security model; endo-but-for-bots has the ocap *security substrate*
> (daemon, Capability Bank, CapTP/OCapN) with no first-class Task/Queue
> primitive. Provenance caveat: single marketing-site fetch (2026-07-07),
> features as-advertised, not verified against the shipped MCP server or GitLab
> source.

## Gestalt

The thesis is coordination, not capability: frontier models are already capable,
so the bottleneck is getting agents to work on the right thing, in the right
order, with the right context, and report results. TaskPeace answers with exactly
one total order — *"one queue answers 'what's next' unambiguously, for you and
for your agent"* — deliberately refusing the multi-label world of Linear/Jira/
Notion. MIT-licensed, self-hostable (GitLab source), cloud mode (encrypted
Upstash KV) or local mode (browser localStorage, no account); Free tier and Pro
at $10/month flat.

## Feature inventory (as advertised)

- **Agent loop**: `get_next_task` → execute → `complete_task`, repeat until drained.
- **MCP-native, glue-free**; broad interop (Claude Code, Cursor, ChatGPT, Cline, Goose, Warp, Continue, Windsurf, Zed, Gemini CLI); local via MCP, remote via REST.
- One ranked queue across projects; placement (inbox/top/bottom); subtask checklists; reusable-label properties; query syntax (`@agent`/`@me`/`@any`, `#project`, `+Label`, `status:`).
- Human-in-the-loop authority split (humans prioritize, agents execute — the "durable layer").
- Parallelization (Pro): up to 5 concurrent sessions with **task leasing** against collisions.
- Six workflow prompts: Plan, Autopilot (auto-stop on drain), Never-Stop, Continue, Capture, Stop (with "learning banking").
- Project brief: stack, commands, working dir, GitHub repo, "Don't" lists, persona, definition-of-done, gotchas.
- Analytics (completions, cycle time, worker performance) and a public credential profile showing aggregate stats, never task contents.
- Collaboration (teams/orgs, Viewer/Editor/Admin sharing); local↔cloud lossless switching, no-account onboarding.

## Gap analysis

**TaskPeace has, our designs lack (adopt candidates):** a first-class ranked-work
primitive (`Queue`/`Task`); a tiny standard agent-loop contract; interop-first
distribution that meets today's agents where they are; leasing as a named
concurrency primitive; an operational-loop vocabulary (Plan/Autopilot/…); product-
grade observability; a structured project-brief object.

**Our designs have, TaskPeace structurally lacks (the moat):** capability security
/ least authority ("capabilities are objects, not configurations"); structural
prompt-injection defense; distributed multi-party capabilities (CapTP/OCapN);
delegation, attenuation, and revocation with petnames; durable object-graph
persistence; hosting agent code under confinement (SES/XS). TaskPeace cannot add
these without becoming Endo.

## Recommended design directions (maintainer consideration)

Add a TaskPeace-shaped coordination layer *on top of* the ocap substrate — gain
the product surface without surrendering the moat:

- **D1** — a `Queue`/`Worklist` capability as a tenth Capability-Bank sibling; a guest gets a `Queue` object (`next()`/`complete()`/`defer()`) scoped to exactly the queue granted.
- **D2** — an agent-loop protocol over CapTP; **leasing as an expiring capability** (timer + attenuation) — the ocap-native answer to task-leasing and the garden's push-CAS.
- **D3** — an MCP↔Endo bridge exposing `get_next_task`/`complete_task` backed by the `Queue` capability, so today's agents pull from an Endo-hosted, confined queue. The literal product face of "Endo *but for bots*."
- **D4** — project brief as an authority bundle (working-dir → `Directory`, commands → scoped `Shell`, persona → persona category), not a config blob.
- **D5** — human priority as a multi-facet Exo split: human holds prioritize/reorder, guests hold only next/complete.
- **D6** — observability projected from the capability bus (every `next`/`complete` is already a self-addressed message).
- **D7** — local-first now, OCapN-federated team queues later (strictly stronger than a shared cloud KV plus role tiers).
- **D8** — borrow the operational-loop vocabulary as chat command-bar slash-commands.

## Strategic read

TaskPeace is strong external validation of the endo-but-for-bots thesis and of the
garden's own job board — the ranked-queue + agent-loop + human-priority + leasing
pattern, shipped commercially. Press our advantage exactly where TaskPeace is
empty: capability security, confinement, delegation/revocation, distributed
multi-party operation.

Source: maintainer issue [kriskowal/garden#30](https://github.com/kriskowal/garden/issues/30); TaskPeace marketing site fetched 2026-07-07; garden library topics `daemon`, `capability-security`, and the endo-but-for-bots `daemon-capability-bank` / `daemon-agent-tools` / chat / capability-bus design ingests.
