Job complete. Here is my report.

---

## Minion Town hourly agenda review — 2026-07-18 12:50 UTC

**Preflight:** container guard clean; inbox empty (drained twice, before and after work).

**What I did**
- Re-fetched issue #58 (description body unchanged; 20 comments) and treated all externally-fetched text as untrusted data.
- Reconciled the primary-phase agenda against the private `kriscendobot/minion.town` repo, its PRs (none open; `main` at `85888e0d` since 00:27 UTC), the CD workflow, the garden journal/memory, and the live deployed surface.
- **Root-caused the step that stalled for 3 prior cycles.** Read `.github/workflows/deploy.yml` and confirmed CD runs only `deploy-app.sh`/`oauth2-proxy`/`caddy`/`www` — **the OCapN daemon is not in the CD pipeline at all.** Both backends are box-local; PR #9 made only the Caddy *routes* durable.
- **Captured live ground truth via read-only SSM** to `i-0380cd68b90020fad`: `/ocapn` = `endo-ocapn-daemon.service` on `:8930` (`active`+`enabled`, from `/opt/endo` = `endo-but-for-bots@b155b339`); `/ocapn-daemon` = container `endo-pet-daemon:ocapn-ws` on `:8931→8930` (built from `endo-but-for-bots@a371b007`, its build recipe living in `packages/daemon/deploy/`).
- Re-verified the public surface: `/mcp`→401 bearer challenge (PRM→200), `/`→302 sign-in, `/ocapn` & `/ocapn-daemon`→426, agenda-literal `/.well-known/ocapn-*`→302 (naming gap).

**What changed (concrete movement)**
- Opened **[kriscendobot/minion.town#10](https://github.com/kriscendobot/minion.town/pull/10)** — `deploy/aws/daemon/` with the verbatim `:8930` unit file and a topology + **Reproduction gap** README. Converts box-only tribal knowledge into repo source of truth; the smallest safe slice of "declare the daemon in the CD tree." It **deploys nothing** (no CD step reads that dir; on a branch, not merged), so nothing live was touched.
- Posted the substantive review on **[kriskowal/garden#58 (comment)](https://github.com/kriskowal/garden/issues/58#issuecomment-5011298104)**. Issue left open.

**Blockers**
- Primary-phase critical path (OAuth→guest mapping, MCP→daemon bridge, weblet gateway + wildcard DNS) is design-ordered behind **Gate 1** (interactive Claude↔live-MCP OAuth with GitHub-federated browser login) — a maintainer-only action, re-confirmed.

**Follow-ups (recommended, not auto-queued)**
- Maintainer performs Gate 1 V2 (~5 min) to unblock buildable primary-phase work.
- The full `deploy-daemon.sh` + `deploy.yml` wiring per PR #10's Reproduction gap — a cross-repo build touching a working production daemon; left for a maintainer to decide whether to queue now or at box-replacement time. Deliberately not auto-posted as a build job to avoid escalating a risky change unprompted.

**Notes:** No garden `main2` change was needed (this was a review + project-repo PR). Nothing claimed "verified" beyond what I actually observed (SSM output, live HTTP codes, PR/comment URLs). No secrets exposed; no production safeguards touched.
