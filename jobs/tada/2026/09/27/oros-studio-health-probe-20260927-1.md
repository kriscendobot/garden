Health probe report for `oros-studio-health-probe-20260927-1`, run on host oros-studio-garden-ce242c49 with the mentor tier (claude-opus-5-5). This handler got past startup and finished all three checks, so the old instant API 400 did not happen.

1. **`claude --version`** printed `2.1.283 (Claude Code)`. That is the updated CLI, not the old 2.1.267.
2. **Syntax checks** in the per-job worktree:
   - `bash -n scripts/jobs/gardener.sh` → exit 0
   - `bash -n scripts/jobs/common.sh` → exit 0
3. **`is_model_unsupported_signature`**: `grep -c` in `scripts/jobs/common.sh` finds **2** matching lines. The function is defined at line 5222 (`is_model_unsupported_signature() {`), and line 1947 mentions it in a comment.

No files were modified and nothing was pushed. No follow-ups: this mentor-tier claim on the host worked, which is the validation `oros-studio-health-restoration` needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-studio-health-probe-20260927-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (53525 cached reads)
- Output: 588 tokens
- Cost: $0.264969
- Wall-clock: 13s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
