# Harden against the jq outage: add jq to the image, fail loudly on missing tools

Wear the **mentor** role. ROOT CAUSE of a ~16h communications outage (2026-06-24
22:14 → 2026-06-25 14:40): **`jq` was not installed on the host**, and
`scripts/jobs/handlers/comment-source-gh.sh` pipes `gh api --paginate ... | jq ...`
to **external jq**, swallowing the error with `2>/dev/null || true`. A missing jq
therefore produced **silent empty output → "no new comments" → every PR
communication dropped**, for 16 hours, with no error surfaced. (Most other scripts
use gh's *built-in* `--jq`, so the rest of the fleet kept working — which is why
nothing else broke.) jq has been hot-installed (`/bin/jq`) to restore service;
this job makes it durable. Infrastructure on `main2` (bot identity; isolated
worktree off `origin/main2`).

## Fixes

1. **Add `jq` to the container image.** This host is a Docker container; the
   hot-installed jq is ephemeral (lost on rebuild). Add `jq` to the image's apt
   install (the `Dockerfile` the `garden` script builds). Verify a fresh build has
   jq.
2. **Fail loudly on a missing required tool.** Add a shared dependency check in
   `scripts/jobs/common.sh` (run at source time, or a `require_tools` helper) that
   verifies the fleet's hard dependencies — at least `git`, `gh`, `jq` — are on
   PATH and **dies loudly + surfaces an error entry / maintainer message** if one is
   missing. A missing tool must NEVER be silently swallowed. In
   `comment-source-gh.sh` specifically, add `command -v jq >/dev/null || die "jq
   missing"` before the jq pipelines, and **remove the blanket `2>/dev/null` that
   hides command-not-found** (keep stderr suppression only for expected empties, not
   for missing-binary errors).
3. **Audit other external-jq users.** Grep the scripts for `| jq ` (external jq
   pipes, as opposed to gh's `--jq`) and ensure each fails loudly on missing jq or
   is converted to gh's built-in `--jq` where feasible.
4. **Anomaly detection (so 16h never happens again).** A producer that reports
   **zero results for many consecutive runs while its source is demonstrably active**
   is a red flag. Add a check (in the mentor's sweep, or the watcher itself) that
   surfaces "comment-watcher advanced 0 / found 0 comments for N consecutive ticks"
   as an anomaly to the maintainer inbox — a silent watcher is the failure mode that
   hid this outage.

## Tests & verification

- A test that `comment-source-gh.sh` (or `require_tools`) **exits nonzero loudly**
  when jq is absent (simulate by PATH-masking jq), rather than emitting empty.
- Confirm a fresh image build contains jq. `shellcheck`/`bash -n` clean.

## Definition of done

jq added to the container image; common.sh/comment-source fail loudly on a missing
required tool (no more silent swallow); external-jq users audited; a zero-result
watcher anomaly is surfaced; tests added — committed and pushed to `origin/main2`.
Report the SHA and the anomaly-detection mechanism. If blocked, report the diagnosis
and ready-to-apply change rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 24
  claimed_at: 2026-06-25T14:45:24Z
