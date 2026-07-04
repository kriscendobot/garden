# The GARDEN shard identity

Every garden instance has one logical name — its **`GARDEN` shard identity** —
and it **must be unique across every running instance you own**. It keys job
claims, per-host worker counts (`hosts/<host>`), journal index entries, and the
leader marker; two instances sharing a name silently corrupt each other's
per-host state. This page is the naming knob and the uniqueness discipline: the
`.garden` file as the one place the name lives, `GARDEN=… ./garden` as sugar
over it, why an exported env var does not reach the fleet, and the rename /
parallel-pool moves. If your question is "how do I name this instance" or "these
two instances are stepping on each other," you are in the right place; the
multi-host leader/follower mechanics that the marker gates are
`../operations/leader-follower.md`.

## The one naming knob: `.garden`

The streamlined, preferred way to name an instance is one line **before the
first `./garden`**:

```sh
echo petunias > .garden
```

The launcher reads `.garden` when present and derives the container name and
`--hostname` from it. Bare `./garden` needs **no environment variables** — every
default is satisfactory, and an unnamed instance falls back to the container
hostname. You only name an instance when you run **more than one**.

The convenience form does the same thing through an env var:

```sh
GARDEN=petunias ./garden
```

This sets the container hostname **and** writes `.garden`, so the container is
built and named from that identity either way. The env var is **sugar over the
file**, and the file is the documented default. `GARDEN_CONTAINER` /
`GARDEN_HOSTNAME` remain as expert overrides; `GARDEN_SHARD` is a deprecated
alias for `GARDEN` for one release.

## How the fleet resolves the identity

Every fleet script resolves `GARDEN` as: **`GARDEN` env → the gitignored
`.garden` file → `hostname -s`** (`common.sh`). The durable file exists because
an **exported `GARDEN` does not reach the systemd `--user` units** — they are
started by the user manager, not your shell, so they read the file, not your
environment. That is the whole reason the name is written to disk rather than
left in the environment: set it at container-creation time so it lands in
`.garden`, and every unit sees it.

## The uniqueness check (the human's one answer)

The kernel hostname cannot be changed from inside a container (its capabilities
are zero), so the logical name is **fixed at container creation** via
`--hostname`/`--name` (both `GARDEN_CONTAINER`). During the tutorial the liaison
reads `.garden` and asks the single question only the human can answer: **"is
this name unique among your running garden instances?"** A default or a
collision is the only thing that needs fixing here.

## Rename, and the parallel-pool move

To **rename** an existing instance, reset and re-create it under the new name:

```sh
./garden reset
echo <unique-name> > .garden   # or: GARDEN=<unique-name> ./garden
./garden
```

For a **lighter, per-invocation** identity — a second follower pool on the same
machine, launched from a checked-out worktree with no Dockerfile change — just
export `GARDEN=<unique>` for that invocation. Set `GARDEN` at creation only when
a pool's identity must differ from its hostname.

Rationale for the container/hostname coupling and the resolution order lives in
`CLAUDE.md` § Host environment; this page is the operator's how-to.
