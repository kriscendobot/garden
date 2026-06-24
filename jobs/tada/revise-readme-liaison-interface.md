Inbox empty; worktree removed. Work complete.

---

## Completion report

**Job:** `revise-readme-liaison-interface` — reframe `README.md` around *how a maintainer talks to the liaison*, with internals demoted.

**Commit:** `0abc27e26343bfd8abc85e7826d9cb30f8e670af` on `origin/main2` (pushed `51030653..0abc27e2`, bot identity `endolinbot`). Built in an isolated worktree off `origin/main2` per the infra-job discipline; committed an explicit pathspec; worktree torn down.

**New structure (through-line: intent → phrasing → effect):**
- **Intro** now states the one mental model up front — you *talk to* the garden, you don't operate it — and names the two equivalent surfaces (liaison session, or act on the PR) before anything about machinery.
- **§1 Getting the garden running** kept, with pure internals trimmed (the supervisory-service enumeration collapsed to a one-line parenthetical; health-check and bring-up steps preserved).
- **§2 Talking to the garden** is the rewrite: a maintainer-facing **catalog of intents**, each with an example phrasing and what it effects — *propose/design*, *build an implementation*, *fix or revise an open PR*, *merge*, *ferry upstream*, *adopt a repository* (fork / scholar ingestion), and *garden-meta requests* (encode a lesson, fix monitors, pause/scale services). Plain-language intent leads; the deterministic **verb primer** (gauntlet/rebase/weave/retcon/refresh/shepherd/ferry) follows as precise-but-optional vocabulary. A *Reviewing on the pull request* subsection establishes the PR surface as exactly as authoritative as the liaison.
- **Internals demoted** to a single **Going deeper** pointer block (CLAUDE.md, designs/, roles/, skills/, scripts/jobs/, WORKTREES.md). The old "How the garden is wired," "The journal" deep-dive, and "How the work gets done" tours are gone; only the maintainer-facing **dashboard** note survives.

**Accuracy notes:** I checked the just-landed `comment-watcher.sh` so the primer correctly scopes which verbs the watcher maps deterministically (rebase/retcon/refresh/shepherd/run-the-gauntlet) versus those that route through the liaison or require authorization (weave, ferry).

**Style:** Brought the file into `em-dash-style` compliance — the prior README carried 33 em-dashes; the new one has zero (converted to colons/periods per the skill). No Latin shorthand.

**Follow-ups:** Per the job's own note, a fuller pass folding in the newest services (journalist bulletin loop, proxy, foreman, cross-repo plan) is deferred until those settle — out of scope here. No other follow-ups.

**Self-improvement:** nothing this time.
