---
ts: 2026-06-08T04:53:00Z
kind: result
role: investigator
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/investigator--64e28e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 106
    role: target
refs:
  - entries/2026/06/08/044300Z-dispatch-investigator-64e28e.md
  - https://github.com/endojs/endo-but-for-bots/pull/106
  - https://github.com/endojs/endo-but-for-bots/pull/106#issuecomment-4445655934
  - https://playwright.dev/docs/browser-contexts
  - https://playwright.dev/docs/api/class-browser
  - https://playwright.dev/docs/api/class-browsercontext
  - https://playwright.dev/docs/api/class-browsertype#browser-type-launch-persistent-context
  - https://playwright.dev/docs/auth
  - https://playwright.dev/docs/library
---

# result: investigator on #106 (Browser exo persona partitioning fits Playwright BrowserContext cleanly; persistent and per-process are escalations)

Answers kriskowal's PR #106 comment 4445655934: yes, the Browser exo
can emit per-persona browsers that do not share cookies or history.
Playwright already provides the partitioning primitive; the question
is which level of isolation the exo's factory should bind, and the
shape of the existing structural-origin-allowlist scaffold makes the
choice mechanical.

## What the existing exo looks like (current branch)

`packages/exo-playwright/src/browser.js` exposes
`makeBrowserAndControl({ backend, allowedOrigins, readOnly })` and
returns a `{ browser, control }` pair. The `Backend` shape is the
seam the factory closes over:

```
interface Backend {
  newPage(url: string): Promise<BackendPage>;
  close(): Promise<void>;
}
```

The exo never sees Chromium directly. It calls `backend.newPage(url)`
after the URL clears the allowlist and wraps the returned
`BackendPage` in a `Page` exo that re-asserts revocation and
read-only at every method boundary. The real Playwright adapter is a
follow-up; the current release uses an in-memory fake. This means
persona/profile partitioning is a property of *which Backend
factory* the host wires in, not a property the exo currently has to
choose. The exo's revocation already calls `backend.close()` exactly
once after closing every outstanding `Page`, which is the right
shape for any of the three partitioning options below.

## Playwright's partitioning primitives

Mapped to the exo, four distinct mechanisms exist; only three are
actual isolation choices and the fourth (`userDataDir`) is the
file-system anchor for one of them, not a separable mechanism.

### 1. `browser.newContext()`: ephemeral BrowserContext per persona

One `chromium.launch()` call produces one OS browser process; many
`browser.newContext()` calls produce many isolated browsing
sessions inside it. Each context isolates cookies, localStorage,
sessionStorage, IndexedDB, service workers, cache, permissions, and
history. Playwright documents contexts as "fast and cheap to
create" and recommends them as the default isolation primitive
(incognito-profile semantics within one process). Closing a context
closes all its pages but leaves siblings untouched; the parent
`browser.close()` tears the whole process down.

Probed against Playwright's docs:

- *Browser → BrowserContext class*: `newContext()` "won't share
  cookies/cache with other browser contexts". `contexts()` returns
  the live list. `close()` closes all pages in that context.
- *BrowserContext.storageState()* exports cookies, localStorage,
  and IndexedDB as a JSON snapshot; `newContext({ storageState })`
  bootstraps from it. This is how Playwright's own auth.md
  documents per-persona reuse across runs (admin / regular-user
  fixtures).
- *Constraints*: GPU process, network stack, and Chromium browser
  process are shared across contexts in one launch. An attacker
  who can exploit the renderer or the GPU process is *not*
  contained by context boundaries; only DOM-side state is. For the
  exo's threat model (an LLM guest using DOM-level methods through
  a wrapped `Page`), this is sufficient: the guest never touches
  the renderer or GPU directly.

### 2. `browserType.launchPersistentContext(userDataDir, options)`: persistent profile per persona

Launches a browser whose single context reads and writes a
filesystem `userDataDir`. The directory holds Chrome's profile
data (cookies, localStorage, history, extensions, cache). Distinct
`userDataDir` paths produce independent personas whose state
survives across runs.

Probed against Playwright's docs:

