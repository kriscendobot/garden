---
ts: 2026-05-15T03:16:27Z
kind: result
role: judge
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/031000Z-dispatch-general-contractor-30e396.md
---

# Panel verdict on PR #252

PR: [`endojs/endo-but-for-bots#252`](https://github.com/endojs/endo-but-for-bots/pull/252)
Title: `design(ocapn,noise): session reconnect with heartbeat (per erights/kriskowal 2026-05-14)`
Author: kriscendobot (garden-authored draft)
Base: `llm`; head: `5cadc3b42`; mergeable state: CONFLICTING.

## Panel kind and execution mode

- **Panel kind**: design-panel (the PR's three changed paths are all
  under `designs/`; per `roles/judge/AGENT.md` § Panel-kind
  discrimination, no source / test paths means the design panel
  applies). The PR's true diff against its merge-base `68246ad92` is
  `designs/README.md` (registers the new design), `designs/ocapn-noise-network.md`
  (See-also pointer), and `designs/ocapn-noise-session-reconnect.md`
  (the new 579-line design).
- **Panel execution mode**: in-band-fallback. `ToolSearch` for
  `Agent` / `task spawn` / `subagent dispatch` returned no matching
  tool; the dispatch harness did not surface concurrent dispatch.
  The judge wrote each of the five seats' blocks one at a time
  against the per-seat role file's primary surface, aggregated after
  all five landed, and submitted one formal `gh pr review` per
  `skills/panel-review/SKILL.md` § Posting the review.

## Per-seat high-level findings

- **critic** (comment-only verdict): the Resume path's resumption-
  record cleartext-but-MAC'd phrasing is internally inconsistent
  with AEAD semantics; replay-at-higher-nonces (§4 step 4) needs a
  CapTP-side idempotence note; Phase 2 introduces session-epoch /
  queue scaffolding whose only consumer is Phase 3; §6's "lives in
  the network not in core" framing ignores that the new `op:ping`
  opcode itself lives in core's operation set.
- **skeptic** (comment-only verdict): Noise-spec citation in §4
  attributes a property (peer-acked-recv-nonce) to the spec that the
  spec does not state; §5's `SESSION_HARD_TIMEOUT` does not name the
  queue's terminal semantics on hard-timeout fire; the SYNACK
  capability negotiation in § Compatibility may rest on a handshake
  field that does not exist yet; § Test Plan is missing three
  adversarial cases (replay idempotence, hard-timeout drain,
  cross-session RESUME replay); one-side-declares-loss case is
  unstated.
- **copyeditor** (comment-only verdict): pronoun-antecedent slip in
  § Rationale fact 3 ("Reusing ... forges the authenticator"); "This
  is symmetric" pronoun antecedent ambiguity in §1; tense drift in §3
  list items (present indicative mixed with imperative); nonce
  formula in §4 duplicated with slight phrasing variation; minor
  jargon imports ("stragglers" in §2; `makeSyrupsReader` /
  `makeSyrupsWriter` in §6).
- **pedant** (comment-only verdict): em-dash discipline clean (no
  `—` characters); relative-path discipline clean; en-dash for
  ranges is Chicago-correct; numerals vs spelled numbers consistent
  with Chicago; **one should-fix**: heading capitalization mixes
  title-case at `##` with sentence-case at `###` and `####` (each
  level is internally consistent; the convention may want to be
  uniform across all heading levels if `designs/` aims for a single
  convention).
- **novice** (request-changes verdict; the only seat to grade a
  finding as must-fix): § Rationale fact 3 introduces `CipherState`,
  `(key, nonce)` pair, and ChaCha20-Poly1305 cold; § 4 Resumption
  handshake's text omits the `RESUME-ACK` shown in the Mermaid
  diagram, so a new reader following the text alone cannot
  reconstruct the handshake; designator-is-the-pubkey-hash
  equivalence in § 3 crossed-hellos is implicit on first use.

## Verdict

- **Aggregated verdict**: request-changes (intended).
  GitHub blocks `--request-changes` on a self-authored PR
  (`kriscendobot` reviewing a `kriscendobot`-authored PR returns
  "Review Can not request changes on your own pull request"). Per
  `skills/panel-review/SKILL.md` § Self-review fallback, the panel
  submitted as `--comment` with the explicit `Must-fix before merge`
  heading. The orchestrator's dispatch matrix keys on the heading,
  not on `reviewDecision`.
- **Submitted**: `kriscendobot` `COMMENTED` review at
  `2026-05-15T03:16:02Z` on PR #252.

## Must-fix (in scope, drives the fixer loop)

1. **§ 4 Resumption handshake is internally inconsistent and the
   text diverges from the Mermaid diagram.** Three sub-problems
   collapse into one cluster: (a) the `RESUME` record's "cleartext,
   but authenticated by the next-message Noise MAC" phrasing is
   AEAD-inconsistent (a record whose authenticator rides on the
   existing CipherState **is** encrypted); (b) the procedural list
   omits the `RESUME-ACK` shown in both diagrams; (c) the nonce-
   advance formula appears twice with slightly different phrasing.
   The fixer revises § 4 to resolve all three together.

## Should-fix (in scope, the fixer addresses in the same round)

Nine items in the aggregated body, grouped: (2) introduce Noise
primitives at the top of § Rationale fact 3 plus a pronoun fix; (3)
name the CapTP-layer idempotence requirement for replay-at-higher-
nonces; (4) name `SESSION_HARD_TIMEOUT` queue terminal semantics;
(5) state that this design extends Noise's local counter with a
peer-acked-recv-nonce exchange rather than asserting it as a spec
property; (6) confirm or scope the SYNACK capability flag; (7) add
three test-plan cases (replay idempotence, hard-timeout drain,
cross-session RESUME replay); (8) fold or justify Phase 2's
scaffolding; (9) heading capitalization consistency across heading
levels (optional, mark as project-convention); (10) routine
copyedit pass (tense drift in §3, pronoun antecedent in §1, nonce-
formula restating cite in §4).

## Out of scope / follow-up

- **PR is `CONFLICTING` against `llm`.** The weaver-not-the-panel
  resolves this; the rebase is out-of-scope for the design panel's
  content review. The orchestrator should route a weaver before the
  next judge round consumes the fixer's output.
- §6 prose tightening on the network-vs-core split (comment-only).
- "Stragglers" jargon in §2 (comment-only).
- `makeSyrupsReader` / `makeSyrupsWriter` introduction in §6
  (comment-only).
- Open Question P3 (designator vs transcript hash) overlaps with the
  cryptographic-review design's purview; noting for hand-off rather
  than as a design-panel concern.

## Counts

- Must-fix: **1** (one in-scope cluster; the cluster collapses three
  related sub-issues on §4 that should be addressed together).
- Should-fix: **9** (in scope).
- Out-of-scope / follow-up: **5** (one weaver-routing flag, four
  comment-only prose nits).

## Loop status

- Loop **does not terminate** on this round. Must-fix is non-empty
  and in scope.
- **Next stage owed**: fixer dispatched against PR #252 with the
  must-fix and should-fix items inline. After the fixer pushes, a
  judge re-dispatch runs the same design panel against the fixer's
  HEAD to verify §4's revision and surface any new findings the
  revision introduced.
- **Weaver routing note**: the PR is `CONFLICTING` against `llm`.
  The orchestrator should dispatch a weaver before the fixer (or
  before the next judge round consumes the fixer's output) so the
  fixer is not pushing onto a non-mergeable head. Per
  `skills/pr-creation-flow/SKILL.md` § The next-stage-owed
  heuristic step 1 (PR is `CONFLICTING`: weaver is owed first).
- **No `gh pr ready` issued.** The judge does not un-draft on a
  must-fix verdict. Per-action authorization for un-draft is
  unconsumed.

## Definition of done check

- Each of the five seats' findings is embedded above (per-seat
  high-level findings). No separate `result` entries per seat,
  consistent with in-band-fallback (the seats are sections of the
  judge's notes, not separate dispatches).
- One formal `gh pr review` submitted (as `--comment` per the
  self-review fallback).
- This entry names the PR number, the panel kind (`design-panel`),
  the panel execution mode (`in-band-fallback`), the verdict, the
  must-fix / should-fix / out-of-scope counts, and the next-stage-
  owed (fixer, gated on weaver). The orchestrator can route the next
  dispatch directly from this entry.

Self-improvement: nothing this time. The design panel's in-band-
fallback procedure ran cleanly against five seats on a single design
document; the self-review fallback hit on `--request-changes` and the
`--comment` substitution per `skills/panel-review/SKILL.md` § Self-
review fallback worked as documented; the aggregated body's word
count (1172) landed slightly above the design-panel target band
(600 to 1000) but within the 25% allowance, and the must-fix
cluster's three sub-problems on § 4 collapsed cleanly into one
fixer-addressable item.
