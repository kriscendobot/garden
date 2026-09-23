---
ts: 2026-05-29T15:19:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/designer--d77cfc
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
refs:
  - entries/2026/05/29/150500Z-dispatch-steward-d2e3f4.md
  - https://github.com/endojs/endo-but-for-bots/pull/343
---

# result: designer — kriskowal CHANGES_REQUESTED on #343 addressed

Addressed kriskowal's 2026-05-29T14:21:49Z `CHANGES_REQUESTED` review on PR #343 (`design(gateway): overarching @endo/gateway package`). Two inline comments, both treated substantively as two separate commits.

## Push

New head: `5ada59b4f586ec9d0858bd0b8bd2de1b64aa27ac` (pushed to `endojs/endo-but-for-bots:design/gateway-package`).

Two commits added on top of the 2026-05-23 PR tip:

- `adafd6f59` — `design(gateway): fold endo-gateway material into gateway-package and remove (#343)` (4 files, +401/-1076).
- `5ada59b4f` — `design(gateway): add @endo/platform/ws forward-pointer placeholder (#343)` (1 file, +23).

Started from local 41b1d400f, fetched origin (which was at e8d2aa445, four commits ahead from the post-fixer panel cleanup round). Reset to origin and based both new commits on e8d2aa445. No rebase conflicts; clean ff push.

## Edited sections mapped to comment IDs

### Comment 3324924389 (designs/endo-gateway.md:1)

> "Please review this old design for material worth bringing forward to the new design. Then, we should simply remove this document and direct references to the new design."

Reviewed the prior `endo-gateway.md` against `gateway-package.md` and identified four substantive gaps to bring forward, plus three open questions and eight dependency rows. Folded into `designs/gateway-package.md`:

| Material brought forward | Where it lives now in `gateway-package.md` |
|---|---|
| Boot order / teardown / restart semantics / liveness (30s heartbeat, three-missed-prune, CapTP `__getMethodNames__` reuse) | New `## Lifecycle` section (between `## Bind Shape` and `## Cross-platform service shape`) |
| systemd / launchd / Windows SCM / container-runtime / Electron-main service-manager model | New `## Cross-platform service shape` section |
| Detailed `Registrar.register({ publicKey, proofOfPossession, daemon })`, `Registration.publishWeblet`/`addPublicKey`/`unpublishWeblet`/`deregister`, callback `UserDaemon` exo (`handleHttp`, `handleWebSocketUpgrade`, `fetchContentTree`) | Expanded Feature 4 (three new `#### `-level subsections: `GatewayBootstrap`, `Registration`, `UserDaemon`, plus `#### Proof-of-possession nonce shape`) |
| Per-platform Familiar packaging impact (macOS LaunchDaemon, Linux systemd unit handling for AppImage vs deb/rpm, Windows Service via sc.exe, "Familiar detects system gateway at startup, falls back to bundled otherwise" pattern, Electron-no-SES-in-main-process constraint) | New `#### Familiar app packaging impact` subsection under Feature 5 |
| Cross-host policy file (Open Question) | New Open Question 8 |
| Daemon-hosting service mode (virtual users) (Open Question) | New Open Question 9 |
| Host-scoped CAS write-path variant of daemon-checkin-checkout (Open Question) | New Open Question 10 |
| Pass-Invariant-Eq rotation mechanics detail | Expanded Open Question 4 |
| Eight new Dependencies rows: `daemon-docker-selfhost`, `daemon-cas-management`, `daemon-message-streaming`, `daemon-endo-rust-sqlite`, `daemon-checkin-checkout`, `daemon-agent-network-identity`, `exo-zip-package`, `packages/where` | Dependencies table extended |

The carried-forward decisions named in `endo-gateway`'s own supersession note (no TLS, Noise in-band, `@apps` NameHub, distinct config trees, IPC for local-vs-remote, deferred key rotation) were already present in `gateway-package.md`'s introduction; the consolidation does not re-litigate them.

### Comment 3324935450 (designs/gateway-package.md:123, WebSocket-server bullet)

> "Dispatch a designer to factor WebSocket powers out into a platform-agnostic `@endo/platform/ws` module so we can straddle browser, node, endor with conditional imports."

Per the dispatch's preferred handling: added a placeholder forward-pointer subsection rather than chaining the `@endo/platform/ws` designer dispatch. The new `### Planned @endo/platform/ws factoring (forward-pointer)` subsection under `## Package Shape` names:

- The current Node-specific WebSocket dependency (`@endo/ws-relay` wrapping Node `http.Server` + `ws` package).
- The package will consume WebSocket capability rather than implementing it; `make({ ... })` will accept a `wsPlatform` power supplied by the embedder.
- Conditional-import variants for Node, browser, Endor.
- The actual `@endo/platform/ws` design lands in a separate designer dispatch; the slug is referenced from the Dependencies table once fixed.
- Phase-1 builder plans the abstraction boundary up front so the package's own code calls only into the platform-agnostic interface.

## Reference updates

