**Viability report: kriscendobot/minion.town PR #204**, "ci: run Claude-harness image builds only when harness inputs change"

The PR is still open and still needed, so the gauntlet can start.

- **State:** Open, unmerged, draft. Head `b82fe98f`, frozen base `main-945aaaa`.
- **Deciding question:** Does current `main` still build the `claude-harness-images` amd64/arm64 matrix on every PR with no path gate, and has no newer PR or commit already added one?
- **Evidence:**
  - **Nothing has displaced it.** `main` is exactly at the frozen base `945aaaa`: 0 commits ahead, 0 behind. So no newer base history could have replaced the change.
  - **The problem is still there.** On `main`, `.github/workflows/test.yml` still has the `claude-harness-images` job with no `changes` job, no `needs:` and no `if:` gate.
  - **No competing fix.** A search of the repo's PRs for "harness" finds nothing else gating these builds. #171 is a prod harness probe and #205 is #204's own "DO NOT MERGE" docs-only probe.
  - **The reason for it still holds.** The PR was opened today (2026-10-17). The repo has one self-hosted runner that runs one job at a time, and hosted minutes are billing-blocked until about 2026-10-30.
  - **No review activity yet.** The PR has no comments or reviews.

No changes were made and nothing was spent beyond these read-only checks. No follow-ups.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr204-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (120221 cached reads)
- Output: 1023 tokens
- Cost: $0.3936482
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
