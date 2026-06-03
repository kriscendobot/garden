---
source: packages/where/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/where/index.js
source_path: packages/where/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
  - getting-started
genre: §endo-source-comment-fragment
cycle: 167
lane: chat
status: current
---

# Four-state-domain path resolution with XDG precedence and platform-fallback chain

> §Chat-lane after cycle 166's designs-lane break in the
> §ocap-kernel-mini-series. §Endo-source-comment-fragment
> genre (the file is short — 115 lines — but the load-
> bearing knowledge is §where-Endo-finds-its-files-per-
> platform, which is otherwise scattered across deployment
> notes).

`packages/where/index.js` (115 lines) is the **§canonical-
path-resolution-surface** for Endo across all platforms.
Five exported functions plus one internal helper resolve
four distinct §state-domains — durable state, ephemeral
state, UNIX socket / named pipe, cache — across three
platform families — Linux/XDG, macOS, Windows.

The file's *behavior* is the load-bearing knowledge; the
*comments* are sparse but pointed. The single most
structurally interesting move is the §XDG-precedence-with-
platform-fallback-chain pattern, repeated for each state
domain with consistent shape.

## §Four-state-domains-as-distinct-paths

The file distinguishes **four** state domains, each with
its own resolver:

| Function | Domain | Loss-on-restart? | Loss-on-cache-purge? |
|----------|--------|------------------|---------------------|
| `whereEndoState` | Durable state (apps, capabilities, pet names) | No | No |
| `whereEndoEphemeralState` | Ephemeral state (PID files) | Yes (sometimes) | No |
| `whereEndoSock` | UNIX socket / named pipe path | Yes | No |
| `whereEndoCache` | Re-creatable cache (bundle compilation) | No | **Yes** |

§Four-domains-not-one-because-each-has-different-loss-and-
visibility-requirements. §Cache-vs-state-split-honors-XDG-
canon: §XDG_STATE_HOME survives `rm -rf ~/.cache`; §XDG_
CACHE_HOME doesn't.

§Why-PID-files-are-ephemeral-but-sockets-too: PIDs are
meaningless after reboot (the process is gone). UNIX socket
files are §inode-paths-that-need-to-be-removable on daemon
restart. Putting both in `XDG_RUNTIME_DIR` (which is purged
on reboot) means §the-OS-cleans-up-after-us.

§Why-state-survives-but-ephemeral-doesn't: durable state
encodes user choices (pet names, capabilities); ephemeral
state encodes only §current-session-coordinates. Conflating
them would §lose-user-state-on-reboot.

## §XDG-precedence-with-platform-fallback-chain (the master pattern)

Every resolver follows the same §three-tier-decision-tree:

1. **§XDG-env-var-wins**: if `XDG_STATE_HOME` (or
   `XDG_CACHE_HOME` / `XDG_RUNTIME_DIR`) is set, use
   `${XDG}/endo` regardless of platform.
2. **§Per-platform-default**: branch on `platform === 'win32'`
   / `platform === 'darwin'` / else (POSIX).
3. **§Per-platform-fallback-chain**: each platform's branch
   itself has fallbacks (especially Windows, which has 4-
   level env-var precedence).

§The-user-can-always-override-via-XDG. §The-platform-
defaults-respect-the-platform's-conventions. §The-fallback-
chains-never-leave-the-user-without-a-path.

§Cycle-165's-platform-obvious-vs-platform-implicit-exports
(ocap-kernel) is a sibling discipline at the package layer;
this is the analog at the §runtime-environment-layer:
§platform-conditional-behavior-encoded-as-a-three-tier-
decision-tree.

## §whereHomeWindows — the four-fallback Windows helper

```js
const whereHomeWindows = (env, info) => {
  if (env.LOCALAPPDATA !== undefined) return `${env.LOCALAPPDATA}`;
  if (env.APPDATA !== undefined) return `${env.APPDATA}\\Local`;
  if (env.USERPROFILE !== undefined) return `${env.USERPROFILE}\\AppData\\Local`;
  if (env.HOMEDRIVE !== undefined && env.HOMEPATH !== undefined) {
    return `${env.HOMEDRIVE}${env.HOMEPATH}\\AppData\\Local`;
  }
  return `${info.home}\\AppData\\Local`;
};
```

§Four-env-var-fallback-chain reflects §Windows-historical-
accretion: each env-var was introduced in different Windows
versions, with §earlier-ones-superseded-by-later-ones. The
code preserves backward compat by checking the §most-
specific-first and falling back to §progressively-more-
reconstructive forms.

