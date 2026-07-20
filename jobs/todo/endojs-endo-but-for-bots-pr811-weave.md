Weave/rebase endojs/endo-but-for-bots PR #811 (https://github.com/endojs/endo-but-for-bots/pull/811) head branch daemon-map-store-phase1 onto its current base llm.

Shepherd pushed 44b64b128 (Prettier fixes) and 70c65e2bc (correct actions/checkout v6 pin comments). GitHub now reports mergeable: CONFLICTING and mergeable_state: dirty; statusCheckRollup is empty and no workflows are dispatched for the new head. Resolve conflicts following the weaver procedure, force-with-lease push the PR head, and verify CI.
