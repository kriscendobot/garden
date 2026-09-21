---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Systemd socket activation for the Endo daemon (LISTEN_FDS)

Maintainer directive (kriskowal, 2026-09-21). Target `endojs/endo-but-for-bots`,
base branch `llm`. Implement the conventional systemd socket-activation
protocol in the Endo daemon: when systemd has pre-opened and pre-bound the
daemon's listening socket and passed it down via file descriptor, the daemon
must detect this (`LISTEN_FDS`) and use the inherited descriptor instead of
creating and binding its own socket. Document how to configure systemd to
use it in the daemon's README.

## Where this lives today

`packages/daemon/src/manager-node-powers.js`'s `servePath({ path, cancelled })`
is the exact function that currently always creates a fresh listener and
binds it to a Unix domain socket path:

```js
const servePath = async ({ path, cancelled }) => {
  const { connections } = await serveListener(server => {
    return new Promise((resolve, reject) =>
      server.listen({ path }, async error => { ... }),
    );
  }, cancelled);
  return connections;
};
```

`serveListener` (same file, just above) wraps a Node `net.Server`, taking a
setup callback that performs the actual `.listen(...)` call. This is the
injection point.

## The protocol (implement it precisely — don't approximate)

Standard systemd socket-activation contract (`sd_listen_fds(3)`):

1. Read `process.env.LISTEN_PID` and `process.env.LISTEN_FDS`.
2. **Both must be present and `LISTEN_PID` must equal `process.pid`** (as a
   string-to-number comparison) for the inherited descriptors to be this
   process's — systemd sets `LISTEN_PID` to the PID of the process it's
   about to exec, and a forked/exec'd child that doesn't match must NOT
   consume the descriptors (they weren't meant for it). If `LISTEN_PID`
   doesn't match (or is absent), fall through to the existing bind-your-own
   path unchanged — this is the common case and must not regress.
3. Inherited descriptors start at **fd 3** and count up (`LISTEN_FDS` is the
   count). Optionally honor `LISTEN_FDNAMES` (colon-separated names, systemd
   ≥227) if there's a sane way to pick the right one when the daemon opens
   multiple named sockets in future — for now, with the daemon opening a
   single Unix socket, using fd 3 unconditionally when the PID check passes
   is sufficient; don't over-build for a multi-socket future that doesn't
   exist yet.
4. When activated, use Node's `net.Server`'s existing-fd support —
   `server.listen({ fd: 3 }, callback)` — instead of `server.listen({ path })`.
   Do NOT attempt to bind or unlink the path yourself in this mode; systemd
   already owns the socket file's lifecycle (created per the `.socket` unit,
   see below) and the daemon must not delete/recreate it.
5. **Unset/clear `LISTEN_PID`/`LISTEN_FDS` from `process.env` once consumed**
   (the standard `sd_listen_fds` recommendation) so a child process the
   daemon spawns doesn't also try to claim the same descriptors.

Preserve every existing behavior in the non-activated path exactly as it is
today (the long-socket-path warning/EADDRINUSE handling, the `access(path)`
post-check, etc.) — this is additive, not a rewrite of the existing path.

## README documentation

Add a section to `packages/daemon/README.md` explaining systemd socket
activation: what it buys the operator (socket exists before the daemon
starts, systemd can lazily start the daemon on first connection, clean
restart without a connection-refused window), and a working example unit
pair:

- A `.socket` unit (`ListenStream=%t/endo/endo.sock` or similar, adjust to
  the daemon's actual conventional socket path/naming — check how the
  daemon currently derives its default socket path and use a realistic,
  consistent example, not a placeholder that contradicts the daemon's own
  conventions).
- A paired `.service` unit (`Requires=endo.socket`, no `ExecStartPre` socket
  setup needed — that's the whole point), the actual `ExecStart` invocation
  for the daemon.
- A one-line note that with the socket unit's `Accept=no` (the normal case
  for this kind of single-listener daemon, not one-process-per-connection),
  the daemon receives ONE inherited fd for the whole listening socket, same
  fd-3 contract described above.

## Verify

- A real, running-process test: actually exercise the LISTEN_FDS path (spawn
  the daemon with `LISTEN_PID=<own pid>` and `LISTEN_FDS=1` and a real
  pre-created/pre-listening fd 3, e.g. via a small harness that mimics what
  systemd does) and confirm it accepts a connection on the inherited socket,
  not a freshly-bound one. A test that only checks "the code branches
  correctly" without ever actually accepting a connection through an
  inherited fd doesn't prove the feature works.
- Confirm the existing non-activated path's test suite still passes
  unmodified (this must be a pure addition, zero behavior change when
  `LISTEN_FDS` is absent).
- Lint/types clean per the repo's existing gates.

## PR

Base branch `llm`. Follow the standard `pr-formation`/`pre-pr-checklist`
conventions. Runs through the normal gauntlet automatically once opened.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-21T20:32:18Z
