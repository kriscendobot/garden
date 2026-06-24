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
title: §UNIX-socket-vs-Windows-named-pipe asymmetry
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

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
