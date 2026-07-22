---
model: fable
role: designer
---
# Organize the replacement of minion.town's toy MCP tools with real daemon-guest-backed tools

Maintainer directive (kriskowal, on kriskowal/garden#58, 2026-07-22): the
minion.town agenda "seems stalled. Please focus on replacing the toy MCP tools
with tools that call through to the associated daemon guest. Dispatch a Fable
designer to organize that effort." This is that Fable designer job (hence the
`model: fable` pin, overriding the designer role's Opus default per the explicit
directive).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-58
issue_url: https://github.com/kriskowal/garden/issues/58#issuecomment-5043060750
submitter: kriskowal
----- END ISSUE NOTE -----

## Project & delivery

- Project: `minion-town` (journal `projects/minion-town/README.md`). Repo:
  private `kriscendobot/minion.town`, deploys `main` to https://minion.town.
- **Design delivery is PR review** (maintainer directive 2026-07-10): land the
  design as a **draft PR** against `main` on `kriscendobot/minion.town` (the fork
  is watched — triager + CI draw review), NOT a direct commit. Match the repo's
  own design conventions (`# Design: <title>`, the bold
  `**Status:** / **Mandate:** / **Grounded against:** / **Companion:**` header
  block, numbered sections, validated mermaid), not the garden frontmatter.
- Suggested slug: `designs/mcp-daemon-guest-tools.md` (pick the final slug to
  match the anticipated `design/<slug>` branch). It is the **build-organizing
  successor** to `designs/mcp-endo-guest.md`; cross-link it and mark what it
  carries forward rather than duplicating prose.

## The concrete gap to organize (grounding — verify live before drafting)

- `src/server.ts` is self-described as "the toy MCP server": three tools
  (`minion_status`, `list_minions`, `summon_minion`) over **in-memory toy state**
  that exist only to demonstrate the scope→tool-authorization model
  (`src/auth/scopes.ts`, `designs/mcp-oauth.md`). None reach an Endo daemon.
- The daemon-guest machinery is **designed but unwired**: `designs/mcp-endo-guest.md`
  specifies the gated per-user guest chain; `src/endo/identity.ts` maps `iss+sub`
  → `g-<32hex>` guest pet name; `src/endo/root-control.ts` / `root-ctl.ts` are the
  out-of-band root admin surface. The **Gate-2 seam** — `endo-daemon.service` +
  the CapTP-over-UDS `RootHost` adapter (`root-host-socket`) — is explicitly
  NOT implemented yet (`root-ctl.ts` `connectRealRootControl` throws with that
  message). The deployed daemon topology remains box-local (`deploy/aws/daemon/README.md`).

## What the design must organize (not implement)

1. **The real tool surface.** How the MCP server exposes the *associated daemon
   guest's* tool-call surface (the guest agent's capabilities) instead of toy
   tools — per-request identity → `guestNameForIdentity(iss,sub)` → a guest
   far-reference → its exposed methods as MCP tools. Reconcile with the existing
   scope→tool authorization layer (does the guest cap boundary subsume or
   complement `mcp/*` scopes?).
2. **The app→daemon connection seam.** The CapTP-over-UDS bootstrap the app holds,
   `provideGuest`, and how a per-request tool call routes to the caller's guest.
   This is the Gate-2 work `mcp-endo-guest.md` deferred — sequence it concretely.
3. **Reusable-component boundary.** minion.town is deployment+config, not a code
   home; reusable pieces grow in `@endo/gateway` + `@endo/mcp` on
   `endojs/endo-but-for-bots @ llm` (kriskowal, closing endo-but-for-bots#134).
   The design says what lives in `@endo/*` vs. the minion.town config layer, and
   may use the permitted `minion-town` run-ahead branch of `endo-but-for-bots`.
4. **A build decomposition** a later builder (or an orchestration job) can execute
   from: ordered, testable increments (daemon standup → socket adapter → one real
   tool end-to-end → migrate remaining tools → retire the toy state), each with a
   validation hook against the deployed edge.

## Definition of done

- `designs/mcp-daemon-guest-tools.md` exists on a `design/<slug>` branch in
  `kriscendobot/minion.town`, a **draft PR** against `main` is open, its body
  citing https://github.com/kriskowal/garden/issues/58#issuecomment-5043060750.
- Open questions are explicit; the build decomposition is executable by a future
  builder without further design clarification, or the report flags the blockers.
- Report names the design slug and the PR number.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-22T07:28:08Z
