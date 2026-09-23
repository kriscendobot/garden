---
ts: 2026-05-22T20:44:02Z
kind: result
role: designer
worktree: dispatches/designer--8e9c43
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/203143Z-dispatch-liaison-8e9c43.md
---

# Result: designer 8e9c43 - endoclaw pinchtab plugin + coherent Browser Exo interfaces

## Deliverables

- **PR:** https://github.com/endojs/endo-but-for-bots/pull/359 (DRAFT,
  against `llm`).
- **Branch:** `design/endoclaw-pinchtab`.
- **Head SHA:** `1c1080133478f80056f1d84603294331259783e2`.
- **Design files:**
  - `designs/endoclaw-pinchtab.md`
  - `designs/endoclaw-browser-interfaces.md`
- **README sync:** summary row added for each, totals bumped from 104
  to 106 designs, dependency-graph edges (`endoclaw-browser-interfaces
  -> endoclaw-browser` and `-> endoclaw-pinchtab`), M5 milestone table
  rows, per-design size estimates (S 1 day for interfaces; M-L 1.5
  weeks for the pinchtab plugin), recent-additions header note,
  M5 item count `6 active -> 8 active`.
- **Library:** new `journal/library/concepts/pinchtab.md` concept page
  with eight keyword entries in `journal/library/keywords.md`
  (`pinchtab`, `PinchTab`, `PINCHTAB_TOKEN`, `pinchtab server`,
  `pinchtab bridge`, `accessibility tree with stable refs`,
  ``` `e0`, `e1` (PinchTab refs) ```, `Browser capability backend`).

## WebFetch findings on PinchTab (captured 2026-05-22)

- **Positioning.** A 12 MB MIT-licensed Go binary that runs Chrome and
  serves a plain HTTP API designed for low-token-cost agent
  automation. Source `github.com/pinchtab/pinchtab`. Claims ~10x token
  reduction vs full DOM snapshot via accessibility tree with stable
  refs (`e0, e1, ...`).
- **Wire protocol.** HTTP REST, JSON bodies. Two processes:
  `pinchtab server` (control plane, default port 9867) and one
  `pinchtab bridge` per Chrome instance (default port 9868+).
  Hierarchical addressing `{instanceId} -> {tabId}`. Mutations POST,
  reads GET. Representative endpoints: `POST /profiles`,
  `POST /instances/start`, `POST /instances/{id}/tabs/open`,
  `POST /tabs/{tabId}/action {kind, ref, ...}`,
  `GET /tabs/{tabId}/snapshot?filter=interactive`,
  `GET /tabs/{tabId}/text`, `GET /tabs/{tabId}/screenshot`,
  `GET /tabs/{tabId}/pdf`, `POST /tabs/{tabId}/eval` (optional).
- **Auth.** `Authorization: Bearer <PINCHTAB_TOKEN>`, sourced from env
  var at server start. **CVE-2026-33620** (v0.7.8 to v0.8.3) accepted
  the token from a URL query parameter; **fixed in v0.8.4**. Plugin
  pins `>= v0.8.4`.
- **Defaults / security.** Binds `127.0.0.1` only; non-local exposure
  is operator responsibility. Persistent profile directories
  ("treat as sensitive"). Stealth mode on by default
  (`navigator.webdriver` patched, UA spoofed).
- **Gaps / open questions.** No documented wire-protocol stability
  commitment; no rate-limit / quota documentation; pricing not
  surfaced (project is OSS); profile directory persistence location
  not documented; full multi-tab endpoint enumeration not surfaced
  on the public docs page. License is MIT. Captured these as design
  open questions rather than speculation.

## Unified-base `Browser` Exo proposal (summary)

**Base `Browser`:** `newPage(url) -> Page`, `backend() -> string`,
`allowedOrigins() -> string[]`, `help()`.

**Base `Page`:** `url`, `title`, `snapshot(options) -> SnapshotNode[]`
(default filter `interactive`, returns `{ref, role, name, value?,
checked?, disabled?, children?}`), `text({mode: 'readability'|'raw'})`,
`screenshot({fullPage?})`, `waitFor(target, {timeoutMs?})`,
`navigate('back'|'forward'|'reload')`, `goto(url)`, `close()`, plus
mutation methods `click | type | fill | press | select | scroll`
disabled by `setReadOnly(true)`. `PageTarget = {ref} | {role, name?,
nth?}` (ref-or-role addressing, ref tried first).

**Base `BrowserControl`:** `setAllowedOrigins`, `setReadOnly`,
`setMaxConcurrentPages`, `revoke`, `help`.

**Per-backend extensions:**

- `PlaywrightBrowser extends Browser`: `newPageOnEngine('chromium' |
  'firefox' | 'webkit', url)`, `setDefaultSelectorEngine('css' |
  'xpath' | 'text')`.
- `PinchTabBrowser extends Browser`: `setStealth(flag)`,
  `listProfiles()`.
- `EvalCapableBrowser extends Browser`: `eval(page, script)` (opt-in
  via `BrowserControl.setEvalAllowed(true)`; both backends can serve
  but it is a structural hole in the origin allowlist).

Mapping table in the doc covers every base method against both
backends; the two non-trivial mappings are PinchTab's
`click({role, name})` (resolved via cached snapshot) and PinchTab's
`waitFor` (polling on snapshot, not event-driven).

## Daemon-vs-Familiar placement decision

**Daemon.** The plugin owns one `pinchtab server` child process per
daemon and one `pinchtab bridge` instance per `Browser` capability.
Self-hosted (Docker) agents reach a headless daemon with no Electron
shell, so the Familiar cannot own the capability if it is to be
available across delivery modes. The daemon already supervises worker
subprocesses, so the lifecycle pattern is familiar. The Familiar may
grow a UX layer later (live-tabs panel, prompt-and-pin for new
origins) but the capability shape and process supervision live in the
daemon.

## `endoclaw-browser.md` revision recommendation

**Yes, revise.** As a separate follow-up PR (out of scope here per the
dispatch). Specifically: retitle to "(Playwright Backend)", replace
the `Capability Shape` section with a one-line reference to the
unified shape in `endoclaw-browser-interfaces.md`, keep `How It Works`
and `Endo Idiom` (still Playwright-specific), add a one-section
mapping reference. Rationale: both backend designs are unimplemented,
so the unified shape can be the implementation contract from the start
at zero ripple cost; a single PR doing two siblings *plus* an
editorial edit on a third file would be noisier to review than two
PRs; keeping the editorial revision as its own PR lets the maintainer
accept the unified-shape proposal without committing to the editorial
shape of the Playwright doc.

## Open questions surfaced

- pinchtab: multi-tab grant cap; profile sharing across capabilities;
  stealth default (per-makeBrowser or per-control?); PinchTab wire
  stability and version pin; whether the attach-to-running-Chrome debug
  mode is exposed as a formula or CLI-only; token rotation; PinchTab
  CVE response posture.
- interfaces: `backend()` return type (string vs branded); ref
  stability across snapshots; `PageTarget` resolution order; snapshot
  cache observability to the agent; concurrency-limit scope
  (per-capability or per-host).

## Self-improvement

Self-improvement: when the dispatch says "X is authorized and
load-bearing" for WebFetch, treat the public docs URL plus the
GitHub README as the minimum surface to fetch, because the docs page
alone often elides addressing schemes (here the per-tab
`/tabs/{tabId}/...` shape) that the README spells out concretely;
fetching only one of the two would have produced a design that
hand-waves the multi-instance / multi-tab indirection. Adding this
note to the `library-lookup` skill's external-fetch guidance is
overkill, so logging here rather than messaging the liaison.
