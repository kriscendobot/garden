---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
title: §Path-based-not-inode-based with §openat-as-future-strengthening
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

§Design-Decision-8 is the §honest-limitation-disclosure:

> *The current design binds a mount, file, or directory exo
> to a *path*, not to an underlying inode. ... on platforms
> where the daemon runs under a supervisor with access to
> POSIX `openat` and the rest of the `*at` family ... we
> could open a directory file descriptor at mount time and
> perform all subsequent operations relative to that
> descriptor, pinning the exo to a specific inode
> regardless of path-level motion.*

§Named-limitation-with-named-future-fix. §Today's-Node.js-
fs-API-opens-by-path; future XS/Rust-supervisor with
§POSIX-`*at`-family enables §inode-pinning.

§The-`*at`-family enumerated: `openat`, `renameat`,
`fstatat`, `mkdirat`, etc. §Operations-relative-to-an-
already-opened-directory-fd-cannot-be-redirected-by-
post-hoc-symlink-changes.

§Discloses-current-vulnerability: if backing file/directory
is moved or replaced at the OS level, the exo follows the
*path*, not the original inode. §Path-following-not-
inode-pinning is the current behavior.

§Future-strengthens-confinement-on-supporting-platforms.
§This-is-the-shape-of-a-§future-hardening-target.
