---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mentor-claude.sh

`validate_mentor_response` gates a JOB block's first body line on a hardcoded extension allowlist — `^[A-Za-z0-9_./-]+\.(sh|py|js|ts|md|service|timer)$` (line 145) — which rejects legitimate **extensionless** repo-relative paths. Observed failure signature (`.garden-state/mentor/rejected/20260806T062044.577980790Z-openai.txt`):

    FATAL: mentor provider 'openai' returned malformed semantic output
    (JOB 'improve-browser-image-dependency-contract': first body line is not a
    repo-relative script/unit/brief path: garden); refusing fallback

`garden` is the tracked, executable repo-root container launcher; `Dockerfile` — the other file that job addresses — fails identically. Since a semantic rejection deliberately refuses fallback (correct) and `mentor.sh` leaves the digest markers for retry, this wedges `garden-mentor` in a systemd restart loop that re-derives the same correct job and re-rejects it forever, posting nothing.

Change the first-line check from "matches an extension allowlist" to "**names a path that actually exists in the repo**": keep the current regex as a cheap accept fast-path, and otherwise accept `first` when `git -C "$GARDEN_ROOT" cat-file -e "origin/main2:$first"` (or `[ -e "$GARDEN_ROOT/$first" ]`, no git in `$GARDEN_ROOT` beyond the read-only query already used by `already_fixed_pending_deploy`) succeeds. Keep rejecting prose — a first line with spaces, or a path present nowhere in the tree — so the fail-closed guarantee against ambiguous blocks is preserved, and keep `mentor_reject_reason` naming which check failed.

Mirror the widening in `already_fixed_pending_deploy` (line 286): its `grep -oE '...\.(sh|md|py|js|ts|service|timer)'` cannot extract `garden` or `Dockerfile` from a body, so the pending-deploy pre-filter under-matches for exactly the jobs this bug surfaced. Add the extensionless well-known roots (at minimum `garden`, `Dockerfile`) to that token extraction.

Separately, add a **loop backstop** so no future semantic rejection can wedge the service indefinitely: count consecutive rejections against the same digest SHA in `$GARDEN_STATE/mentor` and, past a small threshold (~3), advance the marker and escalate once to the maintainer inbox rather than re-running the identical digest forever. Verify with a unit-style check that a body whose first line is `garden` or `Dockerfile` validates and emits, that `A prose sentence here.` still rejects, and that a nonexistent `scripts/jobs/nope.sh` behaves as today.
