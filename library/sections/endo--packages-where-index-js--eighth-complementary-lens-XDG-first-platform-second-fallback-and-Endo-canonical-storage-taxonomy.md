---
title: "@endo/where index.js — eighth complementary-lens re-ingest; XDG-FIRST-platform-SECOND fallback discipline applied uniformly; Endo canonical storage taxonomy (State + Ephemeral + Sock + Cache); fourteenth one-cycle README↔source pair"
source: endo--packages-where-index-js
url: https://github.com/endojs/endo/blob/master/packages/where/index.js
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/where/index.js
total-lines: 115
ingest-cycle: 348
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline
  - the-named-XDG-FIRST-platform-SECOND-fallback-pattern
  - the-named-Endo-canonical-storage-taxonomy
  - the-named-four-functions-locate-four-kinds-of-storage
  - the-named-state-vs-ephemeral-vs-sock-vs-cache
  - the-named-progressive-degradation-fallback
  - the-named-named-pipes-have-special-place-comment
  - the-named-ashen-hearts-comment-as-frustration-marker
  - the-named-LOCALAPPDATA-favoring-rationale
  - the-named-five-step-fallback-chain-for-Windows-home
  - the-named-ENDO_SOCK-override-with-named-rationale
  - the-named-XDG-doesnt-fit-so-we-invent-our-own
  - the-named-info-vs-env-as-two-sources
  - the-named-protocol-versioned-socket-path
  - the-named-CapTP0-as-protocol-versioning
  - the-named-typedef-as-types-imports
  - the-named-complementary-lens-re-ingest
  - eight-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-fourteenth-instance
  - thirty-nine-cycles-with-named-pivot-domain-stay
  - one-hundred-thirty-citation-arc-closures-in-pivot-now
---

# `@endo/where index.js` — eighth complementary-lens re-ingest

The 115-line index.js with FOUR exported locator functions + ONE private helper. Cycle 348 is **chat-lane after cycle 347's designs-lane @endo/where README** — adjacent forward pair, same package. **§the-named-streak-resumes-with-fourteenth-instance** — fourteenth INSTANCE of one-cycle README↔source pattern; streak count is 1.

