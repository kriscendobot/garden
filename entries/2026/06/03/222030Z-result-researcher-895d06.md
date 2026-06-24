---
ts: 2026-06-03T22:20:30Z
kind: result
role: researcher
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/researcher--895d06
short_id: 895d06
to: "*"
refs:
  - entries/2026/06/03/050900Z-result-builder-57e6ca.md
  - entries/2026/06/02/051648Z-result-builder-c592cb.md
  - entries/2026/06/03/040808Z-result-builder-a81757.md
---

# result: researcher — Phase 11b builder prompt refinement (CAS-fetch for Host-header weblets)

The proposed builder dispatch implements Phase 11b of the
`@endo/gateway` stack on `endojs/endo-but-for-bots#343`: replace
the Phase 11a 501-with-`X-Endo-Weblet-Formula` placeholder with a
real CAS-fetch path that resolves a weblet formula's
`contentRoot`, walks it for the request's path-suffix, honors
optional `mimeTypes` / `ssrHandler`, and streams bytes to the
response with ETag (the CAS hash) and Cache-Control set
appropriately. The refinement below grounds the prompt's load-
bearing terms in the journal library and the project's recent
builder-result trail, names the four sister designs that
constrain the slice, and surfaces the four design entities that
are load-bearing in 11b but absent from the keyword index as
*Open questions* for the librarian to grow.

```markdown
## Library and project references

**Library concepts and sections**

- [`journal/library/sections/endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision.md`](../../library/sections/endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision.md) — the parent design naming Host-header virtual-host routing, `<weblet-id>.localhost` form, `Map<hostname, {respond, connect}>` shape, and the *Not implemented* enumeration that places Phase 11b's daemon-side serve in scope.
- [`journal/library/sections/endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon.md`](../../library/sections/endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon.md) — the dual-purpose listener discipline (WebSocket at `/` + HTTP for weblet virtual hosts); Phase 11b lands the second half of that dual purpose.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md`](../../library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md) — the canonical CAS verb table (`cas-store` / `cas-fetch` / `cas-has`) plus the streaming variants (`cas-store-stream` / `cas-content-stream`) and the four content types (`blob` / `snapshot` / `tree` / `archive`). Phase 11b's "content-tree walk + stream bytes from CAS" is the `tree` + `blob` path with `cas-content-stream` framing.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md`](../../library/sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md) — the `readable-tree` / `readable-blob` formula types whose `content` hashes the gateway dereferences; the sweep-time refcount that lets the gateway hold a reference for the duration of a request without a persistent counter.
- [`journal/library/sections/endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule.md`](../../library/sections/endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule.md) — the `ui: {entry, assets, sandbox, bridge}` manifest the weblet's `contentRoot` is an instance of; `assets` is the `readable-tree` Phase 11b walks; `entry` is the default `index.html` for the bare-root request.
- [`journal/library/topics/daemon.md`](../../library/topics/daemon.md) — table-of-contents for every daemon-side design ingested; sister designs row by row include `cas-management`, `content-store-gc`, `familiar-gateway-migration`, `familiar-unified-weblet-server`, `familiar-app-ui-hosting`.

