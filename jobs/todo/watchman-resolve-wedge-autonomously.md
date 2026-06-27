# Watchman: resolve dirty-tree wedges AUTONOMOUSLY (no maintainer escalation)

Map: **build** (garden infra) on the garden's own repo, branch main2. Build in an
ISOLATED worktree off origin/main2; commit explicit pathspecs (`git commit -m … --
<paths>`); push HEAD:main2 via a git-rebase CAS loop.

Maintainer directive 2026-06-27: **"the watchmen needs to solve these problems
autonomously and the maintainers do not need to be in the loop."** The watchman
must NOT page the maintainer when the shared /home/kris main2 tree is wedged by
uncommitted tracked changes (or an untracked file colliding with an incoming
tracked path). These wedges recur constantly under the live fleet and flooded the
maintainer inbox on 2026-06-27; they are mechanically resolvable.

## Current behavior to replace
`scripts/jobs/watchman.sh` → `notify_dirty_wedge()` sends a maintainer message via
`message-user.sh watchman-dirty-tree` ("Verify these are not unsaved work, then
clean the tree"). Both call sites (tracked-changes-block and untracked-collision)
route there. The `deploy-sync.sh` reconciler has the same skip-and-wedge gap.

## Required behavior
On a dirty-tree wedge, the watchman triggers AUTONOMOUS RESOLUTION instead of
emailing the maintainer:
- Post an idempotent-per-(host+state) high-priority resolve-wedge job to the board
  (post-job), OR spawn a claude-driven resolver inline (the self-heal pattern). A
  posted job is preferred (robust, retryable, claimed by the running fleet — note
  the fleet keeps running even when main2 is wedged, since the wedge only blocks
  picking up NEW code).
- The resolver investigates each blocking change and resolves it the way a finisher
  did successfully on 2026-06-27:
  * TRACKED change byte-identical to origin/main2 → lossless `git checkout -- <file>`.
  * UNTRACKED file byte-identical to its incoming origin/main2 tracked version →
    `rm` it (lossless; it is a redundant local copy of landed work).
  * GENUINE WIP (differs from both HEAD and origin) → PRESERVE: land it (isolated
    worktree, explicit-pathspec commit, rebase CAS) if coherent, else `git stash`
    and post a follow-up to land it. NEVER a blind `git reset`/`checkout .`; touch
    only the specific blocking file(s); if any other tracked file is unexpectedly
    dirty, stop and re-survey.
  * Then the tree is clean → the watchman/deploy-sync fast-forward proceeds.
- Reading the garden's OWN uncommitted code is safe (not untrusted external
  content), so a claude resolver here is not a prompt-injection concern.
- Keep a throttle so a persistent unresolvable wedge does not spin (post the resolve
  job at most once per state signature, mirroring the existing dirty-notified
  marker). Only a TRULY unresolvable wedge (resolver gave up after retries) may, as
  a last resort, leave a SINGLE throttled note — but the default path is silent
  autonomous resolution.

## Also
- Encode the autonomous-resolution norm in `roles/watchman/AGENT.md` (it currently
  only describes the broadcast purpose; add the wedge-resolution responsibility and
  the "never page the maintainer for a wedge" rule).
- Reconcile with `deploy-sync.sh` so the two don't double-resolve (idempotent; the
  CAS/strict-ff already makes concurrent resolution safe).
- Tests: extend run-test.sh — a tracked-wedge and an untracked-collision each
  trigger an autonomous resolve path (a posted job / resolver invocation), NOT a
  maintainer message; lossless cases clean the tree; a genuine-WIP case is preserved
  (stash/land), never discarded.

The root cause feeding these wedges is gardeners editing the SHARED tree instead of
an isolated worktree; this job makes the symptom self-healing. A separate norm push
(isolated-worktree discipline for infra jobs) is the upstream fix.