**Thirty-ninth consecutive non-garden source after the pivot** (cycles 310-348). **§thirty-nine-cycles-with-named-pivot-domain-stay**. **§nineteen-named-packages-in-the-pivot-cluster** continues (where's source after its README; cycle 167 was the original source ingest).

**§eight-cycles-with-named-complementary-lens-re-ingest** (322 exo-makers + 324 atomics + 330 smallcaps + 332 exo-tools + 336 memo-race + 342 lockdown-pre + 344 init source cluster + **348 where index.js**) — the librarian discipline now spans **EIGHT applications**.

**Note on prior ingest**: Cycle 167 ingested `where/index.js` as a comment-fragment, naming **§the-named-named-TODO** (the *"TODO support roaming data..."* observation). Cycle 348 takes the **implementation-pattern lens** — what discipline does the file embody across its five functions; how does the cycle 347 README's policy ("XDG first, native fallback") manifest in code.

## The single most structurally interesting move

**§the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline** — every locator function follows the SAME decision tree:

```js
if (env.XDG_X !== undefined) {
  return `${env.XDG_X}/endo`;          // 1. Cross-platform XDG spec
} else if (platform === 'win32') {
  return `${whereHomeWindows(env, info)}\\Endo`;  // 2. Windows-native
} else if (platform === 'darwin') {
  return `${home}/Library/X/Endo`;     // 3. Mac-native
}
return `${home}/.X/endo`;              // 4. Linux/default fallback
```

**§the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline** — first-explicit-observation as a tier-3 meta-pattern. Each of the four locator functions follows this **four-tier decision tree**:
1. **XDG env var present** — use it (highest preference; cross-platform)
2. **platform === 'win32'** — use Windows-native conventions
3. **platform === 'darwin'** — use Mac-native conventions
4. **default** — use Linux/POSIX conventions

The discipline is the **implementation** of cycle 347's README policy: *"Endo attempts to use or infer XDG conventions paths in every meaningful way... Otherwise falls back to the native conventions on Windows and Mac/Darwin."* Cycle 347 named the policy at the README level; cycle 348 reveals it applied **uniformly across all four functions**.

**§the-named-XDG-FIRST-platform-SECOND-fallback-pattern** — first-explicit-observation. The pattern is enforced by structural similarity across functions: same decision-tree shape, different XDG env-var name + different platform-native path.

**§the-named-policy-uniformly-applied-across-functions-discipline** — first-explicit-observation as a tier-3 meta-pattern. When a package has multiple functions implementing variants of the same policy, the functions should share **structural similarity** so the policy is visible in the code.

## §the-named-Endo-canonical-storage-taxonomy

The four exported functions define a FOUR-CATEGORY taxonomy of Endo's storage:

| Function | Purpose | XDG env var | Cycle 347 README mention |
|---|---|---|---|
| `whereEndoState` | Saved files (applications + capabilities + pet names + logs) | `XDG_STATE_HOME` | "per-user runtime data" + "logs" |
| `whereEndoEphemeralState` | PID files (does not persist between reboots) | `XDG_RUNTIME_DIR` | (implicit) |
| `whereEndoSock` | UNIX domain socket / Windows named pipe (daemon IPC) | `ENDO_SOCK` (custom!) | "Unix domain socket or Windows named pipe for the Endo daemon" |
| `whereEndoCache` | Caches (transient/regeneratable) | `XDG_CACHE_HOME` | (implicit) |

**§the-named-Endo-canonical-storage-taxonomy** — first-explicit-observation as a tier-3 meta-pattern. **§the-named-four-functions-locate-four-kinds-of-storage**.

**§the-named-state-vs-ephemeral-vs-sock-vs-cache** — first-explicit-observation. The taxonomy distinguishes:
- **State**: persistent (survives reboots; saved files)
- **Ephemeral**: process-lifetime (PID files; lost on reboot)
- **Sock**: IPC endpoint (daemon connection)
- **Cache**: regeneratable (deletable without loss)

**§the-named-four-named-storage-categories-with-named-XDG-correspondents** — first-explicit-observation. Three of the four use a standard XDG env var (STATE + RUNTIME + CACHE); ONE uses a custom env var (ENDO_SOCK) because XDG doesn't cover sockets.

## §the-named-ENDO_SOCK-override-with-named-rationale

Lines 81-83:

> It must be possible to override the socket or named pipe location, but we cannot use XDG_RUNTIME_DIR for Windows named pipes, so for this case, we invent our own environment variable.

**§the-named-ENDO_SOCK-override-with-named-rationale** — first-explicit-observation. The comment names:
1. **The need**: must be overridable
2. **The constraint**: XDG_RUNTIME_DIR doesn't cover Windows named pipes
3. **The solution**: invent ENDO_SOCK custom env var

**§the-named-XDG-doesnt-fit-so-we-invent-our-own** — first-explicit-observation as a tier-3 meta-pattern. When a cross-platform spec doesn't cover a case, invent a project-specific env var with the project's prefix. Compare to cycle 342 @endo/lockdown's `LOCKDOWN_OPTIONS` — both use project-prefix-named env vars for override functionality.

**§two-cycles-with-named-project-prefix-env-var** (342 LOCKDOWN_OPTIONS + 348 ENDO_SOCK) — first-explicit-observation as a tier-2 multi-cycle pattern.

## §the-named-progressive-degradation-fallback

`whereHomeWindows` (lines 7-25) implements a **FIVE-STEP fallback chain** for Windows home detection:

```js
if (env.LOCALAPPDATA !== undefined) return `${env.LOCALAPPDATA}`;
if (env.APPDATA !== undefined) return `${env.APPDATA}\\Local`;
if (env.USERPROFILE !== undefined) return `${env.USERPROFILE}\\AppData\\Local`;
if (env.HOMEDRIVE !== undefined && env.HOMEPATH !== undefined) return `${env.HOMEDRIVE}${env.HOMEPATH}\\AppData\\Local`;
return `${info.home}\\AppData\\Local`;  // last resort
```

**§the-named-five-step-fallback-chain-for-Windows-home** — first-explicit-observation. Each fallback is LESS PREFERABLE than the previous. The discipline: try the cleanest convention first; degrade gracefully through progressively more reconstructed paths.

**§the-named-progressive-degradation-fallback** — first-explicit-observation as a tier-3 meta-pattern. When a platform doesn't have a single canonical home directory, try each environment-variable approach in preference order, falling through to the lowest-level reconstruction.

**§the-named-LOCALAPPDATA-favoring-rationale** — first-explicit-observation. Lines 9-12 explain WHY LOCALAPPDATA is preferred over roaming APPDATA:

> Favoring local app data over roaming app data since I don't expect to be able to listen on one host and connect on another.

The comment names the discipline: local app data because **roaming doesn't make sense for socket-bound daemons**.

## §the-named-named-pipes-have-special-place-comment

Line 94 in `whereEndoSock`:

```js
// Named pipes have a special place in Windows (and in our ashen hearts).
const user = env.USERNAME !== undefined ? env.USERNAME : info.user;
return `\\\\?\\pipe\\${user}-Endo\\${protocol}.pipe`;
```

**§the-named-named-pipes-have-special-place-comment** — first-explicit-observation. The comment uses **humor** to acknowledge a difficult platform constraint.

**§the-named-ashen-hearts-comment-as-frustration-marker** — first-explicit-observation as a tier-3 meta-pattern. When a platform-specific code path requires significant accommodation, a humor-frustration comment can mark the maintenance burden. Compare to cycle 337 @endo/harden's §the-named-precise-technical-language-without-pejorative-tone — cycle 348's "ashen hearts" is the OPPOSITE: emotional language deliberately included.

**§two-shapes-of-emotional-tone-in-source-comments** (cycle 337 precise-without-pejorative + cycle 348 emotional-frustration-marker) — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-protocol-versioned-socket-path

Lines 88, 91, 95, 99, 102 — every reference to the socket path includes `${protocol}` where `protocol = 'captp0'` (default):

```js
export const whereEndoSock = (platform, env, info, protocol = 'captp0') => {
  // ...
  return `\\\\?\\pipe\\${user}-Endo\\${protocol}.pipe`;  // Windows
  return `${env.XDG_RUNTIME_DIR}/endo/${protocol}.sock`;  // XDG
  return `${home}/Library/Application Support/Endo/${protocol}.sock`;  // Darwin
  return `${temp}/endo-${user}/${protocol}.sock`;  // POSIX default
};
```

**§the-named-protocol-versioned-socket-path** — first-explicit-observation. The socket path includes the **protocol version** so different protocol versions can coexist (a v1 server and v2 server can both listen on the same machine without conflict).

**§the-named-CapTP0-as-protocol-versioning** — first-explicit-observation. *"captp0"* is the canonical zero-th version of the CapTP protocol; future versions can coexist by varying the protocol prefix.

**§the-named-protocol-version-in-path-for-coexistence** — first-explicit-observation as a tier-3 meta-pattern. When a daemon's wire protocol may evolve, encode the protocol version in the socket/pipe path so multiple versions can run side-by-side.

## §the-named-info-vs-env-as-two-sources

Every function takes BOTH `env` and `info`:

```js
export const whereEndoState = (platform, env, info) => { ... };
```

- `env` is the environment variables dictionary (XDG_*, HOME, TMPDIR, USER, etc.)
- `info` is platform-detected info (home + temp + user)

**§the-named-info-vs-env-as-two-sources** — first-explicit-observation. The two-source-discipline:
- **env**: user/OS-overridable; can be unset
- **info**: platform-detected; always available as fallback

Every function uses `env.X !== undefined ? env.X : info.X` for shared keys (HOME → info.home; USER → info.user; TMPDIR → info.temp). **§the-named-env-falls-back-to-info-discipline** — first-explicit-observation.

**§the-named-pure-function-by-injection** — first-explicit-observation. The functions are PURE — they don't read globals; they take env and info as parameters. This makes them testable + portable. Compare to cycle 342 @endo/lockdown's pre.js which directly accesses `globalThis.LOCKDOWN_OPTIONS` and `process.env`; cycle 348's where/index.js is the INJECTION-OF-DEPENDENCIES variant.

**§two-shapes-of-environment-access** (cycle 342 direct-globals + cycle 348 injection-of-env-and-info) — first-explicit-observation as a tier-2 multi-cycle pattern.

## §the-named-typedef-as-types-imports

Each function uses JSDoc to reference types from `./types.js`:

```js
/** @type {typeof import('./types.js').whereEndoState} */
export const whereEndoState = (platform, env, info) => { ... };
```

**§the-named-typedef-as-types-imports** — first-explicit-observation. The function's type signature is declared in a SEPARATE `types.js` file; the implementation file imports it via JSDoc `@type {typeof import('X')}`. This decouples the type definitions from the implementation.

**§the-named-separate-types-d-ts-for-public-API-types** — first-explicit-observation as a tier-3 meta-pattern. When a package exposes a public TypeScript-typed API, declare the types in a `types.d.ts` file separate from the runtime `index.js`.

## §the-named-roaming-app-data-named-TODO

Lines 11-14:

> TODO support roaming data for shared content addressable state and find a suitable mechanism for merging state that may change independently on separate roaming hosts.

**§the-named-roaming-app-data-named-TODO** — first-explicit-observation. The TODO names:
1. **The feature**: roaming data support
2. **The reason**: shared content-addressable state across hosts
3. **The obstacle**: need a mechanism for merging concurrent state changes

This matches cycle 167's §named-TODO observation (the original observation that motivated cycle 167's ingest). Cycle 348 reveals the FULL CONTENT of the TODO (cycle 167 named the *presence* of TODOs; cycle 348 names the *content* of this specific one).

