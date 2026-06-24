# Add a capture-and-hash helper to scripts/jobs/common.sh

Per designs/self-healing-audit.md (Part B, the common.sh foundation): the v2
service fleet has no shared way to capture-and-hash failure output, so every
service inlines $(cat "$digest") into the claude -p prompt.

Add to scripts/jobs/common.sh a `capture_blob <file> [<clone-dir>]` (prints the
blob SHA via `git -C <dir> hash-object -w --stdin`) and an `inspect_note <sha>`
helper that prints the one-line `git cat-file -p` brief a responder uses.
Resolve the local-clone-vs-cross-host nuance the audit flags: a blob hashed in a
service's own $GARDEN_STATE/<svc>/journal clone is local until pushed; document
when to anchor/push for cross-host (mentor) inspection. Must be shellcheck and
`bash -n` clean. Build in an isolated worktree off origin/main2.

---
claim:
  host: endolinbot
  gardener: 76
  claimed_at: 2026-06-24T19:58:22Z
