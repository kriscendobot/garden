The job is a no-op — the fix already exists on `main2`. No code change or push is needed.

---

## Completion report

**Task:** Convert the bare cursor-read command substitution in `scripts/jobs/issue-inbox-watcher.sh` to a fail-open rc-capture, matching the triager.sh pattern, so a `cursor-get.sh` nonzero exit can no longer trip `set -e` and silently kill the unit.

**Finding: already fixed on `main2`.** The exact fail-open pattern the job specifies is already present at lines 507–513 of the current file (my worktree is checked out from `origin/main2` at HEAD `f26efdea35f`):

```sh
if cursor_out="$("${CURSOR_STAGE_TIMEOUT[@]}" "$HERE/cursor-get.sh" "$CURSOR_KEY")"; then rc=0; else rc=$?; fi
if [ "$rc" -ne 0 ]; then
  [ "$rc" -eq "${GARDEN_OFFLINE_RC:-75}" ] \
    || log "WARN: cursor read failed for $CURSOR_KEY (rc=$rc); skipping this tick"
  exit 0
fi
last_seen="$(printf '%s\n' "$cursor_out" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"
```

It even exceeds the spec: it skips *quietly* on `GARDEN_OFFLINE_RC` (75) and uses a dedicated `CURSOR_STAGE_TIMEOUT` so the helper's own cursor-IO-lock wait isn't clipped to a loud rc=124.

**Provenance:** introduced in `df83fca2355` (2026-09-19, "fix(jobs): fail open on nonzero cursor-get.sh rc in issue-inbox/comment/mention watchers"), refined in `1d7a9fc94a4` (2026-09-22). The same bug class was fixed in `triager.sh` (73c2432e89, b320648e47), as the job noted.

**Why the job existed anyway:** this was a self-heal-fix job promoted from plan on 2026-09-27/29 — *ten days after* the fix landed. The observed silent-exit-1 crash came from a deployed `garden-issue-inbox` unit lagging `main2`, not from the source at HEAD. This is the same deploy-lag/already-fixed pattern as the receipt-watcher and ci-watcher self-heal jobs.

**Changes made:** none to the codebase (working tree clean, nothing to commit or push). Recorded a memory pointer (`issue-inbox-watcher-cursor-get-failopen-fixed`) so the next occurrence is recognized as deploy-lag rather than re-investigated.

**Follow-up:** confirm the affected host's deployed garden root has caught up to `main2` (≥ `df83fca2355`); if the unit was still crash-looping, a deploy — not another source fix — is the remedy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-issue-inbox-cursor-get-failopen.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (2 unmetered)
- Input: 18 tokens (440029 cached reads)
- Output: 4783 tokens
- Cost: $0.8138394999999999 (2 engagement(s) unpriced)
- Wall-clock: 111s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
