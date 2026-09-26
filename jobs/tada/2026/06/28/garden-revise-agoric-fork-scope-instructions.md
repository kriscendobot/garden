Completion report follows.

---

## Completion report: `garden-revise-agoric-fork-scope-instructions`

**Outcome: already satisfied on `origin/main2` — no new commit needed.**

When I created the isolated worktree off `origin/main2`, its tip was commit **`70997d2c7`** ("roles/CLAUDE: permit agoric/agoric-sdk fork experimentation, keep upstream comment-and-link-free"), pushed by a peer (endolinbot) ~3 minutes before I claimed. That commit implements exactly this job's revision, so I verified completeness rather than duplicating it.

### What the landed commit did (verified against the job spec)
- **`roles/COMMON.md`** — adds the canonical carve-out *"Project scope: `agoric/agoric-sdk`"* under § External-repo etiquette: clone/branch/build/test/run/read-only-analysis on the `kriscendobot/agoric-sdk` fork **permitted**; all *upstream* interaction (comments, reviews, reactjis, issue/PR opens/edits/closes, merges, and `Closes…`/`cc`/"Related to…" links — including from the fork) **forbidden**. Cites kriskowal, garden #9, 2026-06-28; explicitly does **not** grant an autonomous identity-switch or upstream ferry.
- **`CLAUDE.md:141`** — the @-mention-watcher line's "does not authorize any work on agoric-sdk, which stays off-limits" reworded to: read-only sender-trust check does not authorize *upstream interaction*; **fork experimentation is permitted** (points at the COMMON.md carve-out); upstream stays comment-and-link-free.
- **`roles/foreman`, `roles/liaison`, `roles/proxy`, `roles/triager`** — each "Never agoric-sdk / off-limits" line retargeted to *upstream `agoric/agoric-sdk` interaction only*, with the fork-experimentation permission referenced.

### Verification I ran
- Job's confirmation grep `agoric-sdk.*(off.limit|exclud|cannot|must not)`: the **only** remaining hit is the carve-out's own historical phrase ("widens the prior blanket 'agoric-sdk off-limits' posture") — a description, not a live ban.
- Broad sweep for `never agoric-sdk` / `no work agoric` (excluding upstream/posture descriptors): **zero** stale categorical bans.
- Out-of-scope sites correctly left intact: the upstream-comment constraints in `roles/boatman`, `roles/botanist`, `skills/pr-handoff` (all about *upstream* `agoric/agoric-sdk`), the `roles/designer` roadmap-branch carve-out, and the monitoring-safety repo-gating logic.

### Changes by me
None — work was already merged. Worktree created off `origin/main2` was torn down clean; no edits, no second commit (a duplicate would have been a no-op net-diff against an already-correct tree).

### Follow-ups
- None required. The job's deliverable is live at `origin/main2@70997d2c7`. The optional garden#9 follow-up comment is unnecessary since the peer's commit already references the directive; leaving it to the liaison's discretion.
