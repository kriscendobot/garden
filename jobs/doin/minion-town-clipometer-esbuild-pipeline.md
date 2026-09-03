---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-03T06:55:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
project: minion-town
orchestration: minion-town-clipometer-esbuild-orchestration (child 1 of 4, serial)

Build an esbuild-based pipeline that produces CLIPOMETER's browser `app.js` from real `@endo/captp` (a stock npm package) instead of a hand-rolled CapTP-lite client, tree-shaken to a workable size. Maintainer directive (dckc), 2026-09-03: *"it's troubling that clip sites are not using the Endo libraries to communicate with their back plane."*

## Why this exists, and the precedent already in this repo

A prior engagement hand-rolled a narrow CapTP client directly in a clip's `app.js` (published as the CLIPOMETER visit-counter demo, and written up as `designs/clip-ocap-synthesis.md`'s companion primer chapter "Bridging the MCP Gap") specifically because pulling in the full `@endo/captp` library felt too heavy to hand-transcribe into an MCP `publish` call's inline base64. That reasoning is now suspect on two counts the maintainer wants closed: (1) hand-rolling a wire protocol by re-deriving it from source is exactly the kind of thing that should instead depend on the real, tested library; (2) this repo **already has the faithful-port precedent to follow** — `src/endo/captp-client.ts` (tested by `test/endo-captp-client.test.ts`) wires up real `@endo/captp` + `@endo/eventual-send` against this exact daemon's CapTP dialect, at the exact pinned commit (`f66505034aaa54ac46294347b2bf0e14655b088a`, `endojs/endo-but-for-bots` @ `llm`), with versions pinned to what that commit's own lockfile resolves: `@endo/captp` **4.5.1**, `@endo/eventual-send` **1.5.0**, `@endo/init` **1.1.13** (both confirmed still resolvable on the public npm registry as of this writing). Read that module's header comment in full — its PROVENANCE / TRANSPLANT DISCIPLINE / SES-REQUIRED-AT-ENTRY sections are exactly the discipline to carry into this new artifact, adapted for a different transport.

**The transport differs, and that's fine.** `captp-client.ts` speaks netstring-over-Unix-socket (the daemon's own admin transport). A clip's `back` capability is reached over `/.well-known/endo-captp`, a WebSocket carrying one JSON CapTP message per frame — no netstring framing needed at all, which makes the browser wiring *simpler* than the server one: `makeCapTP(name, (msg) => ws.send(JSON.stringify(msg)), bootstrap)` with `ws.onmessage` calling `dispatch(JSON.parse(event.data))` is the whole transport layer. `makeCapTP` itself is transport-agnostic; only the send/dispatch plumbing changes.

**SES is not optional.** `@endo/captp` is HardenedJS code and only functions after `lockdown()` has run — `captp-client.ts`'s header is explicit about this. A browser bundle must therefore also bundle `ses` (or `@endo/init`) and call `lockdown()` before touching `@endo/captp`. This is real, non-trivial bundle weight and is exactly the size pressure the maintainer anticipated; tree-shaking with esbuild is what makes this tractable, but budget for `ses` itself not shrinking much (it's a hardening shim, not much to shake).

**`@endo/exo-stream` is NOT published to npm** (`npm view @endo/exo-stream version` returns a 404 as of this writing, confirmed while scoping this job — `@endo/captp` and `@endo/eventual-send` both resolve fine). CLIPOMETER's live-push subscription depends on `followNameChanges()`'s Reader protocol, whose real client-side algorithm lives at `packages/exo-stream/iterate-reader.js` in the pinned commit but has no npm package to depend on. Two paths, both worth trying and reporting on:
1. Vendor a small, faithful, PROVENANCE-commented port of `iterate-reader.js` (the pattern `captp-client.ts` already models for its own trimmed pieces) — the most likely to actually work with esbuild's normal resolution.
2. Try a git-URL dependency pinned at the exact commit (`"@endo/exo-stream": "github:endojs/endo-but-for-bots#f66505034aaa54ac46294347b2bf0e14655b088a"` with a subdirectory reference, or a monorepo subpackage install) and see whether esbuild can actually resolve and bundle it given Endo's yarn-workspace `workspace:` cross-deps — this may simply not work cleanly; if so, that's a concrete, reportable finding for the issue in child 4, not a blocker to route around silently.

## What to build

1. A new package/directory in this repo (pick a location; `deploy/thunks/siwe/`'s shape — its own `package.json` with a `bundle` script running `esbuild <entry> --bundle --outfile=<dist>` — is the closest existing convention, adapted with `--platform=browser --format=iife` or `esm` instead of `--platform=node --format=cjs`, and note it's a browser artifact, not a Lambda thunk, so name/organize accordingly).
2. A TypeScript/JS entry point that is functionally CLIPOMETER's `app.js`: on load, bootstrap the clip's own `back` (an `EndoDirectory` holding the visit count), read+increment+write the count, then `followNameChanges()`-subscribe so every other open window updates live — same behavior as today's hand-rolled version, built on real `@endo/captp` (+ the exo-stream piece above) instead.
3. Tree-shake with esbuild (`--minify`, `--tree-shaking=true` is esbuild's default for ESM but confirm it's actually eliminating dead code from `@endo/captp`'s surface you don't use — `Trap`, GC, general remotable-export machinery this narrow consumer doesn't need) to get the bundle to a size that's actually practical to `publish` (see child 2 for how publishing should work — this is no longer a hand-transcription problem, see below).
4. **A programmatic build+publish path, so no human ever hand-transcribes the bundle's bytes into an MCP tool call again.** This is the load-bearing fix for the transcription-corruption risk the primer documents (a real incident this session, caught only by a byte-diff verify step). `DEPLOYMENT.md` § "Automated MCP verification (client credentials)" already documents a non-interactive path — a bearer token over Streamable HTTP directly to `https://minion.town/mcp`, no browser/PKCE/human login needed — build a small script (Node, using the built esbuild output directly, base64-encoding programmatically, never through a human) that drives `publish`/`upgrade` over that same path. This script is itself a first-class deliverable, not just internal tooling for this one job: it's what child 2 and any future clip-authoring engagement should use instead of hand-retyping base64 into a chat tool call.

## Deliverable

A draft PR with: the esbuild pipeline, the rebuilt `app.js` (CLIPOMETER's exact existing `index.html`/`styles.css` unchanged — only the script changes), the programmatic build+publish script, and a short note on which `@endo/exo-stream` path (vendor vs. git dependency) you took and why. Do not publish anything from this job — that's child 2, so the live validation step is independently checkable against what this PR actually produced.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T06:55:20Z