**§the-named-multi-host-state-sync-as-named-future-work** — first-explicit-observation as a tier-3 meta-pattern.

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 347 (@endo/where README) | 1 cycle | Adjacent forward pair; same-package README→source |
| **Cycle 167 (where/index.js comment-fragment)** | **181 cycles** | **Eighth complementary-lens re-ingest** |
| Cycle 187 (shim cluster + daemon family) | 161 cycles | Endo daemon family |
| Cycle 342 (@endo/lockdown pre.js LOCKDOWN_OPTIONS) | 6 cycles | §two-cycles-with-named-project-prefix-env-var |
| Cycle 337 (@endo/harden README precise-language) | 11 cycles | §two-shapes-of-emotional-tone-in-source-comments |

**§five-citation-arc-closures-in-cycle-348**. **§one-hundred-thirty-citation-arc-closures-in-pivot-now** (125 + 5 net new).

## Patterns the cycle extends

- §thirty-nine-cycles-with-named-pivot-domain-stay (310-348)
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-thirty-citation-arc-closures-in-pivot-now (125 + 5 net new)
- **§eight-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342 + 344 + 348)
- §two-cycles-with-named-project-prefix-env-var (342 + 348)
- §two-shapes-of-emotional-tone-in-source-comments (337 + 348)
- §two-shapes-of-environment-access (342 + 348)
- §the-named-streak-resumes-with-fourteenth-instance

