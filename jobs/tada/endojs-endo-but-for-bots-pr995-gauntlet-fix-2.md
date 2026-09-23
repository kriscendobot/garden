CI is GREEN (rc 0). The round-2 must-fixes were applied and pushed in the prior attempt of this fix iteration; I verified completeness, confirmed the working tree is clean and pushed, and watched CI to a terminal green state.

## Completion report

**Job:** endojs/endo-but-for-bots PR #995 — gauntlet FIX round 2 (docs-only design PR for `designs/endo-claude.md`).

**State on claim:** This was a requeue/resume. The prior attempt of this same fix iteration had already applied the panel-2 must-fixes and pushed them as commit `5775f93dc` ("design(endo-claude): apply panel round-2 must-fixes") to `origin/design/endo-claude`, before the run was interrupted.

**What I did:**
- Read the latest panel verdict (request-changes / must-fix, round 2) on the PR.
- Verified commit `5775f93dc` addresses all 8 convergent must-fixes, mapped 1:1 in its commit message: argv injection (stdin delivery + pre-spawn order assert), unvalidated allow-list names (`/^[A-Za-z0-9_-]+$/`, fail-closed), open deny-set ellipsis (`--tools ""` fail-closed baseline + version pin), `--bare` misattribution correction, `ClaudeCredentials` reuse falsification + new-kind extension, stdio-shim socket over-grant (harness holds facet, scrub `ENDO_SOCK`), generated-file hygiene (0600 exclusive-create, unlink on crash), and the hardcoded socket path (cite `whereEndoSock`). Should-fixes and doc-hygiene items handled too.
- Confirmed working tree clean, HEAD == `origin/design/endo-claude`, and the new `endo-claude.md`/README content is free of typist-hostile code points (residual `…`/`→` matches are all pre-existing historical README prose, not this PR's additions).
- Watched CI bounded: **5 checks, 0 failed → CI GREEN** (rc 0).

**Changes pushed this stage:** none new — the required fix was already committed and pushed; no further edits were warranted.

**Follow-ups:** none. Driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 130 tokens (7231408 cached reads)
- Output: 55863 tokens
- Cost: $7.000685999999999
- Wall-clock: 955s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
