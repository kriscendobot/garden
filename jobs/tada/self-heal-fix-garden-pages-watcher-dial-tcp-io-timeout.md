Pushed cleanly.

## Completion report

**What I did:** Fixed `is_transient_net_error()` in `scripts/jobs/common.sh` (~line 285) so that Go's connection-establishment timeout (`dial tcp <ip>:443: i/o timeout`) is classified as transient, matching the existing treatment of read timeouts.

**What changed:** In the curated regex alternation, replaced `read tcp .* i/o timeout` with `(dial|read) tcp .* i/o timeout` — a single-token edit. All four watchers sharing this helper (`garden-pages-watcher`, ci, comment, mention) now degrade quietly on a connect-timeout blip instead of hitting `die` → exit 1 → systemd restart + self-heal.

**Verification:** Self-test confirms `dial tcp 140.82.116.6:443: i/o timeout` → transient, `read tcp ... i/o timeout` → transient (unchanged), and a structural error (`HTTP 404`) → still structural. Committed and rebase-CAS pushed to `main2`.

**Follow-ups:** None. The change is scoped to the single regex with no behavioral change for structural errors.
