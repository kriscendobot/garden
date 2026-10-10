---
kind: panel-run
repo: kriscendobot/minion.town
pr: 176
panel_kind: code
base_ref: c9a073cc04434094112d64a18ce8ae8006763a14
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: adacedd2d43722e0acaa05e9f5cf6ea68f7be39c
must_fix_total: 7
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: da2c1ade0c4e
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #176 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `adacedd2`

seat verdicts (33): archivist=pass assessor=pass benchmarker=pass breaker=comment changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=pass saboteur=comment scribe=comment spec-keeper=comment stylist=must-fix surfacer=pass thesaurus=pass transplanter=comment typist=pass warden=comment wire-watcher=comment
must-fix items (7):
- pruner: ## Findings
- stylist: **must-fix.** `cmd` at `deploy/aws/scripts/git-remote-partition.sh:75` should be `command`. It holds the subcommand n...
- stylist: **must-fix.** `args_json` (line 46), `args_base64` (line 49), `ARGS_BASE64` (lines 58 and 70) and the JS `args` objec...
- stylist: **must-fix.** `id` (the shell variable at line 91 and the JS `args.id`) should be `partition_id` in shell and `partit...
- stylist: **should-fix.** `DEPLOYMENT.md:590-593` uses `S=` (single letter), `rw` and `ro`, plus the file names `rw.url` and `r...
- stylist: **comment-only.** The `ssm_invoke` locals `b64`, `param` and `cmd_id` in `deploy/aws/scripts/common.sh` predate the P...
- stylist: **comment-only.** `iss|sub` in the usage text and error message is JWT claim vocabulary, a domain name that stays as ...
