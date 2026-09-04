---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Publish a minion.town clip chronicling what the garden achieved overnight (Pacific time — America/Los_Angeles, roughly 2026-09-03 21:00 to 2026-09-04 05:00 PDT / 2026-09-04 04:00-12:00 UTC). Maintainer directive to the liaison, 2026-09-04.

## Why you, not the liaison

The liaison attempted this directly (it holds working `mcp__minion-town__*` tool access for exactly this kind of thing — see the CLIPOMETER precedent in `journal/jobs/todo/groom-carve-mcp-bridge-milestone.md`) but every call (`status`, `list`) failed with `"No valid session; send initialize first."` — a broken/stale MCP session on that side, not a minion.town outage. Retry the same tools fresh from your own handler; they should work normally for you. If they don't, report that back rather than silently giving up (message `liaison` — see § Report below).

## What to publish

A single static HTML clip (no live `back` capability needed — this is read-only chronicle content) narrating, in a warm, readable voice (this is a public-facing minion.town clip, not an internal ops log), what the garden's fleet of autonomous agents actually shipped and fixed overnight. Ground every claim in something checkable (a PR URL, a commit SHA, a job basename) — do not invent detail.

**Starting facts (liaison-verified this session; confirm freshness before publishing — check `journal/jobs/tada/` and the linked URLs for anything that's moved since):**

1. **Fixed a real automation bug.** The PR-comment watcher was swallowing a maintainer's "Post a builder." directive when it arrived attached to an APPROVED code review — the watcher read the review purely as a merge signal and dropped the build request. Root-caused and a fix posted: `fix-comment-watcher-approve-review-swallows-directive` on the job board.
2. **Shipped `endojs/endo-but-for-bots#1125`** — a guest-owned Endo invitation primitive (an `EndoGuest` can now mint its own invitation, not just the top-level host), the first buildable step of the `remote-guest-endo-cli` design connecting a local Endo CLI to one minion.town guest.
3. **Posted the first real UI framework for minion.town** (`build-minion-town-clip-shell-framework`): a left-hand "gutter" of the user's clips borrowed from the `@endo/chat` app's spaces-gutter pattern, a `+` button that mints a new guest-powers-backed clip, the clip's content shown in an iframe on its own `*.ocap.site` origin, and — the interesting security-UX piece — a bottom-left settings/authentication button whose dialogs are drawn as a speech-bubble overlay in the page's own top-level document, specifically so a confined clip can never forge them. Mobile swaps the gutter for a horizontally-scrolling bottom bar, chosen by comparing the viewport's own width and height rather than a fixed breakpoint.
4. **Tightened a security-relevant design before it was built.** A queued build for giving every minion.town guest an indelible Claude-agent-spawning capability was narrowed, per maintainer direction, to one designated root account only — which then explicitly extends that capability to specific connected guests, rather than every new member getting it automatically. Caught and amended before any code shipped.
5. **Found and fixed a fleet-wide outage.** The journal's leadership marker pointed at a host that had gone offline, which silently stopped every fleet-coordination service (the job reaper, the autonomous work-pump, the PR/issue watchers, the dashboard) garden-wide. Traced several "did my request get lost?" reports back to this one root cause (compounded by an ongoing provider-side weekly usage cap), released the stranded work, and restored a live leader — reopening the pipe for everything that had backed up behind it.

## How to write it

- Title something like "Overnight in the garden" or similar — your call, keep it in voice with the rest of minion.town's public content.
- A short scene-setting opening sentence or two, then the concrete achievements as a readable narrative or list (your call on shape), each with its evidence link.
- No garden-internal jargon dump (job basenames, host identities, quota mechanics) in the main prose — those belong in a lighter "how it happened" aside if you want one, not the headline. The reader is anyone who visits minion.town, not a gardener.
- Reuse whatever visual/style convention the CLIPOMETER clip or other prior clips established, if you can find and read one via `listSites`/fetching an existing clip, so this doesn't look like a one-off snowflake.
- Implicit light/dark via `prefers-color-scheme` is a nice touch if it's cheap; not required.

## Publish

Use `mcp__minion-town__publish` with your own guest's powers (check `mcp__minion-town__list`/`has` for what you hold; a purely-informational clip can name any power you already hold — you do not need a live `back` capability for this content, but the tool requires naming one). Confirm `serving: true` in the result; if the gateway's live registry is unavailable (`serving: false`), say so plainly rather than reporting success.

## Report

Reply with the published clip's URL as a `message` on the bus addressed to `liaison` (`skills/message-bus/SKILL.md`) so it reaches the maintainer next session, and state it plainly in your tada completion report too.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T12:03:28Z
