Done. My commit is landed on `origin/main2`.

## Completion report

**Job:** Harden `clone-keeper.sh` so a vanished tracked bare clone is restored or escalated, not re-warned into a log forever.

**Finding:** Most of the job's asks had *already* landed on main2 across five commits (`1bfbc1087`…`7cf55fc46`) — the job's line references (`:79`, `:47`, `:10`) point at a pre-change version of the file. Already present: the 4-field `<dir>|<remote>|<branch>|<url>` format (url optional, back-compat), the bounded self-heal `git clone --bare` (`bounded_clone`, staged into a sibling temp + atomic `mv -T`), URL derivation from the dir basename, and escalation-to-maintainer when *no* source can be found.

**Genuine remaining gap I closed:** the re-clone-**failure** branch (a *known* source that won't clone — deleted upstream, wrong `<clone-url>`, firewall) still emitted only a bare `WARN … skipping; return 0`. A persistently bad source therefore re-warned every ~30m tick forever with no human ever notified — exactly the "missing clone silently blocks the fleet" / six-week-endo hazard the keeper exists to prevent, and exactly the job's literal "*or the re-clone fails, escalate ONCE … instead of silently repeating the WARN*."

**Change (`scripts/jobs/clone-keeper.sh`):** the re-clone-failure path now also calls `alert_maintainer` with a per-clone dedup key `clone-keeper-reclone-failed-<dir>`. `alert_maintainer`'s stamped throttle marker (`$GARDEN_STATE/alerts/<key>.last`) *is* the "already-reported-missing" dedup the job asked for — a transient offline blip alerts at most once per window and still self-heals next tick, while a persistent failure reliably reaches a human. Behavior otherwise unchanged: still logged, still `return 0`, still retried next tick, never wedged. Header comment updated to match.

**Test (`scripts/jobs/test/clone-keeper-test.sh`):** extended the MISSING+UNREACHABLE case to assert the escalation fires and carries the new dedup key. Full suite: **42/42 pass**, `bash -n` clean.

**Follow-ups:** none. The escalation is throttled per the standard `alert_maintainer` window (default 1h vs. the 30m tick), so it will not flood the inbox.
