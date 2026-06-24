---
ts: 2026-05-15T03:43:09Z
kind: result
role: judge
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/judge--daa330
refs:
  - entries/2026/05/15/031000Z-dispatch-general-contractor-30e396.md
  - entries/2026/05/15/031627Z-result-judge-30e396.md
  - entries/2026/05/15/032334Z-result-weaver-a83159.md
  - entries/2026/05/15/033826Z-result-fixer-992bb3.md
---

# Panel verdict on PR #252 (round 2, terminating)

PR: [`endojs/endo-but-for-bots#252`](https://github.com/endojs/endo-but-for-bots/pull/252)
Title: `design(ocapn,noise): session reconnect with heartbeat (per erights/kriskowal 2026-05-14)`
Author: kriscendobot (garden-authored draft).
Base: `llm`; head: `94ad5162a`; mergeable state: CLEAN.
CI: total=4, failed=0 at `94ad5162a` (lint 57s, build 24s, browser-tests 2m31s, test 3m23s) per the fixer's terminal rollup.

## Panel kind and execution mode

- **Panel kind**: design-panel. The PR's three changed paths
  (`designs/ocapn-noise-session-reconnect.md`,
  `designs/README.md`, `designs/ocapn-noise-network.md` See-also pointer)
  are all under `designs/`; per `roles/judge/AGENT.md` § Panel-kind
  discrimination, no source / test paths means the design panel
  applies. Same panel composition as round 1 (critic, skeptic,
  copyeditor, pedant, novice).
- **Panel execution mode**: in-band-fallback. `ToolSearch` for
  `Agent` / `task spawn` / `subagent dispatch` returned no
  matching tool surface; the dispatch harness did not expose
  concurrent dispatch. The judge wrote each of the five seats'
  verification blocks one at a time against the per-seat role
  file's primary surface, aggregated after all five landed, and
  submitted one formal `gh pr review --comment`.

## Per-seat verification

- **critic**: approve. The § 4 Resumption handshake's three
  sub-issues are resolved as one cluster (commit `f99d927ac`):
  AEAD-consistent `RESUME` framing, five-step procedural list
  inserting the responder-side `RESUME-ACK`, step 4 cites the
  Option Resume formula. CapTP-layer idempotence is named in a
  dedicated block after step 5 (commit `7963d7de2`) with per-op
  dedup keys. Phase 2 names its own consumer (a simulated-stall
  fault injector; commit `c16b29024`).
- **skeptic**: approve. Noise spec monotonicity guarantee is
  cited as local-to-CipherState (commit `0f67d218e`);
  peer-acked-recv-nonce is named as this design's extension
  rather than as a Noise property. § 5 defines the hard-timeout
  queue's terminal semantics (commit `8f64af766`). SYNACK
  capability-flag is plainly described as new (commit
  `6a0838e3d`). Test Plan gains three adversarial cases (commit
  `dc6d6b0e8`).
- **copyeditor**: approve. § Rationale fact 3 pronoun-antecedent
  is fixed; Noise primitives introduced before first use
  (commit `797ec49ed`). § 1 "This is symmetric" rewritten as
  "The protocol is symmetric"; § 3 step 2 normalized to
  present-indicative (commit `94ad5162a`). § 4 nonce-formula
  duplication is resolved by `f99d927ac`.
- **pedant**: approve. Heading-level capitalization is uniform
  Title Case across `##`, `###`, `####` (commit `476c84a19`).
  Em-dash discipline remains clean (zero `—` characters in the
  diff). Relative-path discipline remains clean. Metadata table
  gained `Updated: 2026-05-15` consistent with the bumped
  `designs/README.md` row.
- **novice**: approve. Noise primitives are introduced in the
  same paragraph that uses them; § 4's text now reconstructs both
  Mermaid diagrams without forcing a diagram cross-reference.
  The designator-is-the-pubkey-hash equivalence on first use in
  § 3 drops from must-fix to comment-only with the `RESUME-ACK`
  gap closed.

## Verdict

- **Aggregated verdict**: approve (intended). All ten round-1
  items addressed in citable commits per the fixer's SHA-by-item
  table. No new in-scope must-fix surfaces on the new head.
- **Submitted**: `kriscendobot` `COMMENTED` review at
  `2026-05-15T03:42:42Z` on PR #252 (formal review id
  `PRR_kwDORRE4FM8AAAABAAOBPQ`). GitHub blocks `--approve` on a
  self-authored PR ("Approving requires a pull request that
  someone else opened"); per `skills/panel-review/SKILL.md`
  § Self-review fallback the panel submitted `--comment` with
  the terminating-verdict heading carried in the body.

## Must-fix / should-fix / out-of-scope counts

- Must-fix: **0** (round-1 cluster resolved; nothing new in scope).
- Should-fix: **0** (all nine round-1 should-fix items addressed).
- Out-of-scope / follow-up: **5** (four preserved comment-only nits
  from round 1: §6 network-vs-core prose, "stragglers" jargon, syrup
  reader/writer introduction, designator-vs-transcript hand-off; plus
  the designator-equivalence inline-cite clarity nit demoted from
  round-1 must-fix to comment-only).

## Loop termination and un-draft

- Loop **terminates** on this round. Must-fix is empty in scope.
- `gh pr ready 252 -R endojs/endo-but-for-bots` ran at
  `2026-05-15T03:43:00Z` and returned `✓ Pull request
  endojs/endo-but-for-bots#252 is marked as "ready for review"`.
  Confirmed by `gh pr view 252 ... --json isDraft`:
  `{"headRefOid":"94ad5162ad9468902fced49352cf847ef917ac76","isDraft":false,"mergeStateStatus":"CLEAN"}`.
- Per-action authorization for un-draft (forwarded in the dispatch
  prompt) is consumed.
- The maintainer's review queue is the next venue for PR #252.

## Definition of done check

- Each of the five seats' verification findings is embedded above
  (per-seat verification). No separate `result` entries per seat,
  consistent with in-band-fallback (the seats are sections of the
  judge's notes, not separate dispatches).
- One formal `gh pr review` submitted as `--comment` per the
  self-review fallback.
- This entry names the PR number, the panel kind (`design-panel`),
  the panel execution mode (`in-band-fallback`), the verdict
  (approve / terminating), the must-fix / should-fix / out-of-scope
  counts (0 / 0 / 5), and confirms `gh pr ready` ran with the PR now
  out of draft.

Self-improvement: nothing this time. The round-2 verification ran
cleanly against the same five seats; the in-band-fallback procedure
in `roles/judge/AGENT.md` § In-band fallback held up for the
verification pass exactly as for round 1's initial pass, with one
small wrinkle: the `--approve` self-review block surfaces a different
error string than the `--request-changes` self-review block ("Approving
requires a pull request that someone else opened" vs "Review Can not
request changes on your own pull request"). Both error strings already
route to the same `--comment` fallback per `skills/panel-review/SKILL.md`
§ Self-review fallback, so no skill row needs to land for this
observation; the fallback procedure as written covers both cases. The
demotion of the round-1 novice must-fix on designator equivalence to
a comment-only clarity nit (once the `RESUME-ACK` gap closed) is a
clean instance of the panel-review aggregation rule that must-fix
clusters can dissolve into their constituents once the load-bearing
sub-issue resolves; the existing aggregation discipline handles it
without skill amendment.
