---
kind: panel-run
repo: kriscendobot/minion.town
pr: 192
panel_kind: code
provider: anthropic
base_ref: 30a4c62acd1b40958edd426eaa50025120dbab64
pr_body_hash: 92deb7d66c7d1121593f2ed1a5cb4608e8eb6c7565773fd24d495c7d6a264a8e
rounds: 1
disposition: passed
exit_code: 0
reviewed_head: 768b651e7ebd32868c15241de1b448dbe5193625
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 4abf81bb8d3f
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #192 (code)

Terminal disposition: **passed** after **1** round(s).

## Round 1 — head `768b651e`

seat verdicts (34): archivist=must-fix assessor=pass benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=must-fix orthographer=pass packager=comment procurer=pass prover=comment pruner=comment purist=comment reexport-auditor=pass releaser=pass saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=pass warden=comment wire-watcher=comment
must-fix items (20):
- archivist: **should-fix**: `DEPLOYMENT.md:1341-1343` says the hand-installed `endo-ocapn-daemon.service` should be "replaced wit...
- archivist: **should-fix**: `deploy/aws/daemon/README.md:30` says `endo-ocapn-daemon.service` is "captured verbatim" in this dire...
- archivist: **comment-only**: `deploy/aws/scripts/deploy-endo-daemon.sh:111` still reads "install only if absent/mismatched," but...
- archivist: `DEPLOYMENT.md` § Node ownership: all six Node-only scripts have the `/opt/node/current/bin/node` guard (`deploy-end...
- archivist: `deploy-endo-daemon.sh` runs before `deploy-app.sh` in `.github/workflows/deploy.yml:117/121`, so "first Node step in...
- archivist: `install-node22.sh` header matches its body: a digest-named directory, no reads or repairs of an existing tree, and `...
- archivist: `common.sh` `ssm_invoke` comment matches the new `SYSTEM_PATH` prefix and absolute `/usr/bin/base64` and `/bin/bash`.
- archivist: `deploy-oauth2-proxy.sh` header matches the pinned-digest flow, including "never runs it before that check."
- breaker: **should-fix: the "/usr/local belongs to root" invariant is stated but never asserted.** `DEPLOYMENT.md` and `lib/sys...
- breaker: **comment-only: stale-Node window.** The hand-installed `endo-ocapn-daemon.service` keeps running `/usr/local/bin/nod...
- breaker: **comment-only: `/opt/node/<sha256>` trees accumulate.** Each Node bump leaves the previous tree behind, and `install...
- breaker: **mitigated: `install_node22` attacks I tried.**
- breaker: Partial or poisoned release dir: a tree appears only by atomic `mv -T` after the sha256 check, so a crash leaves `.st...
- breaker: Symlink at the release path: `[ -L ]` is checked and `rm -rf` runs before the `mv`.
- breaker: Concurrent runs: `flock` serializes them.
- breaker: Digest as path injection: the `^[0-9a-f]{64}$` check blocks it.
- breaker: Tar setuid or foreign-owner entries: `--no-same-owner` and `chmod -R go-w` handle them.
- breaker: Bad `current` flip: `ln -sfn` plus `mv -T` makes it atomic.
- breaker: **mitigated: `deploy-oauth2-proxy.sh` pin.**
- breaker: Setting only `OAUTH2_PROXY_VERSION` leaves the old digests, so the sha check fails closed.
