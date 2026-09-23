---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-29T03:56:59Z
---
role: scribe
project: endo-but-for-bots
pr: endojs/endo-but-for-bots#881

# scribe seat — panel review of endojs/endo-but-for-bots#881

Dispatched as one code-panel seat on PR #881 (`feat: add attenuated Google Sheets
facets`, head `670e13cd46`, base `03e9aec608` on `build-endo-google-sheets-client`).
Author `kriscendobot` (bot-authored; the external-author calibration does not apply).
Surfaces walked: `pulls/881/comments` (9), `issues/881/comments` (2),
`pulls/881/reviews` (9), `pulls/881/commits` (11).

## Note-this asks and their closure state

1. `#discussion_r3667026735` (@dckc) — "study
   <https://github.com/dckc/awesome-ocap/blob/ocap-style/style-guide/disciplined-python-attenuation.md>",
   "look at @agoric/pola-io for examples". **Closed in-diff, package-scoped**:
   `packages/exo-google-sheets/README.md` § How the attenuation is arranged cites both
   sources and states the dry-run rule verbatim. **Not closed repo-scoped**: no edit to
   `CLAUDE.md`/`AGENTS.md` (root grep for attenuat|pola|readonly|authority|confin: no
   hits), no `to: gardener` message. Finding raised.
2. `#discussion_r3667066973` (@dckc) — the `whole.part('A')` mereology pattern.
   **Closed in-diff**: README records `part()` and the two-axis orthogonality; the
   design doc was updated in `d2b3af3d2f`.
3. `#discussion_r3667766692` (@dckc) — ambient `setTimeout`. **Closed in-diff**: the
   no-ambient-authority claim is stated in the README ("so it is something to hold the
   package to"), commit `58705a160c`.
4. `#discussion_r3667771718` (@dckc) — "why the separate powers layer?" **Closed
   in-diff**: README § Why `powers.js` is separate from `facets.js`, commit `789fbe386a`.

## Completion-summary closure

- Review round 1 (`#pullrequestreview-4799182277`, `-4799231902`) → pushes
  `cb20379079`/`c64d75b9b0`/`d2b3af3d2f` → **closed**: `#issuecomment-5106507616` and
  `#issuecomment-5106587591`, both with SHA tables and verification status.
- Review round 2 (`#pullrequestreview-4800101592`, `-4800107598`, 17:23Z) → pushes
  `58705a160c`, `0980d9f7ce`, `789fbe386a` (21:42–21:52Z) → **open**: inline replies
  `#discussion_r3669393881` and `#discussion_r3669455381` only. Last top-level comment
  on the PR is 16:02:32Z, five hours before the responding pushes. Finding raised.

## Promised follow-up without a durable tracker

The PR publicly defers the same `setReadOnly(flag)` shape in
`packages/exo-playwright/src/browser.js:346` (still present at head, lines 159 and 346)
and in the `endoclaw-oauth`/`endoclaw-browser` designs
(`#discussion_r3667143734`, `#issuecomment-5106507616`), plus the open
local-only-follower question (`#discussion_r3669393881`). Recorded only in the job
completion report `jobs/tada/endojs-endo-but-for-bots-pr881-review-5111ec6e.md`; no
`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--881.md` ledger and no
posted job. Finding raised.

Verdict: request-changes (one must-fix-loop, two summary-fix).

Self-improvement: the scribe brief's completion-summary check reads as per-directive,
but the failure here was per-*round* — round 1 closed cleanly and round 2 did not, on the
same PR, so a seat that stops at "a summary comment exists" passes it. Proposing to the
gardener that the brief say the check is per review round (compare each responding push's
timestamp against the last top-level comment), not per PR. No skill or role edit made:
the subagent does not land garden-library changes.
