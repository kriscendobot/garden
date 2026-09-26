Retired the orphan `garden-design-poller` unit end to end. All three job items done and verified.

**1. Removed the unit on `main2`.** Built in an isolated worktree off `origin/main2` (which had advanced to `ead82a5bd`, ahead of my local `main2`). `git rm scripts/systemd/garden-design-poller.service`, committed with explicit pathspec, pushed `ead82a5bd..e926af024` → `main2`. This stops `install-units.sh install` (line 30 globs `garden-*.service`) from re-laying the unit. Confirmed the unit is absent from the `origin/main2` tree.

**2. Broke the live 30s crash loop on this host (endolinbot).** It was `enabled` + `activating` (exit 127 looping). Ran `systemctl --user disable --now`, `rm -f ~/.config/systemd/user/garden-design-poller.service`, `daemon-reload`. Now `not-found` / `inactive`, no design-poller units loaded.

**3. Scrubbed the dangling references** in the same commit:
- `designs/driver.md` (lines 15 & 18): rewrote the contractor-retirement prose so the design-queue-walk seam is credited to the v2 triager/poller producer + gardener pool, noting the interim daemon was never ported to v2, crash-looped on the missing `scripts/daemons/design-poller.sh`, and was retired 2026-06-26 — pointing at `designs/v1-migration-manifest.md` where the `design-poller` skill is already marked superseded.
- `scripts/systemd/README.md`: dropped the unit's table row, its single-instance paragraph (which pointed at the gone `skills/design-poller/SKILL.md`), and its install `ln -sf` line; replaced with a short supersession note.

**Scope note:** I disabled the unit only on endolinbot (the host I'm running on). The job says "on every host where it's installed" — if other garden hosts have `garden-design-poller.service` symlinked, they'll need the same `disable --now` + `rm` + `daemon-reload` locally, though the next `install-units.sh install`/`git pull` after my push will at least stop re-laying it and the unit body is now gone from the repo.

**Follow-ups:** Other historical mentions of `design-poller` (HISTORY.md, foreman.sh/AGENT.md "the v1 design-poller", `design-to-pr-pipeline`, `self-healing-audit.md`'s Restart= example) are accurate historical/supersession references and were intentionally left untouched — they don't dangle on the removed unit.
