Retire the orphan `garden-design-poller` unit, which crash-loops with exit 127: `self-heal-run.sh` line 95 cannot exec `%h/scripts/daemons/design-poller.sh` (never ported to v2). The daemon is superseded per `designs/v1-migration-manifest.md:206` (v2 triager/poller producer + gardener pool) and is absent from `scripts/jobs/install-units.sh` `enable_services()`; its `Documentation=` skill `skills/design-poller/` is also gone.

Do all of:
1. `git rm scripts/systemd/garden-design-poller.service` on `main2` (build in an isolated worktree off `origin/main2` per the standing infra-job discipline; commit explicit pathspec; push `HEAD:main2`). This stops `install-units.sh install` (line 30 globs `garden-*.service`) from re-laying it.
2. On every host where it's installed: `systemctl --user disable --now garden-design-poller.service` then `rm -f ~/.config/systemd/user/garden-design-poller.service` and `systemctl --user daemon-reload`, to break the live 30s crash loop immediately (it is currently `enabled` + `active (running)`).
3. Scrub the now-dangling references so the supersession is clean: the `garden-design-poller` mention in `designs/driver.md:15` (and its `skills/design-poller/SKILL.md` / unit-path pointers), updating the prose to say the contractor's design-queue-walk seam is filled by the v2 triager/poller producer + gardener pool rather than this daemon.

---
claim:
  host: endolinbot
  gardener: 10
  claimed_at: 2026-06-26T04:27:03Z