## Tier-1 borrowing (twelve-plus first-explicit-observations)

- **§the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline**
- **§the-named-XDG-FIRST-platform-SECOND-fallback-pattern**
- **§the-named-policy-uniformly-applied-across-functions-discipline**
- **§the-named-Endo-canonical-storage-taxonomy**
- **§the-named-four-functions-locate-four-kinds-of-storage**
- **§the-named-state-vs-ephemeral-vs-sock-vs-cache**
- **§the-named-four-named-storage-categories-with-named-XDG-correspondents**
- **§the-named-progressive-degradation-fallback** — five-step Windows home fallback chain
- **§the-named-five-step-fallback-chain-for-Windows-home**
- **§the-named-LOCALAPPDATA-favoring-rationale**
- **§the-named-ENDO_SOCK-override-with-named-rationale**
- **§the-named-XDG-doesnt-fit-so-we-invent-our-own**
- **§the-named-named-pipes-have-special-place-comment**
- **§the-named-ashen-hearts-comment-as-frustration-marker**
- **§two-shapes-of-emotional-tone-in-source-comments**
- **§the-named-protocol-versioned-socket-path**
- **§the-named-CapTP0-as-protocol-versioning**
- **§the-named-protocol-version-in-path-for-coexistence**
- **§the-named-info-vs-env-as-two-sources**
- **§the-named-env-falls-back-to-info-discipline**
- **§the-named-pure-function-by-injection**
- **§two-shapes-of-environment-access**
- **§the-named-typedef-as-types-imports**
- **§the-named-separate-types-d-ts-for-public-API-types**
- **§the-named-roaming-app-data-named-TODO**
- **§the-named-multi-host-state-sync-as-named-future-work**

