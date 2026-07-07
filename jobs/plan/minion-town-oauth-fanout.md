---
gate: orchestrated
orchestrated_by: minion-town-oauth-stage1
priority: normal
roadmap: minion.town/mcp-oauth
posted_by: orchestrator
posted_at: 2026-07-07T05:33:19Z
---

# minion.town: record the stage-2 parallel orchestration (fan-out)

Phase 2 of the minion.town OAuth deployment is complete (you run only after it, in the serial stage-1 orchestration). Your entire job is to fan out the four independent follow-on phases, which are already parked on the board with gate `orchestrated` under the owning orchestration `minion-town-oauth-stage2`:

    /home/kris/garden2/scripts/jobs/post-orchestration.sh \
      --parallel --on-child-failure continue \
      --by orchestrator \
      minion-town-oauth-stage2 \
      minion-town-phase3-google-idp \
      minion-town-phase4-authz-policy \
      minion-town-phase5-github-oidc-thunk \
      minion-town-phase6-web-gate

The command is idempotent (a re-run is a no-op success). Afterwards verify the record exists: `jobs/orch/minion-town-oauth-stage2.md` on the journal (or, if the watcher already finished it, `jobs/tada/minion-town-oauth-stage2.md`). If any child is missing from `jobs/plan/` AND absent from the rest of the lifecycle, do not use `--no-validate` to paper over it — report which child is missing as a failure instead.

Definition of done: the orchestration record is on `origin/journal2` and your report quotes the four children it names.
