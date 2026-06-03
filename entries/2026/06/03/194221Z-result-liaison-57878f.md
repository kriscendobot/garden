---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--57878f
ts: 2026-06-03T19:42:21Z
ref_id: 57878f
---

# Cycle 167: endo packages/where/index.js (chat-lane; canonical path resolution surface)

Cycle 167 — chat-lane after cycle 166's designs-lane break.
§Endo-source-comment-fragment genre.

The natural rotation after a designs-lane cycle. Picked a
small but load-bearing file: `@endo/where` is *the* place
Endo's deployment shape across platforms is encoded.
§Reading-this-file-tells-you-where-Endo-keeps-its-data.

## Source

`endojs/endo packages/where/index.js`. Author Kris Kowal
(prompted). 115 lines, 5 exports + 1 internal helper.
File last-touched in commit `e2b78371`.

## Sections written (1)

`endo--packages-where-index-js--four-state-domain-path-
resolution-with-XDG-precedence-and-platform-fallback-
chain.md` (315 lines; commit `1cd49399`).

**§Cohesion-honest section count**: One. §The-five-
functions-form-a-coherent-surface (uniform 3-arg
signature, four state domains, one master pattern);
splitting would fragment the §master-pattern observation.

## Why this file is the right chat-lane pick

The file is small (115 lines) but the *load-bearing
knowledge* is large: §where-Endo-finds-its-files-per-
platform across three platform families, four state
domains, two IPC mechanisms (UNIX socket / named pipe),
one XDG-precedence pattern, one Windows-historical-env-var
fallback chain.

§The-LOC-doesn't-reflect-the-load-bearing-knowledge.
§Small-file-but-load-bearing-knowledge — sister to cycle
165's 92-line platform-specific.md from ocap-kernel.

## Single most structurally interesting move

**§XDG-precedence-with-platform-fallback-chain master
pattern** repeated for each state domain:

1. §XDG-env-var-wins (XDG_STATE_HOME / XDG_CACHE_HOME /
   XDG_RUNTIME_DIR) regardless of platform.
2. §Per-platform-default (win32 / darwin / else POSIX).
3. §Per-platform-fallback-chain (Windows has 4-level
   env-var precedence).

§The-user-can-always-override-via-XDG. §The-platform-
defaults-respect-the-platform's-conventions. §The-
fallback-chains-never-leave-the-user-without-a-path.

## Structural moves captured

- **§Four-state-domains-as-distinct-paths**: durable /
  ephemeral / sock / cache. §Cache-vs-state-split-
  honors-XDG-canon. §Why-PID-files-are-ephemeral.
- **§whereHomeWindows four-fallback helper**: §Windows-
  historical-accretion encoded in env-var precedence.
- **§Per-platform-naming-conventions**: POSIX lowercase-
  dotted; macOS CapitalE-with-space; Windows CapitalE-
  backslash. §When-in-Rome.
- **§UNIX-socket-vs-Windows-named-pipe asymmetry**: the
  load-bearing comment *Named pipes have a special place
  in Windows (and in our ashen hearts)*. §Wry-
  acknowledgment-of-Windows-IPC-quirks.
- **§Protocol-suffix-in-socket-names** (`captp0` default):
  §reserves-the-pattern-for-future-protocols.
- **§ENDO_SOCK-override**: §last-resort-user-override that
  bypasses all platform logic.
- **§Comment-with-honest-reasoning** on local-vs-roaming
  AppData with §named-TODO for future roaming support.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 165 (ocap-kernel platform-specific) | Sibling discipline — platform-specific code in *packages*; @endo/where puts it *inside functions*; §two-strategies-for-the-same-problem |
| 152 (memo-race.js) | §Re-creatable-cache-permits-purge-without-losing-state mirrors §weak-collections-permit-collection |
| 166 (daemon-mount) | §Scratch-mount-survives-cancellation analog |
| 164 (identity-backup-recovery) | §Where-identity-data-lives is whereEndoState |

## §Synthesis-target

§Five-function-platform-resolution-surface is the §reusable-
shape. The slot machine library should §reuse-@endo/where
rather than reinvent path resolution. §Vocabulary-borrowing-
candidates (Tier-1): §four-state-domains, §XDG-precedence-
with-platform-fallback-chain, §protocol-suffix-in-socket-
names, §ENDO_SOCK-override.

§Named-TODO (§roaming-AppData-with-content-addressable-
state-merge) is a §future-design-target.

## Files written / edited

- `library/sections/endo--packages-where-index-js--four-
  state-domain-path-resolution-with-XDG-precedence-and-
  platform-fallback-chain.md` (315 lines; commit
  `1cd49399`)
- `library/sources/endo--packages-where-index-js.md` (new
  source page)
- `library/sources/README.md` (cycle-167 row added in the
  @endo source-fragment section above dot-membrane.js)
- `library/sections/README.md` (cycle-167 entry; totals
  bumped 671/212 → 672/213)
- `library/topics/tooling.md` (cycle-167 row)
- `library/topics/daemon.md` (cycle-167 row; daemon-
  deployment-shape encoded in path resolution)
- `library/topics/getting-started.md` (cycle-167 row;
  contributor onboarding for Endo's filesystem footprint)
- `library/keywords.md` (51 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

671 / 212 → **672 sections from 213 source documents**.

## Lane rotation note

Cycle 167 was nominally **chat-lane** (after cycle 166's
designs-lane). Papers-lane blocked **61+ consecutive
cycles**.

Lane sequence over the last 11 cycles:
- 157: designs
- 158: chat
- 159: designs
- 160: chat
- 161: designs + user-directed off-rotation
- 162-165: comments (ocap-kernel mini-series)
- 166: designs (mini-series break)
- 167: chat (cycle 167 — this one)

§Healthy-rotation-discipline restored after the long
comments-lane streak. The §ocap-kernel-mini-series may
resume on a future cycle; the lane discipline ensures it
doesn't dominate.

## Cycle 167 — done. Schedule cycle 168.
