#!/bin/bash
# A request-changes seat with multiline evidence and an approving seat whose prose
# must not inflate the focused fixer aggregate.
set -euo pipefail

case "${1:?seat}" in
  assessor)
    cat <<'EOF'
**Verdict:** request-changes

**Findings**

1. **must-fix:** the state transition can lose the durable receipt.
   - `src/state.js:42` mutates memory before the durable append completes.
   - Await the append first, then publish the in-memory state.
   - This continuation line is required evidence, not a title suffix.
EOF
    ;;
  *)
    cat <<'EOF'
**Verdict:** approve

**Findings**

- APPROVING_SEAT_CONTEXT_MUST_NOT_REACH_FIXER
EOF
    ;;
esac
