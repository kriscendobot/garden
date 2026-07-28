Inbox empty, worktree clean at `origin/main2` tip. The job's work was already landed by a peer; my contribution was verification rather than new code.

## Report

**Outcome: already fixed upstream — verified end-to-end, no new commit needed.**

My earlier session left no uncommitted work, and my worktree was checked out at a stale base (`3f44c0c813`). After rebasing onto `origin/main2` (`ef591a3370`) I found the exact fix this job specifies already landed 20h ago in commit `55feb33e49` "fix: reconcile de-armed watcher timers":

- `scripts/jobs/repo-watcher.sh:170` — `list-unit-files` → `unit_ctl list-units --all "$prefix@*.timer" --no-legend`. The `list-unit-files` call in `ensure_template_installed` (line 83) was correctly left alone.
- `scripts/jobs/test/mock-systemctl.sh` — the `list-units|list-unit-files` case was split, with `list-unit-files` now faithfully returning only the bare template for an instance glob, so only `list-units` can discover an armed instance.
- `scripts/jobs/test/run-test.sh` — the unwatch test gained the assertion the spec asked for: `systemctl --user disable --now garden-triager@kriscendobot-endo.timer` must appear in the mock log.

**Verification I performed:**

- Full suite `scripts/jobs/test/run-test.sh`: **367 passed, 0 failed**.
- Production evidence on `endolin-garden2-5bcdff64`: `repo-watcher` now logs `reconciled repos: 14 watched, 14 previously armed` / `comment-repos: 16 watched, 16 previously armed`. The `previously armed` count was structurally always `0` before the fix; a non-zero count is direct proof `have` is populated and the disarm loop is live.
- Reconciliation audit across all four sets (`garden-{triager,comment-watcher,ci-watcher,dependabot-watcher}`): zero armed instances lack a journal arming file. The stale `*@kriskowal-garden*` instances are gone — torn down by the now-working disarm loop after the repo-transfer commit dropped `comment-repos/kriskowal-garden`.

**I deliberately did NOT run the spec's "immediate remediation".** The premise no longer holds: `kriscendobot/garden` is not a dead fork — it is the garden's own repo, transferred from `kriskowal/garden` on 2026-07-28, and journal commit `9971003d54` deliberately re-keyed the watch to it. `garden-ci-watcher@kriscendobot-garden` and `garden-comment-watcher@kriscendobot-garden` now exit `0` cleanly (`not a bot repo (kriscendobot/garden) — never autonomously shepherd non-bot PRs; skipping`) with `NRestarts=0`; the `gh: Not Found (HTTP 404)` FATAL flap is gone. Disabling them would have torn down an intentional watch. The `watch-optout/kriscendobot-garden` tombstone has likewise already been rewritten by a peer with a corrected rationale (it now stays to block *auto*-provisioning of a commit triager on the garden's own repo, not because the repo is dead).

**Follow-up (minor, not acted on):** `list-units --all` enumerates *loaded* units, so an instance enabled on disk but never loaded would still be invisible to `have`. In practice `repo-watcher` runs `daemon-reload` immediately before reconciling, which loads every `.wants/`-enabled timer, so this is theoretical — but scanning `~/.config/systemd/user/timers.target.wants/` would be the strictly authoritative source if that edge ever bites.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-garden-reconcile-disarm-list-units.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 43 tokens (1248660 cached reads)
- Output: 11413 tokens
- Cost: $1.4802
- Wall-clock: 332s

<!-- garden-usage-end -->
