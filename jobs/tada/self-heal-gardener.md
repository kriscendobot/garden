Done. Worktree and test scratch removed; the change is on `origin/main2` at `b180653e`.

---

## Completion report — `self-heal-gardener`

**What I did.** Fixed the highest-value Part-A gap from `designs/self-healing-audit.md`: `scripts/jobs/gardener.sh` was discarding a failing job handler's stdout/stderr and completing the failed job `doin→tada` (recording a failure as *done*).

**What changed** (`scripts/jobs/gardener.sh`, 1 file, +34/−7):
- The handler's combined stdout+stderr is now diverted to a `capture` temp file (`>"$capture" 2>&1`) instead of vanishing into the gardener's systemd journal.
- On non-zero exit, the failure path now:
  1. **Captures by hash + escalates** via the canonical, just-landed `skills/gardener-inbox-error-reporting/report-error.sh` (`--lane 0`, the worker-script form), which hashes the transcript and appends a section to the gardener inbox (`inboxes/<host>/gardener.md`), pushed to `journal2`. I point it at the gardener's *own* clone (`GARDEN_JOURNAL="$CLONE"`) to avoid racing the shared journal worktree.
  2. **Anchors** the same blob under `refs/captures/gardener/<id>/<base>` (`anchor_blob`) so an off-host responder can fetch it even if the inbox push is lost; falls back to a bare `capture_blob` if the inbox escalation itself fails.
  3. Posts an `error` journal entry (mentor-visible — `mentor.sh` scans `entries/`).
  4. **Does not complete the job** — leaves it in `doin` for the existing reaper's stale-claim requeue, so a failure is no longer recorded as `tada`.
- The success path is unchanged except the "completed" progress entry now fires only on success.

**Verified** with isolated throwaway-journal smoke tests (both failure and success), since the live gardener-78 service env leaks into the shell and `/tmp` is `noexec`:
- Failure: job stays in `doin` (tada=0), inbox section + `error` entry + `refs/captures` anchor all carry the same SHA, and the fetched blob contains **both** stdout and stderr markers.
- Success: still claims → completes → `tada`, with the handler's stdout correctly diverted (not leaking into the report).
- `bash -n` and `shellcheck -x` clean (only pre-existing SC1091/SC2034 noise, unrelated to the edit).

**Open question surfaced (maintainer decision).** The permanent failed-job lane — requeue→`todo` immediately, a dedicated `jobs/failed/` lane, or leave-for-reaper (what this change does) — is a gardening-state-machine design decision, called out both in the audit's recommendations and in a new inline `OPEN` comment in the failure branch. **Tradeoff to weigh:** leave-for-reaper means a *deterministically*-failing job is re-claimed after `GARDEN_CLAIM_TTL` (default 1h) and will fail + escalate again on a slow loop. That's the cost of not picking a terminal lane here.

**Follow-ups noted:**
- The reaper (`reaper.sh`) does not clean up `inbox/<base>` when requeuing a stale `doin` claim — a pre-existing minor leak, now slightly more reachable since failed jobs dwell in `doin`.
- Sibling audit jobs `self-heal-common-capture-helper` (capture helpers in `common.sh`) and `self-heal-port-capture-skills` (v2 `report-error.sh` + skills) both landed on `main2` during this work and are now consumed by this change; `self-heal-mentor-capture` (Part-B #2) remains.