- `designs/endo-gateway.md` removed (1011-line deletion).
- `designs/README.md` updated:
  - "Last updated" header refreshed to 2026-05-29 with the removal note.
  - "Recently added or revised" section reframed (gateway-package row marks 2026-05-29 absorption; the standalone endo-gateway row dropped).
  - Summary table: dropped the `endo-gateway` row; gateway-package row updated with `Updated` = 2026-05-29 and a parenthetical note about the absorption.
  - Totals narrative refreshed: Superseded count 2 → 1; total designs 126 → 125; design-count drop documented inline.
  - Mermaid dependency graph: removed the `SUPERSEDED endo-gateway` node and the `egw --> gpkg` edge.
  - M1 § Remote Access & Tools table: dropped the endo-gateway row; gateway-package row's notes name the absorption.
  - Sizing table: dropped the endo-gateway row; gateway-package row's notes name the absorption.
  - M1 milestone-row design enumeration: replaced `endo-gateway` with `gateway-package` (row count stays 10).
- `designs/forge-gap-analysis.md`: two `endo-gateway.md` markdown references re-targeted to `gateway-package.md`; reference list entry replaced.
- `designs/gateway-package.md` itself: every in-document `[endo-gateway](endo-gateway.md)` link replaced with plain-text "the superseded `endo-gateway` design" (or similar contextual phrasing); metadata `Supersedes` cell records the removal date; `Updated` field bumps to 2026-05-29.

Historical README narrative entries about prior reconciliation passes (lines that record what was added/removed at the time) were left intact since they accurately record their epoch.

Verified `git grep -l 'endo-gateway.md'` returns only `designs/forge-gap-analysis.md` (a plain-text retrospective reference, not a link).

## Inline reply IDs

- `3325268939` (on `3324924389`, posted at 2026-05-29T15:17:54Z, cites `adafd6f5`)
- `3325270172` (on `3324935450`, posted at 2026-05-29T15:18:08Z, cites `5ada59b4`)

## Top-level summary comment

ID: `4576840227` (https://github.com/endojs/endo-but-for-bots/pull/343#issuecomment-4576840227)

Maps both comments to commits, enumerates the material brought forward, lists reference updates, and names the net diff.

## Re-request review

POST `repos/endojs/endo-but-for-bots/pulls/343/requested_reviewers` with `{"reviewers":["kriskowal"]}` via `--input -` returned HTTP 201; kriskowal is now in `requested_reviewers`. Used the working JSON-body shape per the dispatch reminder.

## Recommendation: `@endo/platform/ws` designer follow-up

**Recommend** the steward dispatch a separate designer for `@endo/platform/ws`. The dispatch is independent of this PR's lifecycle (the forward-pointer placeholder lets `@endo/gateway` proceed without it); a parallel designer can produce the WebSocket-abstraction design while the gateway-package design continues through review.

Suggested dispatch shape for the steward:

- Role: designer.
- Repo: `endojs/endo-but-for-bots`, base branch `llm` (or current roadmap branch).
- Slug: `endo-platform-ws` (matches the `@endo/platform` family per existing `platform-fs` precedent on `llm`).
- Brief: factor the WebSocket powers `@endo/gateway` consumes into a platform-agnostic `@endo/platform/ws` module that supports Node (wrapping `ws` + `http.Server` per the current `@endo/ws-relay` shape), browser (wrapping the platform `WebSocket` API), and Endor (whatever the Endor runtime provides) via conditional imports. The output is a `make({ powers })` factory returning a hardened exo with the methods `@endo/gateway`'s `make({ ... })` calls into.
- Cross-reference: the forward-pointer subsection added in `5ada59b4` names the abstraction boundary; the new design pins what is on the gateway side vs. on the platform-ws side.
- Boatman ferry not needed; this is design-stage on the bot-fork roadmap branch per the designer role's default.

The maintainer's directive was "dispatch a designer" rather than "dispatch immediately"; the steward originates the dispatch when it surfaces from a tick, not the designer-on-#343.

## Notes

- The dispatch brief said the dispatch journal entry lives at `150500Z-dispatch-steward-d2e3f4.md` but that filename did not exist when I checked the journal; the most recent entry before my work was `144100Z-result-steward-c1d2e3.md`. I proceeded based on the dispatch prompt text rather than the journal entry; this `result` entry's `refs` lists the brief's stated path for traceability even though the file may not exist at the orchestrator's next scan. If the orchestrator's dispatch entry actually landed under a different timestamp, the steward can patch the `refs` field on close.
- The PR was OPEN (not DRAFT); no `gh pr ready` step needed. The maintainer un-drafted after the prior panel round.
- Both commits use the bot identity (kriscendobot) per the worktree's pinned config. No identity_switch_authorized in this dispatch; correct.
- The pre-PR checklist applies in spirit only since this is a design-only PR (no `yarn lint`, `yarn format`, `yarn docs`, or `npx ava` runs are meaningful for `.md` edits). I sanity-checked the markdown is well-formed and the cross-links resolve.

Self-improvement: nothing this time.