- *Hard constraint*: "browsers do not allow launching multiple
  instances with the same User Data Directory"; concurrent
  personas need distinct `userDataDir` paths.
- *One-context-per-process*: the persistent launch returns one
  context. To run two persistent personas concurrently the host
  spawns two browser processes, each with its own `userDataDir`.
- *Lifecycle coupling*: closing a persistent context closes its
  browser; revocation maps cleanly to `context.close()` in the
  exo's `backend.close()`.

### 3. Separate `browserType.launch()` per persona: full per-process isolation

Each persona gets its own `chromium.launch()`. Cookies, storage,
*and* the OS process are independent. This is the strongest
isolation Playwright offers without leaving the library; the cost
is a full Chromium process per persona (~80–200 MB RSS plus file
descriptors and helper processes per launch).

### 4. `userDataDir` (not a separable mechanism)

The `userDataDir` argument is the persistence anchor for option 2,
not an isolation primitive on its own. Listed in the dispatch
brief and surfaced here only to mark it as such: the choice the
host actually makes is "ephemeral context", "persistent context
with a per-persona directory", or "per-persona process".

## Fit against the exo's shape

The exo's `Backend` seam is the right place for the host to bind a
partitioning policy; the exo body does not need to know which option
the host picked. Three Backend factories cover the three real
mechanisms:

| Mechanism | Backend factory shape | When the host picks this |
|---|---|---|
| Ephemeral context | one shared `Browser`, one `context = browser.newContext()` per `Backend`, `newPage(url)` = `context.newPage()` then navigate, `close()` = `context.close()` | Default for most personas: cheap, isolated for DOM-state, parallelizable in one Chromium process. |
| Persistent context | one `userDataDir` per `Backend`, `context = chromium.launchPersistentContext(dir, opts)`, `newPage(url)` = `context.newPage()` then navigate, `close()` = `context.close()` (closes the browser too) | Persona's cookies / logged-in state must survive across exo instantiations; daemon manages the directory inventory. |
| Per-persona process | one `chromium.launch()` per `Backend`, then one `newContext()` (or persistent on top), `close()` = `browser.close()` | Highest-stakes personas (for example, one persona is doing bank check-in, another is doing untrusted research) where DOM isolation is not enough. |

The exo's existing revocation cascade (`Promise.allSettled` on every
live page, then `backend.close()` exactly once) is already correct
for all three Backend shapes. No change to `browser.js` is needed
for partitioning to work; the policy lives at the daemon's
Backend-factory layer where the host wires Playwright in.

## Recommendation

1. **Adopt ephemeral `browser.newContext()` as the default Backend
   shape.** One daemon-owned `chromium.launch()` per Endo worker
   (or per host, depending on how the daemon wants to share
   Chromium across guests); one `browser.newContext()` per
   `makeBrowserAndControl({ backend, ... })` call. Each exo's
   `Backend` closes over its private context. Two `Browser` exos
   constructed against the same daemon do not share cookies,
   storage, or history because their contexts do not.
2. **Expose persistent-profile binding as an opt-in.** Add a
   Backend factory `makePlaywrightPersistentBackend({ userDataDir,
   launchOptions })` for personas whose state must survive the
   exo's lifetime. The host (not the guest) chooses the directory
   and manages its inventory; the exo simply consumes the
   returned `Backend`.
3. **Reserve per-process launch for the high-isolation case.**
   Add a Backend factory `makePlaywrightProcessBackend({
   launchOptions })` that calls `chromium.launch()` per exo. Use
   when the threat model demands process-level separation.
4. **No change to the exo's surface or to the structural-origin
   allowlist.** The allowlist is per-exo and partitioning is
   per-exo; they compose. Two exos with different allowlists and
   different contexts are doubly partitioned (origin scope and
   browser state).

## Trade-offs at a glance

