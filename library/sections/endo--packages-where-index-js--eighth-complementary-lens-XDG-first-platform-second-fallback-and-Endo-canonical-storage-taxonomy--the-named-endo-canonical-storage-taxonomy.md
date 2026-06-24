---
title: §the-named-Endo-canonical-storage-taxonomy
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
parent: endo--packages-where-index-js--eighth-complementary-lens-XDG-first-platform-second-fallback-and-Endo-canonical-storage-taxonomy
---

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
