Built the `garden-proxy` watcher and shipped it to `origin/main2` as commit **`f20a4ca7`** (bot identity `endolinbot`).

**What I did**
- Authored the new role and watcher modeled on the mentor/follow-up services, wired into systemd + `install-units.sh`, with a deterministic test stub and a new `run-test.sh` subtest.
- The whole branch state was volatile: a *concurrent* gardener was doing bulletin work in the shared `/home/kris` tree, and during my task `origin/main2` advanced twice (their `bulletin` continuous-loop commit + a new `foreman` service), both touching `install-units.sh` and `run-test.sh`. To avoid entangling their uncommitted work or shipping their (then-failing) bulletin test, I built in an **isolated detached worktree off `origin/main2`**, rebased onto the foreman tip, and staged explicit pathspecs only.

**Files (8, +443 lines)**
- `roles/proxy/AGENT.md` — the role.
- `scripts/jobs/proxy.sh` — the watcher tick (gating + grace + seen filters, cost gate).
- `scripts/jobs/handlers/proxy-claude.sh` — the `claude -p` inner agent, per question.
- `scripts/jobs/test/proxy-stub.sh` — deterministic test handler.
- `scripts/systemd/garden-proxy.{service,timer}` + `install-units.sh` registration.
- `scripts/jobs/test/run-test.sh` — SUBTEST 15 (PROXY).

**Verification** — `bash -n` + `shellcheck` clean (only the house-standard SC1091/SC2034 that mentor.sh/follow-up.sh also emit; `GARDEN_TAG` is consumed by `common.sh`). Full suite: **73 passed, 0 failed**, all 11 SUBTEST 15 assertions green; also proven 11/11 across 3 runs in a standalone isolation harness (the full suite intermittently stalls at the unrelated SUBTEST 11 mentor step because `journalctl --user garden-*` is slow under this host's 100-gardener load).

**Chosen settings** — grace window `GARDEN_PROXY_GRACE` default **900s (~15m)**; timer cadence **~5m**.

**Must-not-proxy boundary & report-to-maintainer** — The proxy answers only **progress / direction / experimentation** questions (favor progress, tolerate throw-away work, mark every answer *proxy/tentative*, enumerate options and pick a direction). It refuses **policy / authority**: authority grants, irreversible/outward-facing actions (merge/close, **upstream ferry / identity-switch**), scope changes (anything touching **agoric-sdk**, off-limits), and destructive ops — for those it leaves the message unread for the maintainer and posts a one-line "awaiting maintainer — beyond proxy authority" note. The handler enforces this as defense-in-depth (an out-of-bounds body is forced to DEFER even if the inner agent is talked into answering). Every *answered* question routes a tentative reply into the blocked gardener's inbox, archives the maintainer message, **and** posts a report (gardener + question + tentative answer) back to the maintainer inbox, so this new autonomous surface is fully reviewable and overridable. Message content is treated strictly as data (injection hygiene), and the cost gate guarantees `claude -p` never runs on an empty tick.

**Follow-ups** — The service is committed but not yet enabled on any host; `install-units.sh install && enable-services` (or `enable --now garden-proxy.timer`) arms it. The maintainer may rename `proxy`→`regent` if preferred (suggested in the job).
