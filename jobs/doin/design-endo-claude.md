---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design an `@endo/claude` package: an Endo package that provides LLM inference for
an Endo guest **from a Claude subscription**, via a hermetically-sandboxed
`claude -p` (or the Claude Agent SDK) invocation whose *only* capability surface
is the Endo tool call surface for one specified guest formula identifier.
Maintainer request, 2026-08-15/16, liaison conversation.

## Direction of dependency — read this before drafting

This is the **inverse** of the existing design of record. Two designs already
live in `kriscendobot/minion.town` @ `main`:

- [`designs/mcp-endo-guest.md`](https://github.com/kriscendobot/minion.town/blob/main/designs/mcp-endo-guest.md)
  — Claude (claude.ai / Claude Code, as a hosted product) is an **MCP client**
  that connects **out** to minion.town's `/mcp` resource server over OAuth 2.1
  PKCE, and the app resolves the caller's `iss+sub` to `provideGuest` a per-user
  Endo guest and exposes that guest's granted facet as MCP tools. Claude drives
  the guest from outside.
- [`designs/mcp-daemon-guest-tools.md`](https://github.com/kriscendobot/minion.town/blob/main/designs/mcp-daemon-guest-tools.md)
  — the build-organizing successor that wires the toy MCP tool server to the
  real daemon guest's facet.

`@endo/claude` is the **opposite direction**: the Endo guest (or something
provisioning/operating on its behalf) gets Claude as its **inference engine** —
`claude -p` running *inside* the sandbox, with the guest's own granted
capabilities injected as its MCP tool surface, and nothing else. This is "the
guest thinks with Claude," not "Claude drives a guest from outside." Cite both
designs as companions and be explicit about the direction distinction in your
own design's header — don't let a reader conflate the two.

## What "bare and only the Endo tool call surface" means, concretely

This conversation independently verified (against current Claude Code CLI docs,
not general impression) the exact mechanics needed to make this hermetic. Ground
the design in these confirmed facts rather than re-deriving them:

- **`--bare` is load-bearing, not optional.** Tool-permission flags
  (`--allowedTools`/`--disallowedTools`/`--permission-mode`) do **not** suppress
  CLAUDE.md loading, hooks, settings auto-discovery, or MCP auto-discovery —
  those load unconditionally at startup, before/outside the tool-permission
  system. Only `--bare` skips all of them in one shot. Denying the `Read` tool
  does not stop the initial CLAUDE.md load. A `claude -p` invocation that omits
  `--bare` is not actually sandboxed no matter how restrictive its
  `--allowedTools` is.
- **`--strict-mcp-config <file>`** so the injected Endo MCP endpoint is the
  *only* MCP server the process sees — otherwise `.mcp.json`/`~/.claude/`
  auto-discovery can add servers you did not intend to expose.
- **`--setting-sources ""`** to drop user/project/local settings.json layers
  (flag as open: whether *managed* settings can be suppressed at all is
  undocumented — treat as "assume they cannot" until verified against a real
  managed-settings deployment).
- **Never `--resume`/`--continue` a sandboxed invocation.** Both restore the
  *full* prior transcript — including past tool calls and results — with no
  documented way to filter what's restored, regardless of the new invocation's
  own tool-permission flags. Each guest-inference call should be a fresh
  process; if turn-to-turn memory is needed, that's Endo's job (the guest's own
  state, or something the tool surface exposes), not the harness's.
- **Tool gating**: deny every built-in (`--disallowedTools "*"` or an empty
  built-in allow set) plus a deny-by-default permission mode, then
  `--allowedTools` naming only the exact `mcp__<endo-mcp-server>__<tool>`
  entries the guest's granted facet exposes. **`mcp__*` does not work as an
  allow-rule wildcard** — confirmed: allow rules require a literal
  `mcp__<server>__` prefix before any glob; an unanchored `mcp__*` allow
  pattern is silently skipped with a warning and grants nothing (it *does* work
  for deny/ask rules, which is the opposite of what's needed here). So the
  allowed-tool list has to be generated per-guest from that guest's actual
  granted facet, not hand-wildcarded — name this as a concrete implementation
  requirement (a "compose the allow-list from the facet's method set" step),
  not just a caveat.

## The local/remote Endo MCP question

No `@endo/mcp` package exists yet as of either minion.town design's "grounded
against" section — the guest-facing MCP tool server is currently bespoke code in
`kriscendobot/minion.town`'s `src/server.ts`/`src/http.ts`, talking CapTP over
netstrings to the daemon over a Unix domain socket
(`/run/endo-daemon/endo.sock`, per `deploy/aws/systemd/endo-daemon.service` in
`mcp-endo-guest.md` § 4.1). Address this sequencing explicitly as an open
question: does `@endo/claude` depend on a not-yet-built `@endo/mcp`, or does it
need to carry (or compose with) a minimal guest-facet-to-MCP bridge itself for
the local/loopback case — and if the latter, is that bridge in scope for this
design or a named prerequisite dependency?

Cover both deployment shapes named in the mandate:
- **Local**: an Endo MCP server on the same host as the `claude -p` process,
  bound to loopback (`127.0.0.1`, explicitly **not** `0.0.0.0`) on a port, or a
  Unix domain socket — either way, not reachable off-box.
- **Remote**: the Endo MCP endpoint lives elsewhere (e.g. the minion.town
  deployment topology today), reached over whatever transport `@endo/mcp`
  eventually specifies (the existing designs lean CapTP-over-Noise for
  daemon-to-daemon and OAuth2.1/Bearer for the browser-facing MCP surface —
  don't assume either applies unchanged to a machine-to-machine `claude -p`
  client; name what transport/auth a non-human MCP client actually needs).

## Multiplexing by guest identifier and pooling Claude subscriptions

The deployment target named in the mandate is minion.town-shaped: a local MCP
stood up per host, loopback-only, multiplexed by guest identifier, so **one or
more Claude subscriptions can be pooled across concurrently-running guest
agents**. Design the allocation/pooling story explicitly:

- How a `claude -p` invocation for guest `g-4f2a…` gets routed to *that* guest's
  facet specifically and no other's — a port-per-guest, a path/argument
  discriminator on one MCP endpoint, or a socket-per-guest scheme (the existing
  daemon already speaks CapTP per-guest over one shared socket; decide whether
  the MCP-facing layer should preserve that one-socket-many-guests shape or
  fan out to one MCP listener per guest).
- How multiple Claude subscriptions (credentials/accounts) get allocated across
  concurrent guest-inference runs so no single account's weekly quota gates
  every guest. **This garden is a working existence proof of the pooling
  problem, not the sandboxing problem**: it runs Claude-backed workers
  ("gardener"/monk-kind, provider `anthropic`) pooled across two Max 20x
  accounts on two hosts, with per-host worker counts declared in journal state
  (`hosts/<host>` file, `gardeners: N`) and rebalanced by hand when one
  account's weekly-quota burn rate outpaces the other's (done today, 2026-08-15:
  `scripts/jobs/set-workers.sh gardener 2` locally, a sysop `set-workers` op to
  the peer host). That mechanism is a useful analogy for "N accounts, M
  concurrent consumers, keep utilization roughly level" — but the garden's own
  workers run with full host tool access, not the sandboxed Endo-only surface
  this design requires, so borrow the allocation *pattern*, not the isolation
  model.

## Deliverable

A `designs/endo-claude.md` in `endojs/endo-but-for-bots` (the project this
`@endo/*` package belongs to; "Endo-side changes target endojs/endo-but-for-bots
@ llm" per the maintainer's direction of record in `mcp-endo-guest.md`), draft PR
against `llm`, following that project's design conventions and this garden's
`roles/designer/AGENT.md` norms (mermaid diagrams for the architecture/sequence,
cite the two minion.town designs as companions by full URL, convert any relative
dates, surface genuine ambiguity as `## Open questions` rather than guessing).
If the design concludes a minion.town-side deployment/configuration companion
doc is also warranted (the precedent: `mcp-endo-guest.md`/`mcp-daemon-guest-tools.md`
live in minion.town, not endo-but-for-bots, because minion.town is "a deployment
+ configuration layer, not a code home"), name that as a follow-on design job
rather than trying to write both in one pass.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-16T05:45:54Z
