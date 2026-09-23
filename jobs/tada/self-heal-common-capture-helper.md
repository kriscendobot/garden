Done. Worktree removed; the cwd error was just the shell sitting in the deleted directory.

---

**Completion report — `self-heal-common-capture-helper`**

**What I did:** Added the shared git-content-store failure-capture helpers to `scripts/jobs/common.sh`, per `designs/self-healing-audit.md` Part B (the common.sh foundation). Built in an isolated worktree off `origin/main2`, committed with an explicit pathspec, and pushed `HEAD:main2` (commit `40035765`). Worktree torn down.

**What changed (66 insertions, one file):**
- `capture_blob <file> [<clone-dir>]` — `git -C <dir> hash-object -w --stdin < <file>`, printing the blob SHA; defaults `<clone-dir>` to the caller's per-service `$DIR` clone (the convention every v2 service already uses).
- `inspect_note <sha> [<clone-dir>]` — prints the one-line `inspect via: git -C <dir> cat-file -p <sha>` brief a responder pipes through `grep`/`tail`/`sed` instead of inlining the log body.
- `anchor_blob <sha> <ref-suffix> [<clone-dir>]` — extra helper that pushes the loose blob under `refs/captures/*` so an off-host responder can fetch it; logs and returns non-zero on rejection (blob stays safe locally).

**Cross-host nuance resolved (the audit's open judgment call):** a header comment block documents that `hash-object -w` writes to the *local* object DB of the service's own `$GARDEN_STATE/<svc>/journal` clone only — reachable same-host but not on origin and not visible to the central mentor on another host. It spells out the two durable routes to make a SHA reachable off-host: (1) the default — write the SHA into a *committed* board/inbox file and let the normal CAS push carry the blob (what v1 `report-error.sh` does); (2) `anchor_blob` to push the loose blob under a ref when you need it reachable without a committed escalation. A same-host-only capture needs neither.

**Verification:** `bash -n` clean; `shellcheck` introduces zero new findings — the only warnings (SC2034/SC2010 at lines 170–177) are pre-existing code shifted down by the insertion, present identically on `origin/main2`. The `${DIR:?…}` defaults keep the helpers `set -u`-safe.

**Follow-ups (not in scope here, already posted by the audit):** `self-heal-port-capture-skills` (port the v1 capture skills + `report-error.sh` to `journal2`), `self-heal-gardener`, and `self-heal-mentor-capture` are the consumers that should adopt these helpers. The `anchor_blob` `refs/captures/*` convention is new surface those jobs (and a future `self-healing-wrapper` skill) may want to standardize on.
