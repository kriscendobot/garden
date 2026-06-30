# Build — @endo/gateway Phase 1, Feature 2: virtual-host content-tree resolution + serving

**Repo:** `endojs/endo-but-for-bots` (bot direct push; bot identity). Open a DRAFT PR
**base `llm`**, targeting the `packages/gateway/` package landed by #343
(merge commit `21d2f28f2c7a343ff2f71df00dddfc95dff35e78`). Scope: bot fork only; no
upstream-of-endo contact.

**Grounding:** the merged design `designs/gateway-package.md` — **§ Feature 2: Virtual
hosting (Host header → Weblet formula)** (the increment is marked **"Phase 1"**) and
**§ Phased Implementation → Phase 1** ("land feature 2 (virtual hosting via `@apps`
NameHub)"). Read those sections first; they are the spec.

**Where things stand (the #343 skeleton):** `packages/gateway/src/vhost.js` already
implements the in-memory `AppsNameHub` routing table (`bind`/`unbind`/`list`/`lookup`/
`has`, with `normalizeVirtualHostName`), and `types.d.ts` declares `AppsNameHub` /
`VirtualHostEntry`. The skeleton's own header comment names the gap: *"The phase-1
skeleton holds only the in-memory map; the design's Weblet formula resolution and
content-tree serving are follow-on work."* This job is that follow-on.

**Build (the Feature 2 content-tree resolution path, design § Feature 2 steps 1–5):**
1. Introduce the **`WebletFormula`** type (design § Feature 2): `{ type: 'weblet';
   contentRoot: FormulaIdentifier; mimeTypes?: Record<string,string>;
   ssrHandler?: FormulaIdentifier; virtualHosts?: ReadonlyArray<string> }`. Add it to
   `types.d.ts`.
2. Implement the **resolution path**: given an inbound `Host: <webletFormulaId>`, look the
   identifier up in the `AppsNameHub` table → `webletFormulaId` → resolve the weblet
   formula → resolve a request path (e.g. `index.html`) against
   `webletFormula.contentRoot` (a content-addressed `readable-tree` per
   `designs/daemon-weblet-application.md`) → return the bytes with `mimeTypes` overrides
   applied and otherwise inferred. Hold a **CAS cache** keyed by content address (the
   design's cache-hit / cache-miss path); on miss, fetch the content tree and populate it.
3. Keep it **powers-injected and testable without a live network/daemon**: the skeleton's
   `GatewayPowers` is `{ env }` only — extend the powers shape minimally (a formula
   resolver / content-tree reader capability) so the resolution path can be unit-tested
   against an in-memory fake, mirroring how `vhost.test.js` / `config.test.js` already
   exercise the package. Do **not** stand up real sockets in this increment.

**Out of scope (explicitly deferred — do not pull in):**
- The **SSR dynamic-fallback handler** (`ssrHandler` → `UserDaemon.handleHttp`): that exo
  is defined under **Feature 4 (UDS bootstrap), Phase 2**. Wire the static-CAS-first path
  and leave a clean seam (a no-op / not-yet-wired branch) for the SSR miss case; do not
  implement the CapTP forward here.
- Feature 8 (`/ocapn-cbor-np` WebSocket subprotocol) — a separate Phase-1 increment; post
  it as its own build job if you want it, but keep this PR to Feature 2.
- Wiring the daemon's existing `@apps` formula to import `@endo/gateway` — that is the
  Phase-1 integration step; keep this PR package-local unless it is trivially clean.

**Quality bar:** `@ts-check` clean; hardened exos (`makeExo` + `M.interface`) consistent
with `index.js` / `vhost.js`; new tests under `packages/gateway/test/` covering hit, miss
(cache populate), MIME override vs inference, unknown-Host 404, and a bound-vs-unbound
lookup. Run the package's lint + tests (and the repo's pre-PR gates) before opening. Add a
changeset. The DRAFT PR then runs the normal gamut (cleaner → judge → fixer-loop →
un-draft) as a separate concern.

**Report:** the opened PR number/URL and head SHA, plus a one-line note of what landed vs.
what was left as the named follow-on seams (SSR, Feature 8, daemon wiring).