§Why-five-candidates: §LOCALAPPDATA (the canonical modern
var) → §APPDATA (older, points at Roaming; we suffix
\Local) → §USERPROFILE (the home dir) → §HOMEDRIVE+HOMEPATH
(the §historical-DOS-split) → §info.home (the §JS-runtime-
reported home as last resort).

§Comment-with-honest-reasoning:

> *Favoring local app data over roaming app data since I
> don't expect to be able to listen on one host and connect
> on another.*

§Roaming-AppData-not-supported-because-listen-on-one-host-
not-applicable. §Endo's-CapTP-sock is §host-bound. §TODO-
named for §future-roaming-support-with-content-addressable-
state-merge.

## §Per-platform path conventions

| Platform | State | Cache | Socket |
|----------|-------|-------|--------|
| **POSIX (default)** | `~/.local/state/endo` | `~/.cache/endo` | `${TMPDIR}/endo-${USER}/${protocol}.sock` |
| **macOS** | `~/Library/Application Support/Endo` | `~/Library/Caches/Endo` | `~/Library/Application Support/Endo/${protocol}.sock` |
| **Windows** | `${LOCALAPPDATA}\Endo` | `${LOCALAPPDATA}\Endo` | `\\?\pipe\${USER}-Endo\${protocol}.pipe` |

§Three-naming-conventions for the directory itself:

- POSIX: §lowercase-with-dot-prefix-convention (`endo`,
  hidden dir).
- macOS: §CapitalE-with-space (`Endo`, visible in Library
  hierarchy).
- Windows: §CapitalE-backslash-path (`Endo`, visible).

§Match-the-platform's-aesthetic — §dot-hidden-on-POSIX,
§visible-named-on-macOS-and-Windows.

§Why-not-uniform-naming: §when-in-Rome. POSIX users expect
`~/.local`; macOS users expect `~/Library`; Windows users
expect `%LOCALAPPDATA%`. Forcing one convention everywhere
would §violate-platform-mental-models.

## §UNIX-socket-vs-Windows-named-pipe asymmetry

The single most platform-divergent function is
`whereEndoSock`:

```js
} else if (platform === 'win32') {
  // Named pipes have a special place in Windows (and in our ashen hearts).
  const user = env.USERNAME !== undefined ? env.USERNAME : info.user;
  return `\\\\?\\pipe\\${user}-Endo\\${protocol}.pipe`;
}
```

§The-comment-is-the-load-bearing-knowledge: *Named pipes
have a special place in Windows (and in our ashen hearts).*
§Wry-acknowledgment-of-Windows-IPC-quirks.

