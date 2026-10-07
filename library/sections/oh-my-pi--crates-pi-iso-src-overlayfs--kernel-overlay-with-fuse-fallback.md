---
title: Linux overlayfs backend with a fuse-overlayfs fallback
source: crates/pi-iso/src/overlayfs.rs
source_repo: can1357/oh-my-pi
source_commit: 5b5b65ec0081db10415204989c7dffa7ff4a73ee
source_date: 2026-10-06
source_authors: [can1357, Brit, metaphorics]
ingested: 2026-10-07
ingested_by: scholar
topics: [sandbox-platforms, file-systems, agent-workspaces]
status: current
---

> Abstract: The `Overlayfs` backend mounts a kernel `overlay` filesystem at `merged` over a read-only `lower`, with sibling `upper` and `work` directories so a single caller-owned base directory cleans up with one `rm -rf`. When the kernel refuses the mount (`EPERM`, `EACCES`, `ENODEV`, `ENOENT`, or `EINVAL`), it falls back to `fuse-overlayfs(1)`. It remembers which flavor each mount used so `stop` picks `umount2` or `fusermount[3] -u`.

## Module contract

The header: the backend "tries to stack a kernel `overlay` filesystem at `merged` over the read-only `lower` tree. The mount uses sibling `upper` and `work` directories derived from `merged.parent()` so a single caller-owned base directory cleans up with one `rm -rf`." When the kernel rejects the mount ("typically `EPERM` outside a user namespace, or `ENODEV` if the module is absent"), it falls back to `fuse-overlayfs` "because that is what the project shipped before and existing user environments rely on it." Backend selection "is remembered per-mount so `stop` dispatches to the correct teardown path (`umount2` vs `fusermount[3] -u`)."

## Probe

`probe()` reports available if `/proc/filesystems` lists `overlay`, or if `fuse-overlayfs --version` runs. A successful fuse probe is cached for the life of the process ("a host that has it keeps it"). A failure is not cached, because the tool "can be installed while a long-running session is up, so the next probe spawns again." When neither is present, the probe is unavailable: "kernel `overlay` module missing and `fuse-overlayfs` not on PATH".

Note that the probe checks whether the kernel *supports* overlay, not whether this process may mount one. Unprivileged processes outside a user namespace therefore usually reach the fuse path at `start` time, not at probe time.

## Start and stop

- **Start** canonicalizes `lower`, removes any stale `upper`, `work`, and `merged`, recreates them, and calls `mount("overlay", merged, "overlay", 0, "lowerdir=…,upperdir=…,workdir=…")`. The five errnos above become an *unavailable* error, which triggers the fuse fallback. Any other errno is a hard error.
- **Stop** looks up the remembered flavor. Fuse mounts go to `fusermount3 -u`, then `fusermount -u`, and finally a lazy kernel unmount as a last resort. Kernel mounts, or an unknown flavor after a crash or re-attach, try `umount2(MNT_DETACH)` first and fall back to fusermount when the kernel denies it, "so we don't silently leak a mount." `EINVAL`/`ENOENT` on unmount means "already torn down." Stop then removes `upper`, `work`, and `merged`.

## Boundary note

Like every `pi-iso` backend, overlay controls which tree a workload sees and where its writes land (in `upper`). It does not confine process authority: a process in `merged` can still reach the rest of the host. See [cross-platform copy-on-write workspaces](oh-my-pi--crates-pi-iso-src-lib--cross-platform-copy-on-write-workspaces.md).

Source: [crates/pi-iso/src/overlayfs.rs](https://github.com/can1357/oh-my-pi/blob/5b5b65ec0081db10415204989c7dffa7ff4a73ee/crates/pi-iso/src/overlayfs.rs) at commit `5b5b65ec`.
