Done. All fixes implemented, tested, and pushed.

---

## Completion report — `harden-jq-and-loud-tool-failure`

**Pushed to `origin/main2`: SHA `1a52c9bb`** (one commit, bot identity `endolinbot`).

### Root cause confirmed
`jq` was absent from the host; `comment-source-gh.sh` piped `gh api | jq` to **external** jq under a blanket `2>/dev/null || true` that swallowed the shell's "command not found". Missing jq → silent empty output → "no new comments" → every PR communication dropped for ~16h, with no error. The rest of the fleet uses gh's **built-in** `--jq`, which is why nothing else broke.

### What changed
1. **jq in the container image** — added `jq` to the apt install in the top-level `Dockerfile` (the one `garden build` builds), with a comment marking it a hard runtime dependency. Previously only ever hot-installed, so a rebuild would have reintroduced the gap.
2. **Loud missing-tool guard** — new `require_tools git gh jq …` helper in `common.sh`: logs `FATAL`, best-effort surfaces a **throttled** maintainer-inbox message via the new `alert_maintainer` helper, and `exit 1`. Wired into both external-jq users (`comment-source-gh.sh`, `mention-source-gh.sh`) **before** the jq pipelines. Removed the jq-segment `2>/dev/null` that hid command-not-found (kept gh's expected-empty suppression). Also fixed `comment-watcher.sh` to surface the source's stderr on failure instead of `2>/dev/null`-ing it.
3. **External-jq audit** — `grep '| jq'` finds exactly two users (`comment-source-gh.sh`, `mention-source-gh.sh`); both are now `require_tools`-guarded. Every other script uses gh `--jq` (Go-internal, always present with gh).
4. **Anomaly detection** — `comment-watcher.sh` tracks a durable consecutive-zero-result streak. Once it crosses a threshold (default 20), it cross-checks with an **independent** `gh api … --jq 'length'` probe (a different code path than the external jq that broke). If the repo is demonstrably active while the watcher keeps finding nothing, it fires a **throttled** maintainer anomaly: *"found 0 comments for N consecutive ticks but the repo IS active — the watcher may be silently blind."* That is exactly the signature that hid this outage.

### Anomaly-detection mechanism (as requested)
Silent-blind detector lives in the watcher: `zero_streak ≥ threshold` **AND** an independent gh-builtin-`--jq` activity probe returns active → `alert_maintainer "silent-comment-watcher-<slug>"` (throttled to once/hour/key via a local marker, so a per-minute loop can't flood the inbox).

### Tests & verification
- `comment-watcher-test.sh`: **26/26 pass**, including 3 new cases — (H) PATH-masked jq makes `comment-source-gh.sh` exit nonzero, name jq on stderr, emit no stdout; (I) zero results + active probe → exactly one throttled anomaly; (J) zero results + quiet probe → no false anomaly.
- `require_tools` positive/negative paths verified directly; `shellcheck` and `bash -n` clean on all changed files (only pre-existing project-wide warnings remain).
- Worktrees and scratch dirs torn down; inbox drained (empty).

### Follow-ups / caveats
- **Could not run a real `docker build`** to confirm jq in a fresh image: Docker is unavailable *inside* this container (we are the container). The Dockerfile edit is verified in the correct apt block with proper continuation and `jq` is the correct Debian package; the build runs on the Docker host via `garden build`. Recommend a maintainer confirm `garden build && docker run … jq --version` on the host at next rebuild.
- `mention-source-gh.sh` already had a manual `command -v jq || die` guard (unified to `require_tools`), which is why the GitHub-wide mention watcher kept working through the outage.
- The build was done in an isolated worktree under `/home/kris` (not `/tmp`, which is `noexec` here — scripts can't execute from it).
