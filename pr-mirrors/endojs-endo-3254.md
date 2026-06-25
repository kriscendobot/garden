---
upstream: endojs/endo#3254
mirror: endojs/endo-but-for-bots#530
upstream_repo: endojs/endo
upstream_number: 3254
mirror_repo: endojs/endo-but-for-bots
mirror_number: 530
mirror_head_sha: 760f0b5e60ab2b072c483120b1a3b4eabbff8b55
created_at: 2026-06-25T17:08:12Z
created_by: gardener job mirror-and-shepherd-endo-3254 (endolinbot/gardener-8)
method: cross-fork mirror (frozen-base branch master-6e4ddff snapshot of endojs/endo@master; upstream PR head pushed verbatim as mirror/3254-browser-test-config)
status: open
---

Mirror mapping for the `garden-mirror-closer` service.

Upstream pull request **endojs/endo#3254** ("chore: harden browser-test installation"
by naugtur) is mirrored onto **endojs/endo-but-for-bots#530** so the garden can run CI
against the change where the bot has direct push.

When the upstream PR (endojs/endo#3254) closes, the mirror-closer service should close
the mirror PR (endojs/endo-but-for-bots#530) with a comment, if it is still open.

Schema note (for build-mirror-closer-service / gardener-4): machine fields live in the
YAML frontmatter as flat `key: value` pairs. The two canonical fields are
`upstream: <owner>/<repo>#<N>` and `mirror: <owner>/<repo>#<M>`; the split
`*_repo` / `*_number` fields are provided for convenience if you prefer parsing those.
File is named `pr-mirrors/<upstream-owner>-<upstream-repo>-<N>.md`.