§Named-pipe-syntax-explained: §`\\?\pipe\` is the §reserved-
namespace-prefix for Windows named pipes (the `\\?\`
extended-length path prefix indicates §raw-not-Win32-
namespace; `pipe\` is the §named-pipe-namespace-marker).
§Then `${user}-Endo\${protocol}.pipe` — §user-scoped pipe
name to avoid cross-user collision.

§Different-shape-from-UNIX-socket: UNIX sockets are
*filesystem paths* with permission bits; Windows named pipes
are *kernel objects* with a separate namespace. The §where-
function-returns-a-string-but-the-string-means-different-
things on the two platforms.

§ENDO_SOCK-override discipline: a single env var can bypass
all platform-specific logic. §Last-resort-user-override.
§Comment-explains-why: the override exists because §XDG_
RUNTIME_DIR-can't-be-used-for-Windows-named-pipes (XDG is
POSIX-only) — so when overriding on Windows, the user needs
a §separate-env-var.

## §Protocol-suffix in socket names

```js
export const whereEndoSock = (platform, env, info, protocol = 'captp0') => {
```

§Protocol-defaults-to-captp0. §Reserves-the-pattern-for-
future-protocols. §Future-Endo-might-host-CapTP-1-or-OCapN
on separate sockets simultaneously; §the-default-name-is-
captp0-now-but-the-shape-supports-versioning.

§Protocol-as-fourth-arg-with-default: §additive-API. Callers
that don't pass it get §captp0 (the current default);
callers that do can request a different protocol's socket
path. §No-breaking-change-when-adding-new-protocols.

## §XDG_RUNTIME_DIR for ephemeral state

```js
export const whereEndoEphemeralState = (platform, env, info) => {
  if (env.XDG_RUNTIME_DIR !== undefined) {
    return `${env.XDG_RUNTIME_DIR}/endo`;
  } else if (platform === 'win32') {
    return `${whereHomeWindows(env, info)}\\Temp\\Endo`;
  }
  ...
```

§XDG_RUNTIME_DIR is the §canonical-tmpfs-cleared-on-reboot
location on systemd-managed Linux systems. §OS-cleans-up-
on-reboot is the §intended-PID-file-and-socket-lifecycle.

§Why-not-just-/tmp: `/tmp` on most systems is *not* cleared
on reboot (only on `tmpwatch` schedule, weeks); §XDG_
RUNTIME_DIR is §guaranteed-cleared-on-logout. §PID-files-
after-reboot-are-misleading; §XDG_RUNTIME_DIR-prevents-this.

## §Cycle-152-memo-race.js GC-friendliness sibling observation

Cycle 152's memo-race.js noted §promise-kit's-GC-friendly-
collection-semantics. §where/index.js has an analog at the
filesystem layer: §re-creatable-cache-in-XDG_CACHE-permits-
purge-without-losing-state, mirroring §weak-collections-
permit-collection-without-losing-strong-references.

§Same-discipline-different-scope: at the heap layer, §weak-
collections-don't-keep-things-alive. At the filesystem
layer, §cache-can-be-purged-without-losing-state.

## §Five-functions-form-a-coherent-surface

```
whereHomeWindows  (internal helper)
whereEndoState    → durable
whereEndoEphemeralState → ephemeral (sockets + PIDs at OS level)
whereEndoSock     → IPC socket path (UNIX socket or named pipe)
whereEndoCache    → re-creatable cache
```

§Five-functions-cover-the-four-domains plus the §internal-
helper. §Each-function-takes-the-same-three-args (platform,
env, info) and §returns-a-string. §Uniformity-of-signature
makes the §callers-trivially-platform-agnostic.

§Comparison-with-cycle-165's-platform-specific.md: ocap-
kernel splits platform-specific code into separate
*packages* with conditional exports; @endo/where puts
§platform-specific-behavior-inside-the-functions and the
caller is §platform-agnostic. §Two-strategies-for-the-same-
problem.

## §Endo's-overall-state-shape implied

Reading this file tells you Endo's deployment shape:

- **Durable user data**: pet names, capabilities, apps,
  bundles — under `whereEndoState`.
- **One daemon socket per protocol**: `whereEndoSock` with
  `protocol='captp0'` is the well-known address.
- **Cache for compiled bundles**: `whereEndoCache` is the
  re-creatable artifact store.
- **PID file + sock during runtime**: under
  `whereEndoEphemeralState`.

§The-shape-of-the-runtime-is-readable-from-the-paths.
§Reading-this-file-tells-you-how-Endo-organizes-itself.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 165 (ocap-kernel platform-specific) | Sibling discipline — platform-specific behavior in *packages*; @endo/where puts it *inside functions* |
| 152 (memo-race.js) | §Re-creatable-cache-permits-purge-without-losing-state mirrors §weak-collections-permit-collection |
| 166 (daemon-mount) | §Scratch-mount-survives-cancellation analog: state survives ephemeral-state cleanup but not vice versa |
| 164 (identity-backup-recovery) | §Where-the-identity-data-lives is whereEndoState; cycle 164 says what's stored, this says where |

## §Synthesis-target

§Five-function-platform-resolution-surface is the §reusable-
shape. The slot machine library will need an analog (where
does *its* state live? Probably under §whereEndoState too).
§Don't-reinvent-platform-resolution; §reuse-@endo/where.

§Vocabulary-borrowing-candidates (Tier-1): §four-state-
domains, §XDG-precedence-with-platform-fallback-chain,
§protocol-suffix-in-socket-names, §ENDO_SOCK-override.

§The-named-TODO (§roaming-AppData-with-content-addressable-
state-merge) is a §future-design-target — if Endo ever
adds roaming support, this is where it lands.

## §Small-file-but-load-bearing-knowledge

115 lines, 5 exports + 1 helper. §The-LOC-doesn't-reflect-
the-load-bearing-knowledge. Three platform conventions,
four state domains, two IPC mechanisms (UNIX socket / named
pipe), one XDG-precedence pattern, one Windows-historical-
env-var fallback chain — all encoded in 115 lines.

§Reading-this-file-once-gives-you-the-deployment-shape-
across-three-platforms. §Comparable-to-cycle-165's-92-line-
platform-specific.md from ocap-kernel — both are §small-
docs-with-large-knowledge-density.
