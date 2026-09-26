Working tree clean; nothing pushed. The job's deliverable already lives on `main2` (commit `38d951e65c`, ancestor of current tip `25eec87417`), verified passing. Standing down rather than pushing a redundant second mechanism.

---

**Completion report — fix-systemd-api-key-handoff-20260725**

**Outcome: already resolved upstream by a concurrent peer; verified, no push made.**

While I built this fix, a peer worker landed the identical job on `main2` as commit `38d951e65c` ("fix: hand off API keys to lingering user manager"). My rebase-CAS push surfaced it via conflicts on all four shared files. I aborted cleanly (no corruption; worktree clean) and verified the merged fix rather than pushing a competing duplicate.

**What the merged fix does (and how it meets the spec):**
- **Boot-time handoff:** `entrypoint.sh` calls `/usr/local/lib/garden/seed-api-key-handoff.sh` (installed via Dockerfile) before exec'ing PID 1, with the container-creation env in scope.
- **Mechanism:** seeds `/run/environment.d/60-garden-api-keys.conf`, read by systemd's *built-in* `environment.d` user generator before `user@<uid>.service` starts — so `systemctl --user` units inherit the keys the PAM-fresh manager otherwise misses. (Reuses the built-in generator instead of shipping a bespoke one; matches the `environment.d` path `common.sh` already documents.)
- **Tmpfs-only:** `/run` is a Docker tmpfs; the helper writes nothing to the bind-mounted home, repo, unit files, or logs. File is `root:<user>` mode 0640 — readable only by the user manager.
- **Allowlist-only:** hardcoded loop over `ANTHROPIC_API_KEY`/`MOONSHOT_API_KEY` only, never enumerating the env — plus a base64url charset guard that rejects any value that could be reinterpreted as `environment.d` syntax (an injection defense).
- **Both keys covered; comments corrected** in `garden`, `context/operations/kimi-k3.md`, and the Mystic preflight message in `kimi-provider-common.sh`.
- **Regression test** `scripts/jobs/test/api-key-handoff-test.sh` — I ran it against the merged tree: **7/7 pass** (allowlist enforced, absent-key omission, no bind-mount write, group-only readability, syntax-bearing key rejected).
- **Presence-without-values** documented via `systemctl --user show-environment | grep -q '^ANTHROPIC_API_KEY='`.

**Verification I performed:** confirmed the two failing `tests/checks` suites (`maintainer-inbox-information-hiding`, `run_all`) fail identically on the pristine baseline and are unrelated pre-existing leaks in role/skill files; the CI `bash -n` sweep passes; the upstream handoff test passes on the merged tree.

**Changes pushed:** none. My local commit `6ffa84bc5b` (an independent equivalent implementation using a custom user-environment-generator + `/run/garden` seed) is left unpushed and GC's with the worktree — pushing it would introduce a redundant second handoff mechanism.

**Follow-ups:** none functional. Deploying the fix requires an image rebuild (`./garden build`) since `entrypoint.sh`, the Dockerfile `COPY`, and the helper are image-baked, followed by secret-safe container recreation per `context/operations/kimi-k3.md`.