**Project context** (project: endo-but-for-bots)

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Rules of engagement — implementation lands on `master`, not on `llm`; the stack here is on `master` (the `design/gateway-package-phase-N` branches stack against `master`). The 11b PR base is the Phase 11a head per the stacked-PR convention.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Standing authorizations — repo-scoped relaxation: posting comments, reviews, reactjis, and cross-references on `endojs/endo-but-for-bots` does not need per-action authorization in the dispatch prompt. Force-pushes to protected branches still do.
- [`journal/entries/2026/06/03/050900Z-result-builder-57e6ca.md`](../050900Z-result-builder-57e6ca.md) — Phase 11a result: names the exact placeholder Phase 11b replaces (the Host-header branch returning 501 + `X-Endo-Weblet-Formula`), the listener's bind/upgrade plumbing, and the open-coded follow-on bullet "AppsNameHub host-header lookup actually serves the weblet contentRoot from the daemon's CAS (or the user daemon's SSR handler on a miss). Needs the `UserDaemon.fetchContentTree` exo and the daemon-side CAS wire."
- [`journal/entries/2026/06/02/051648Z-result-builder-c592cb.md`](../../02/051648Z-result-builder-c592cb.md) — Phase 7 result: the canonical `WebletFormula` typedef shape Phase 11b consumes — `{type: 'weblet', contentRoot, mimeTypes?, ssrHandler?, virtualHosts?}` — plus `validateWebletFormula` already in `packages/gateway/src/apps-formula.js`. Phase 11b reuses the validator; it does not redefine the typedef.
- [`journal/entries/2026/06/03/040808Z-result-builder-a81757.md`](../040808Z-result-builder-a81757.md) — Phase 10 result: the `ForwardedRequest` typedef shape (`{callerIp, scheme, host, trusted}`), the `logWarning` power that lets warnings stay testable under SES, and the `@import` typedef-in-`src/types.d.ts` discipline Phase 11b extends.
- Project design (read from the project worktree): `designs/gateway-package.md` on the `master` branch — the canonical design driving the whole stack. Not ingested into the library yet; the gateway-phase result entries above are the closest journal proxy.
- Project design (read from the project worktree): `designs/familiar-unified-weblet-server.md` on the `llm` branch — the section sister design ingested above is summarized from this file; the daemon-side gaps the design enumerates are what Phase 11b chips away at.
- Project design (read from the project worktree): `designs/daemon-cas-management.md` on the `llm` branch — phases 1-4 are implemented in `rust/endo/src/cas.rs`; the gateway-side consumer sees the envelope-bus verbs only.

**Why each reference is relevant**

- *familiar-unified-weblet-server section* — names the exact mechanism Phase 11b implements: HTTP request demuxed by Host header to a per-weblet handler. Phase 11a wired the demux; Phase 11b's `serveWeblet` power is the handler body for the "match" branch.
- *familiar-gateway-migration section* — the listener is dual-purpose by design; Phase 11b makes the HTTP half real where the WS half already serves CapTP.
- *daemon-cas-management section* — names the CAS verb table the daemon-side `serveWeblet` implementation walks. The gateway-side power signature (`{formula, pathSuffix}` → stream + metadata) is the right shape because the supervisor owns the CAS per the section's *supervisor-owned-vs-worker-owned* discipline.
- *daemon-content-store-gc section* — the `readable-tree` / `readable-blob` formula types are the `contentRoot` substrate; their `content` hashes are what `cas-fetch` keys on; the hash IS the ETag.
- *familiar-app-ui-hosting section* — names the `ui: {entry, assets, sandbox, bridge}` manifest shape; `assets` is the `readable-tree`; tells Phase 11b what a sensible default-`Content-Type` policy looks like (the *isolated* tier is the relevant baseline for the bare CAS-fetch path).
- *daemon topic page* — quick-jump to sibling designs Phase 11b touches; useful as the "next design to check when a question crosses files".
- *project README rules of engagement* — confirms the stacked-PR convention (base = Phase 11a head); confirms 11b lands on `master`, not `llm`.
- *project README standing authorizations* — confirms the dispatch's commenting authorization is implicit on this repo; no per-action authorization needed in the prompt.
- *Phase 11a builder result* — the exact placeholder code Phase 11b replaces; names the daemon-side capability the dispatch's `serveWeblet` invocation should target (`UserDaemon.fetchContentTree`).
- *Phase 7 builder result* — the `WebletFormula` typedef shape is already validated gateway-side; do not redefine, import + reuse.
- *Phase 10 builder result* — the `ForwardedRequest`, `logWarning`, `@import`-typedef-discipline carry-forwards are real; the prompt names them but the canonical shape is here.

**Open questions** (library gaps surfaced by this engagement)

- `designs/gateway-package.md` is not yet a library source page. Every gateway-phase dispatch reads it; the journal proxies it through the per-phase result entries. A librarian or scholar ingest would compress the chain. The dispatching liaison should not block on this; Phase 11b reads the design from the project worktree directly.
- `WebletFormula` typedef and `validateWebletFormula` validator are load-bearing for Phase 11b but absent from `journal/library/keywords.md`. The Phase 7 result entry is the canonical shape; a *Library writeback* shortcut keying `WebletFormula` → a future concept page is the right next step once a sister phase adds the daemon-side adapter and the page is worth drafting.
- `UserDaemon.fetchContentTree` is named in the Phase 11a result entry's "what's next" but the exo itself has no library coverage. The daemon-side exo is the dispatching liaison's contract surface; without it Phase 11b cannot terminate. The dispatch should either (a) confirm `fetchContentTree` exists on the daemon today, or (b) explicitly scope Phase 11b to the gateway-side `serveWeblet` shape with the daemon side as a separate stacked PR.
- "Content-tree walk" semantics (how a path-suffix maps onto the flat-entries-map representation of a `tree`) are pinned in `daemon-cas-management` but not in `keywords.md`. The implementation will need to follow the `path/to/file` keys; the canonical mapping is in the ingested section.
```

## Library writeback

No keyword shortcuts added this engagement. All library lookups
either hit existing keyword entries (`weblet`, `gateway`,
`CAS`, `Host header`, `virtual host routing`) or hit no
keyword and *should not yet* be added (the four entities under
*Open questions* are load-bearing in active work but not yet at
the "stable enough for a concept page" threshold). The researcher
role's writeback discipline is satisfied by *not* over-eagerly
adding shortcuts that point at empty pages; the right move is to
surface the gap to the librarian, which the *Open questions* list
does.

No distractions pruned, no concept pages drafted. The proposed
prompt's terms either index cleanly or are correctly catalogued
as gaps in active material.

## Open questions

See the *Open questions* block in the fenced refinement above.
The four entries are:

1. No library source page for `designs/gateway-package.md`.
2. `WebletFormula` typedef + validator absent from `keywords.md`.
3. `UserDaemon.fetchContentTree` exo not yet in the library.
4. Content-tree walk semantics not in `keywords.md`.

All four are signals for the librarian or scholar; none block the
Phase 11b builder dispatch.

Self-improvement: nothing this time. The researcher role landed
2026-06-03 and this is among the first engagements; the role file
and the library-lookup procedure scoped the work cleanly to one
to three minutes of wall time, the *Open questions* shape held
for absent-but-load-bearing terms, and the *do not invent
citations* norm was honored (every cited path verified at
`journal/` HEAD).
