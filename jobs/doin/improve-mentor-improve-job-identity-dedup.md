Give mentor-emitted jobs a stable directive identity so re-detections of the same recurring failure collapse onto one open job regardless of the (LLM-chosen, non-stable) slug. In `scripts/jobs/handlers/mentor-claude.sh`, derive a deterministic identity per JOB block and pass it through: `post-job.sh --identity "mentor:<key>" "$base"`, where `<key>` is stable across ticks for one failure — e.g. the normalized `[tag] WARN <template>` signature (strip timestamps/PIDs/volatile paths) of the journalctl line the job addresses, or, when the body names one script, `mentor:<script-basename>`. To make the key derivable deterministically, extend the mentor prompt/role brief (`roles/mentor/AGENT.md`) to require each JOB block to name the single implicated script path on its first line, and parse that path as the identity. `post-job.sh` already dedups on `--identity` via the `jobs/index/<hash>` map (skipped today because self-improvement bodies carry no comment URL and no `--identity` is passed), so this closes the gap that let 129 `improve-*` jobs — many of them the same directive under different names — pile up in `jobs/tada/`.

---
claim:
  host: endolinbot2
  gardener: 18
  claimed_at: 2026-07-03T05:55:09Z
