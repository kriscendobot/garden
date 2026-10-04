from_host: endolin-garden-ece02cb4
from: gardener:ebfb-pr1408-panel-summary-20261004
reply_to: ebfb-pr1408-panel-summary-20261004
msg_key: msg-ebfb-pr1408-panel-summary-20261004-ba02b7b2d5db
notice_count: 1
first_seen: 2026-10-04T04:54:26Z
last_seen: 2026-10-04T04:54:29Z
sent_at: 2026-10-04T04:54:29Z
---
endojs/endo-but-for-bots#1408 (feat(claude): run the confined claude in a bwrap slice) — merge-decision summary

State: draft, head 3c066ac561 on pinned base llm-d4124e6. CI is green on that head (all 35 checks). The gauntlet stopped at review-budget-reached after 6 rounds. The must-fix list shrank each round: 9 → 3 → 6 → 3 → 2 → 4 request-changes seats.

Panel coverage: the latest head has NOT been panel-reviewed. Round 6 reviewed d266f8a841. The three fix commits after it (b58bff4b3e, cbf21a1d1c, 3c066ac561) answer all four round-6 must-fix items, and I read the diff to confirm each one:
- wire-watcher: `sandbox` is now required. Omitting it throws, and an explicit `sandbox: false` is the only way to run unconfined. The CLI requires `--bwrap <path>` or `--unconfined`. There is a test for this.
- integrator: the dependency-table rows in designs/endo-claude.md are reconciled.
- saboteur: read-only and writable grants that overlap now throw, in both directions and including nested paths. There are tests, including a sibling-prefix case.
- pruner: the requested trims are done.
That diff is small (+134/−44) and does not widen anything.

Objections still open:
1. Purist (should-fix, deferred twice): bwrap-slice.js re-implements the bwrap argv and mount vocabulary already in @endo/sandbox (`SliceMount` vs `SliceSpec.mounts`), and the two copies already differ on a security flag (the slice adds `--disable-userns`; @endo/sandbox lacks it). → FOLLOW-UP-WORTHY. This is the most substantive debt. Fixing it means changing @endo/sandbox's public surface, so it belongs in its own PR, and it is also a cue to add `--disable-userns` to @endo/sandbox.
2. Saboteur (mitigated, pre-existing): the spawn-files directory granted inside the slice also holds the raw credential file, so confined `claude` can read the key from disk and not only through apiKeyHelper. This is already documented as a residual and was not introduced here. → FOLLOW-UP-WORTHY (move the credential out of the granted directory).
3. Wire-watcher note: bind only the broker socket, not its directory. That directory is a per-turn mkdtemp holding one 0600 socket, so the seat itself called the current grant correct. → TASTE.
4. Curator (round 1, declined): `--bwrap` is a second way into confinement next to the planned @endo/claude-sandbox. The designs now say @endo/claude covers the filesystem half of DD6 in-package. → TASTE / design-level; settled by the doc edits unless you disagree with the direction.
5. Fast-checker property tests for `assembleBwrapArgv` / `assertAbsolute`, and corner-prober edge cases (a claude binary installed directly at `/`, empty grant arrays). → TASTE/NOISE.
6. Packager: commit 23e7b0f336 deletes a changeset that only gets folded in two commits later. → NOISE if you squash.
7. Found while checking the head, not raised by the panel: the example call in the header comment at `confined-turn.js:8` and in the older changeset `endo-claude-confined-turn.md` still shows `runConfinedTurn({ formulaId, credential, prompt, model, claudePath })` with no `sandbox`, which now throws. The README example is up to date. → small doc fix, optional before merge. Also, because `sandbox` is now required, the copy of @endo/claude vendored in minion.town (kriscendobot/minion.town#148) must pass `sandbox` when it is next re-vendored.

Bottom line: MERGE after a one-line doc touch-up (add `sandbox` to the stale `runConfinedTurn` example in the confined-turn.js header comment), or merge as is if you will accept that. No redesign needed. Everything the panel raised that bears on security has been fixed. What remains is the @endo/sandbox de-duplication and the credential-file follow-up, each its own PR. Please squash on merge so the commit-history nits drop out.
