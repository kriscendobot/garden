---
kind: panel-run
repo: kriscendobot/minion.town
pr: 180
panel_kind: code
base_ref: origin/main-c7bdf20
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 42de416c8f29675c7fc3c0733645ff55a103af0b
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 7ee0aca6ad28
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #180 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `42de416c`

seat verdicts (34): archivist=comment assessor=comment benchmarker=pass breaker=comment changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=pass integrator=must-fix locksmith=pass migrator=comment orthographer=pass packager=comment procurer=must-fix prover=comment pruner=pass purist=comment reexport-auditor=pass releaser=pass saboteur=comment scribe=must-fix spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=must-fix typist=comment warden=comment wire-watcher=must-fix
must-fix items (20):
- integrator: **should-fix — DEPLOYMENT.md:542-543 still lists the shipped work as deferred.**
- integrator: The sentence names "deferred work (… MCP mint/adopt + live pet-store binding …)".
- integrator: This PR adds exactly that, and the PR itself rewrites item 2 of the increment-1 design ("item 2 is in place").
- integrator: The paragraph was edited in this diff, so the stale clause sits next to the new text.
- integrator: Fix: drop "MCP mint/adopt + live pet-store binding" from the deferred list.
- integrator: [rule: rename-discipline] sweep completeness, applied to a concept that moved from "deferred" to "shipped".
- integrator: **should-fix — the design parent and the Phase plan table were not reconciled.**
- integrator: Only `designs/git-remote-capability-increment-1.md` was updated.
- integrator: `designs/git-remote-capability.md` still carries the pet-store binding as named-not-actioned (§ 12.2).
- integrator: The DEPLOYMENT.md "Phase plan and state" table did not change, though this PR moves a phase.
- integrator: Fix: either update both, or say in the PR body why they stay as written.
- integrator: [rule: roles/jurors/integrator/AGENT.md § concept-namespace coherence]
- integrator: **should-fix — "Phase 2: open" makes the ledger coherent only while the PR is a draft.**
- integrator: It is a draft, and `orchestrated-slice` with `Successor: kriscendobot-minion.town-pr178-gauntlet` names a real owner.
- integrator: The design depends on the resource caps in #178, and the `receive-pack` push surface is exposed through a new minted-...
- integrator: The un-draft is withheld mechanically, so this is comment-only about the open phase.
- integrator: My should-fix is narrower: the PR body should state that this merges only after #178.
- integrator: [rule: integrator § ordered-phase reconciliation]
- integrator: **comment-only — `readOnly`, `mintUrl`, and `revoke` are qualified as `readOnlyGit`, `mintGitUrl`, `revokeGitUrl`.**
- integrator: The comment in `src/endo/mcp-tool-names.ts` justifies this well, and the names are registered consistently.
