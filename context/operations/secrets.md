---
created: 2026-11-05
updated: 2026-11-05
author: builder
---

# Provider secret management

Garden-managed provider keys live only on each host under
`<garden-root>/.garden-state/secrets/`. The directory is mode `0700`; each key
file is mode `0600`. The whole checkout remains mounted at its identical absolute
path in the container, and the launcher overlays the secrets directory with a
nested read-only mount. This makes placement a host-maintainer operation. Agents
may run the value-free status command, but must never place, rotate, retrieve, or
paste a key.

The registered kinds are `anthropic`, `moonshot`, `fireworks`, `openrouter`,
`ollama-cloud`, and `typesafe`. Harness keys enter only the selected CLI child;
the other five legacy variables are removed from that child's environment. Direct
TypeSafe, Fireworks, and OpenRouter calls go through fixed-operation wrappers and
the local broker. Every accepted placement, harness launch, or direct call first
lands a value-free record under `journal2:outbound/<service>/`.

## One-time compatibility migration

Deploying this release requires one deliberate container recreation to acquire
the nested read-only mount (and a rebuilt image for `bubblewrap`):

```sh
./garden build
./garden reset
./garden create
```

On each host, the maintainer may import only the six allowlisted variables from
the creation environment:

```sh
scripts/secrets/import-environment.sh
scripts/secrets/status.sh
```

The importer refuses an existing valid file unless the maintainer supplies
`--replace`. This compatibility release still forwards the six creation-time
variables and the seed handoff as a fallback. Remove that forwarding only after
both live hosts show every enabled provider as file-backed; disabled kinds may
remain absent.

## Place, rotate, and remove

Run the placement tool on the host, from the garden root. Its normal path reads
silently from the terminal, never accepts a value in argv, validates before the
swap, and restores the old file if the outbound ledger cannot commit:

```sh
scripts/secrets/set-key.sh typesafe
scripts/secrets/status.sh
```

For an already-secure producer, `--stdin` accepts exactly the input bytes. Rotation
is the same replace-in-place operation. A replacement is visible to the next
broker request and the next harness job without a container or systemd restart.

Revoke at the provider first, then remove the host copy:

```sh
scripts/secrets/set-key.sh typesafe --remove
```

Status reports only presence, validity, and age. The daily watchdog sends one
edge-latched reminder for an over-age or long-idle installed key and never removes
one. Use a separate restricted key per host and service where the provider offers
that control. CLI-owned Claude/Codex login files, bot SSH/`gh` identity, AWS
sessions or roles, and remotely held application secrets remain in their native
stores; do not copy them into this registry.

## Failure behavior

Journal unavailability is fail-closed for placement and egress. A malformed,
wrong-owner, wrong-mode, or absent file does not satisfy `requires: typesafe`.
The broker accepts only registered service operations and rejects caller-supplied
origins, paths, methods, and headers. TypeSafe records question names and input
hashes, never classified source; no outbound record contains a key, authentication
header, credential fingerprint, or provider response.