## Tier-3 borrowing (meta-patterns)

- **§the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline** — IMPLEMENTATION of cycle 347's README policy
- **§the-named-policy-uniformly-applied-across-functions-discipline** — when multiple functions implement variants of the same policy, share structural similarity
- **§the-named-Endo-canonical-storage-taxonomy** — four-category storage taxonomy (State + Ephemeral + Sock + Cache)
- **§the-named-progressive-degradation-fallback** — try cleanest convention first; degrade gracefully
- **§the-named-XDG-doesnt-fit-so-we-invent-our-own** — project-prefix env var for cases the spec doesn't cover
- **§the-named-ashen-hearts-comment-as-frustration-marker** — humor-frustration to mark maintenance burden
- **§two-shapes-of-emotional-tone-in-source-comments** — precise-without-pejorative (cycle 337) + emotional-frustration (cycle 348)
- **§the-named-protocol-version-in-path-for-coexistence** — encode protocol version in path for side-by-side versions
- **§the-named-pure-function-by-injection** — testable + portable via dependency injection
- **§the-named-separate-types-d-ts-for-public-API-types** — decouple types from implementation

## Synthesis-target

Slot machine library **§`@game/where/index.js`** — locator-utility implementation:

1. **Cross-platform spec FIRST, platform-native FALLBACK** — applied uniformly across all locator functions
2. **Four-category storage taxonomy** — State + Ephemeral + Sock + Cache
3. **Progressive degradation fallback** — five-step chain for platform home detection
4. **Project-prefix env var when spec doesn't cover** — GAME_SOCK custom env var alongside XDG_*
5. **Protocol-version in path** — encode wire-protocol version for side-by-side coexistence
6. **Pure function by injection** — accept env + info as parameters; no globalThis access
7. **Separate types.d.ts for public API types**
8. **Humor-frustration comments allowed** to mark maintenance burdens (where appropriate)

## Library state after cycle 348

- §library-reaches-860-sections from 392 source documents (source count unchanged; complementary-lens re-ingest)
- §one-hundred-and-eighty-first consecutive designs-chat alternation
- §thirty-nine-cycles-with-named-pivot-domain-stay
- §nineteen-named-packages-in-the-pivot-cluster (where's source after its README)
- §one-hundred-thirty-citation-arc-closures-in-pivot-now (125 + 5 net new)
- **§eight-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342 + 344 + 348) — librarian discipline confirmed across EIGHT applications
- §the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline established as tier-3 meta-pattern
- §the-named-Endo-canonical-storage-taxonomy established as tier-3 meta-pattern
- §the-named-progressive-degradation-fallback established as tier-3 meta-pattern
- §the-named-ashen-hearts-comment-as-frustration-marker established as tier-3 meta-pattern
- §two-shapes-of-emotional-tone-in-source-comments established as tier-3 meta-pattern
- §the-named-protocol-version-in-path-for-coexistence established as tier-3 meta-pattern
- §the-named-pure-function-by-injection established as tier-3 meta-pattern
- §the-named-streak-resumes-with-fourteenth-instance (cycle 347 → 348 same-package; fourteenth INSTANCE of one-cycle README↔source pattern)