| Property | Ephemeral context | Persistent context | Per-persona process |
|---|---|---|---|
| Cookies / storage / history isolation | yes | yes (and persisted) | yes |
| Cache / service-worker isolation | yes | yes (per-profile) | yes |
| Persistence across exo restarts | no (storageState export/import optional) | yes (on disk) | depends on the inner context choice |
| Renderer / GPU-process isolation | no | no (one process per persona but Chromium still does cross-context tricks within it) | yes |
| Concurrent same-key | safe | rejected by Chromium (same `userDataDir` cannot be opened twice) | safe |
| RAM cost per persona | ~10–30 MB (context overhead in shared Chromium) | full Chromium process per persona | full Chromium process per persona |
| Disk cost per persona | none (in-memory) | persona-sized profile directory | depends on inner choice |
| File-descriptor cost per persona | low | moderate (one process per persona) | moderate |
| Daemon-side bookkeeping | none | inventory of `userDataDir` paths + cleanup discipline | process lifecycle per exo |

## Out-of-scope implications surfaced

- **Daemon `userDataDir` layout** (if persistent personas land): a
  per-persona directory naming convention rooted in the daemon's
  state tree, and a revocation policy (delete the directory on
  exo revocation? leave it for future re-binding?). The exo's
  current revocation calls `backend.close()` exactly once; the
  Backend factory decides whether "close" means "tear down the
  process" or "tear down the process *and* delete the
  `userDataDir`". This is a host-side policy choice the design
  body should call out.
- **Storage-state export/import** is a third axis the exo could
  expose through `BrowserControl` (`exportState() / importState()`
  with appropriate authority). Worth tracking as a follow-up; not
  load-bearing for the partitioning question itself.
- **Subdomain wildcard allowlist** is an unrelated open follow-up
  already noted in `packages/exo-playwright/src/browser.js`
  header.

## Findings

| Severity | Finding |
|---|---|
| info | Playwright's `BrowserContext` is the right partitioning primitive for the exo's "no shared cookies/history" property. |
| info | The exo's existing `Backend` seam already cleanly accommodates all three real partitioning mechanisms; no change to the exo's surface required. |
| info | Persistent-profile binding (`launchPersistentContext` + `userDataDir`) is opt-in for the host; same `userDataDir` cannot be concurrently opened. |
| info | Per-persona process is the strongest isolation Playwright offers without leaving the library; reserve for high-stakes personas. |
| info | The exo's revocation cascade is already correct for any of the three Backend shapes. |

## Follow-up candidates (handed to the orchestrator)

- A **builder** dispatch to land the first real-Playwright Backend
  factory (probably `makePlaywrightEphemeralBackend` for the
  default partitioning), behind the existing `Backend` seam, with
  one new test verifying that two exos sharing the same
  underlying `Browser` see independent cookies.
- A **designer** dispatch to record persistent-profile and
  per-process Backend factory shapes in
  `designs/endoclaw-browser.md` under a *Partitioning policy*
  section, including the host-side `userDataDir` policy question.
- A **scout / probe** dispatch (later) to measure ephemeral
  context overhead under concurrent personas on the daemon's
  target worker shape.

## Probes run

1. *Read*: `packages/exo-playwright/src/browser.js`,
   `packages/exo-playwright/README.md`,
   `designs/endoclaw-browser.md`, PR #106 body. Confirmed the
   `Backend` shape is `{ newPage(url), close() }` and that the
   exo wraps `BackendPage` rather than exposing it.
2. *Fetch*: Playwright docs on `BrowserContext` (browser-contexts,
   class-browsercontext), `class-browser`,
   `launchPersistentContext`, library lifecycle, and the auth
   guide. Confirmed: contexts are the documented partitioning
   primitive; persistent contexts forbid concurrent same-dir
   reuse; `storageState` is the export/import bridge.
3. *Search*: journal for prior Playwright / partition / persona
   investigations. None on record. Project README
   (`journal/projects/endo-but-for-bots/README.md`) and followups
   directory carry nothing on persona partitioning. This is the
   first investigation on the question.

## Reply posted

https://github.com/endojs/endo-but-for-bots/pull/106#issuecomment-4645589133

Self-improvement: nothing this time. The investigator role's
hypothesis-driven posture and the journal's prior-work search
pattern both worked as documented; no role or skill drift to
flag.
