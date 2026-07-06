# The GARDEN shard identity

Every garden instance has one logical name — its **`GARDEN` shard identity** —
and it **must be unique across every running instance you own**. It keys job
claims, per-host worker counts (`hosts/<host>`), journal index entries, and the
leader marker; two instances sharing a name silently corrupt each other's
per-host state. The good news: you no longer set this name by hand. It is
**derived from where the checkout lives**, so it is unique by construction and
cannot drift. This page explains that derivation and how to run several
instances; the multi-host leader/follower mechanics that the marker gates are
`../operations/leader-follower.md`.

## Identity is the checkout's location

The launcher computes the identity at container creation from the checkout's
canonical path:

```
<hostname>-<basename>-<hash8>          e.g.  endolin-garden2-5bcdff64
```

- **`hostname`** — the host's short hostname, so instances on different hosts
  never collide in the shared journal.
- **`basename`** — the checkout directory's own name, the human-readable middle.
- **`hash8`** — the first 8 hex of the SHA-256 of the full canonical path, which
  disambiguates same-named directories at different paths on one host (e.g.
  `/srv/a/garden` vs `/srv/b/garden`).

There is **no `.garden` file and no environment knob** to seed, edit, or forget.
Because the id is a pure function of location and is pinned into the container's
`--name` and `--hostname` at creation, it can never drift away from the container
afterward — the failure that used to strand a container under a name matching no
checkout is now structurally impossible.

## Running more than one instance

Put each instance in **its own directory**. Distinct paths yield distinct ids,
distinct containers, and distinct (mirrored) homes automatically:

```sh
# two collaborating instances on one host — nothing to name:
( cd ~/garden  && ./garden create )    # -> <host>-garden-<hashA>
( cd ~/garden2 && ./garden create )    # -> <host>-garden2-<hashB>
```

The container **home is mirrored** to the checkout's own host path (e.g. a
checkout at `/srv/garden2` has `$HOME` = `/srv/garden2` inside the container), so
an absolute path means the same thing inside the container and out, and each
instance's credentials live in its own `.ssh` / `.config/gh` under that path.

## How the fleet resolves the identity

Every fleet script resolves `GARDEN` as: **`GARDEN` env → the gitignored
`.garden` file → `hostname -s`** (`common.sh`). With the location-derived scheme
there is no `.garden` file, so resolution lands on **`hostname -s`** — and the
launcher has pinned the container's `--hostname` to the computed instance id, so
every systemd `--user` unit sees exactly that id without any environment
plumbing. (An exported `GARDEN` still does not reach the `--user` manager; that
is why the id rides `--hostname` instead.)

## The uniqueness check (the human's one answer)

Within a host, uniqueness is automatic (distinct paths → distinct ids). The one
thing only you can guarantee is that your **hosts have distinct short
hostnames** — the cross-host tiebreaker in the shared journal. If two hosts share
a hostname, give one a distinct hostname (or use `GARDEN_HOSTNAME`, below) before
standing up the second.

## Rename, and expert overrides

To **rename** an instance, move (or re-clone) the checkout to a new path and
re-create the container; the id follows the new location:

```sh
./garden reset          # remove the old container
# move the checkout to its new path, then:
./garden                # re-create — new path yields the new id
```

`GARDEN_CONTAINER` and `GARDEN_HOSTNAME` remain expert overrides for the rare
case where the container name or logical id must differ from the location-derived
default (e.g. two hosts that unavoidably share a short hostname).

Rationale for the location-derived scheme and the home mirroring lives in
`CLAUDE.md` § Host environment; this page is the operator's how-to.
