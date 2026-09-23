No garden-library changes to commit — this job resolved to an investigation-and-surface outcome. Writing the completion report.

---

## Completion report: `endojs-endo-but-for-bots-pr621-weave-20260823`

**Outcome: the weave is MOOT — no rebase performed, finding surfaced to maintainer.**

### What I found
- PR endojs/endo-but-for-bots#621 is **already MERGED** — kriskowal merged it himself on **2026-08-25 09:52Z** (merge commit `1b26535`), four days before this weave job was promoted off the plan queue. You cannot rebase a merged/closed PR, so the weave premise no longer holds. I did **not** attempt a rebase or force-push.
- **The catch:** #621 was merged onto its **frozen snapshot base `llm-28dffa9`**, not live `llm` — the exact frozen-base discipline violation the skill warns about ("merging onto a snapshot means the trunk never absorbs the content"). I verified the content is stranded and never reached live `llm`:
  - `designs/endoclaw-oauth.md` on `llm` is still the 2026-03-03 version (`ee0bfc805`); the PR's refinements are absent.
  - `designs/caretaker-attenuation.md` does not exist on `llm` at all (no history).
  - No follow-up PR re-landed it; the merged tree sits only on branch `llm-28dffa9` (now tip `1b26535`).
  - `compare/1b26535...llm` = **diverged** (confirms `1b26535` is not an ancestor of `llm`).

### What I did
- Investigated PR/branch/blob state via the GitHub API (read-only, bot identity).
- **Surfaced to the maintainer** via the message bus (`inbox/maintainer`, msg `20260829T040600Z-c89130`): the weave is moot, and the OAuth-foundation design content is stranded on `llm-28dffa9`, absent from live `llm`, despite the green "Merged" badge.
- Recorded a project memory (`endo-pr621-merged-on-frozen-base`) so a future queued weave/rebase of #621 is recognized as moot, and capturing the general hazard: a maintainer's manual GitHub merge can land on a `<base>-<sha>` snapshot, silently stranding content off the trunk.

### Recommended follow-up (maintainer decision, NOT done here)
If the intent is to get this design onto the roadmap branch, it needs a **fresh re-land**: cherry-pick the 6 OAuth-foundation design commits (or the merged tree of `1b26535`) onto current `llm` (tip `059e18d0`), resolve the `designs/README.md` index conflict per the established convention, and open a new PR for approval. I offered to post that job on the maintainer's word; I did not post it autonomously, since a manual maintainer merge onto a frozen base is a discipline-sensitive situation that warrants the maintainer's call on approach.

The hand-off note in the job (rebase invalidates the 2026-08-01 approval, so a fresh approval is needed before conducting) is superseded — there is nothing left to conduct; #621 is closed/merged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr621-weave-20260823.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (784803 cached reads)
- Output: 12847 tokens
- Cost: $1.2464504999999997
- Wall-clock: 195s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
