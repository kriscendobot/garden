---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Narrow design PR #1102 to the special-names-on-options-bag mechanism

Repository: `endojs/endo-but-for-bots`. PR: https://github.com/endojs/endo-but-for-bots/pull/1102 (DRAFT, base `llm`).
PR head: `kriscendobot/endo-but-for-bots` branch `design/claude-agents-capability` (cross-repo).

A trusted maintainer review by @kriskowal (CHANGES_REQUESTED,
`pullrequestreview-5073768162`) states, verbatim:

  "Please narrow the scope of this to just endowing a new guest with special
   names on the options bag."

Treat that sentence as the requirement. The PR currently adds a 360-line
`designs/claude-agents-capability.md` proposing a broad `@endo/exo-claude-agents`
provisioning capability: namespace-scoped recursive factory facets,
per-account-family credential sources, single-use per-child credential leases,
durable child revocation, quota admission, reconciliation, and a live confined
inference integration. The maintainer wants all of that dropped.

## The ask

Rewrite the design so its ONLY subject is the generic, portable mechanism by
which the authority creating a new guest endows that guest with **special names
supplied on the provisioning options bag** — the persisted
`introducedSpecialNames` daemon mechanism the current PR body already calls out
as one component. Concretely:

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1102-narrow-special-names kriscendobot/endo-but-for-bots design/claude-agents-capability`
   Work only in that checkout; never share a working tree with a peer.
2. Rewrite `designs/claude-agents-capability.md` (rename the file/title if the
   narrowed subject warrants — e.g. a special-names-endowment design — using the
   repository's settled naming) so it specifies ONLY: how special names are
   passed on the guest-provisioning options bag at creation time, who may supply
   them (only the creating authority; ordinary guest callers cannot rename
   another guest's special workers), the default/override behavior (omitted
   config preserves the default `@main`; explicit config introduces/overrides),
   durable persistence across daemon reincarnation, immutability of a retained/
   reacquired guest's original special-name policy, and fail-closed behavior on
   repeated provisioning (never widen or replace authority). Drop the factory
   facets, credential-account scopes, credential leases, quotas, child
   lifecycle/revocation, reconciliation, and the live-inference integration
   entirely — cross-link `@endo/claude` (#995), builder #1015, and the parked
   Agent SDK track only if the narrowed mechanism genuinely depends on them,
   otherwise remove those sections.
3. Reconcile with the settled special-names implementation work: issue
   https://github.com/endojs/endo-but-for-bots/issues/982 and PR #1042 (retained
   guest provisioning). If those already fix a naming/API for this mechanism, the
   design must adopt it rather than invent a parallel one.
4. Update `designs/README.md` (index entry, dependency graph, milestone estimate)
   to match the narrowed design; remove index/graph/roadmap references to the
   dropped provisioning capability.
5. Verify locally: markdown formatting, Mermaid diagrams validate
   (skills/mermaid-validation), and any design-doc generation the repo runs stays
   clean.
6. Push follow-ups to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
7. Post a reply to review `5073768162` on PR #1102 (via
   skills/pr-review-thread-replies or a top-level PR comment if the review has no
   thread) that states the design was narrowed as requested, names the new
   commit SHA, and one-line-summarizes what was dropped and kept. Include the
   comment URL in your completion report.

Keep the PR a DRAFT; the design gauntlet/panel already running on #1102 owns the
downstream review. Implementation stays out of scope — this is a design-only
revision.



<!-- garden-transient-elapsed: kind=signature through=1 values=2,2 -->
<!-- garden-elapsed-constancy: 1 -->

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T09:56:34Z
