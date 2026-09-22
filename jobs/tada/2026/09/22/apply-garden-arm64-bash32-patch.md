Both fixes landed cleanly and pushed to `main2`.

## Completion report

Applied the `garden-arm64-bash32-fixes.patch` to `main2` in the isolated per-job worktree. The patch applied cleanly against the current tip (`da07ac7ee6`) — both hunks matched the unpatched code exactly.

**Fixes landed:**

1. **`garden` launcher** — replaced `"${dns_args[@]}"` and `"${api_key_args[@]}"` with the portable `${arr[@]+"${arr[@]}"}` idiom. Confirmed the bug is real: `garden` runs under `set -euo pipefail` (line 5), so on bash 3.2 (macOS stock) expanding an empty array member with `"${arr[@]}"` raises `unbound variable` and aborts container bring-up. Verified this is the repo's standing convention — the same idiom already appears in `scripts/jobs/bulletin.sh`, `journal-entry.sh`, and `gardening/ensure-pr.sh`.

2. **`provision-moddable-xst.sh`** — added `Linux:aarch64|Linux:arm64) asset=xst-lin64arm.zip`. Previously only `x86_64/amd64` was recognized, failing on Linux/aarch64 (Docker Desktop on Apple Silicon, e.g. `oros-studio-garden-ce242c49`).

**Validation:**
- `bash -n` syntax check passed on both files.
- **Asset filename confirmed correct** — queried the Moddable GitHub releases API (9.5.0); `xst-lin64arm.zip` is a real published asset alongside `xst-lin64.zip`. No correction needed.
- Demonstrated the empty-array behavior: both old and new idioms are safe under bash 5.2 (this host), and the new form correctly passes through zero args when empty and all args when populated. The 3.2-specific failure couldn't be reproduced live (only bash 5.2 available), but the fix matches the repo's own established bash-3.2 compatibility pattern.

**Pushed commit:** `ebfff9b84e` → `origin/main2` (clean push, no rebase contention).

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/apply-garden-arm64-bash32-patch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (525696 cached reads)
- Output: 5466 tokens
- Cost: $0.850525
- Wall-clock: 107s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
