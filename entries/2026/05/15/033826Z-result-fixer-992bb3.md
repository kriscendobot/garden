---
ts: 2026-05-15T03:38:26Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/fixer--c26ee2
refs:
  - entries/2026/05/15/031627Z-result-judge-30e396.md
  - entries/2026/05/15/032334Z-result-weaver-a83159.md
---

# Addressed design panel verdict on PR #252

PR: [`endojs/endo-but-for-bots#252`](https://github.com/endojs/endo-but-for-bots/pull/252)
Branch: `design/ocapn-noise-session-reconnect`.
Pre-fixer head: `d58a075be` (weaver's rebase tip).
Post-fixer head: `94ad5162a`.
CI rollup at terminal: total=4, failed=0, sha=`94ad5162a` (all four
design-only checks green: `lint` 57s, `build` 24s, `browser-tests`
2m31s, `test` 3m23s).

Ten follow-up commits on top of the weaver's rebase, no force-push,
no inline review threads (kriskowal had no inline comments; only the
panel's `--comment` review was open). The panel's must-fix cluster
(one item collapsing three § 4 sub-issues) was addressed in a single
commit per `skills/review-feedback-followup-commits/SKILL.md` § Core
rules. The nine should-fix items were addressed one commit per
concern. The top-level summary citing every SHA landed at
[`#issuecomment-4456645208`](https://github.com/endojs/endo-but-for-bots/pull/252#issuecomment-4456645208).

## Must-fix and should-fix items by addressing SHA

| Item | Panel ref | Addressing SHA | Concern |
|---|---|---|---|
| must-fix 1 | § Must-fix cluster | `f99d927a` | § 4 Resumption handshake: cleartext-but-MAC'd phrasing replaced with "encrypted under continuous CipherState at next sequential nonce" (sub-issue a); `RESUME-ACK` added to procedural step 3 to match both Mermaid diagrams (sub-issue b); step 4 nonce-advance formula cites Option Resume rather than restating (sub-issue c). |
| should-fix 2 | § Rationale fact 3 | `797ec49e` | Introduce Noise primitives (ChaCha20-Poly1305 AEAD, per-direction CipherState `(key, nonce)`, per-message increment) at the top of fact 3; fix pronoun-antecedent slip ("lets an attacker forge the authenticator"). |
| should-fix 3 | CapTP idempotence | `7963d7de` | Add `Replay idempotence at the CapTP layer` block to § 4 enumerating per-op dedup: `op:deliver` by `(session, answer-position)`, `op:deliver-only` by `(session, deliver-id)`, `op:gc-*` / `op:listen` idempotent by construction, `op:ping` by `(epoch, sequence)`. |
| should-fix 4 | § 5 hard-timeout | `8f64af76` | Define terminal queue semantics on `SESSION_HARD_TIMEOUT`: per-pending-op rejection (answer-promise rejection for `op:deliver`, delivery-failed notification for `op:deliver-only`), `op:abort`-equivalent upward event, optional fail-fast enqueue rejection in the last `RECONNECT_BACKOFF_MAX` of the budget. |
| should-fix 5 | § 4 Noise nonce citation | `0f67d218` | Scope the Noise spec's MUST-monotonically-increase guarantee to the *local* CipherState counter; name peer-acked-recv-nonce as this design's extension of Noise's local counter rather than as a Noise property. |
| should-fix 6 | § Upgrade SYNACK | `6a0838e3` | State plainly that the OCapN-Noise handshake on `llm` does not today carry a capability-flag field; the amendment proposes adding it as itself an extension that ships with this amendment, alongside the `op:ping` proposal. |
| should-fix 7 | § Test Plan | `dc6d6b0e` | Add three adversarial tests: CapTP replay idempotence on reconnect, hard-timeout queue drain, cross-session `RESUME` replay. |
| should-fix 8 | § Phase 2 | `c16b2902` | Name a simulated-stall fault injector as Phase 2's own consumer; Phase 2 ships standalone value (queue+epoch + fault harness) while remaining Phase 3's structural prerequisite. |
| should-fix 9 | Heading capitalization | `476c84a1` | Convert all `###` and `####` headings in this design to Title Case to match the sibling `ocapn-noise-network.md` convention. Sweeping the rest of `designs/` to a single convention is out of scope (would be a separate groom-pass). |
| should-fix 10 | Copyedit pass | `94ad5162` | § 1 "This is symmetric" → "The protocol is symmetric"; § 3 Crossed-Hellos Tiebreaker step 2 imperative → present-indicative. (§ 4 nonce-formula restating cite was handled in `f99d927a`.) |

## Diff scope

- `designs/ocapn-noise-session-reconnect.md`: 167 insertions, 38 deletions.
- `designs/README.md`: 1 insertion, 1 deletion (`Updated` field bumped from 2026-05-14 to 2026-05-15 for the design's summary row).
- The design document also gained an `Updated` field in its own metadata table (2026-05-15).
- No source files touched; design-only PR.

## Out-of-scope items the panel called out (not addressed)

These ride out of the loop per `roles/fixer/AGENT.md` § Operating
norms (the fixer's lane is the current must-fix and should-fix list):

- § 6 prose tightening on the network-vs-core split (comment-only).
- "Stragglers" jargon in § 2 (comment-only).
- `makeSyrupsReader` / `makeSyrupsWriter` introduction in § 6 (comment-only).
- Open Question P3 (designator vs transcript hash) hand-off to the
  cryptographic-review design.

## Post-fix actions taken

1. Pushed `f99d927a..94ad5162a` to `origin design/ocapn-noise-session-reconnect`
   without force (10 follow-up commits on top of weaver's rebase tip).
2. Posted the top-level summary comment on PR #252 citing every
   addressing SHA: <https://github.com/endojs/endo-but-for-bots/pull/252#issuecomment-4456645208>.
3. Watched CI converge via `skills/pr-ci-watch/SKILL.md`: rollup
   terminal at total=4, failed=0, sha=`94ad5162a`.

## Per-action authorization receipts

- Push to `design/ocapn-noise-session-reconnect`: implicit in the
  dispatch's "fix #252" framing. Carried out.
- Top-level summary comment on PR #252: forwarded per-action
  authorization in the dispatch prompt. Carried out at
  `#issuecomment-4456645208`.
- Inline thread replies: would have been carried out, but kriskowal had
  no inline comments (the `gh api .../pulls/252/comments` length-check
  returned 0). The panel's verdict was a single `--comment` review,
  addressed wholesale via the top-level summary.

## Next-stage-owed

A judge re-dispatch is owed to re-run the design panel against
`94ad5162a` and verify the § 4 revision plus the should-fix coverage.
The PR remains a draft (the panel did not un-draft on the must-fix
verdict; this round's un-draft authorization is unconsumed unless the
judge's verification round terminates clean).

## Definition-of-done check

- Each must-fix and should-fix item from the panel is addressed in a
  citable commit (table above).
- No yarn.lock churn (design-only PR).
- Top-level PR summary lists items by SHA at
  `#issuecomment-4456645208`.
- CI is green on the new head (`94ad5162a`).
- This entry references the originating panel verdict and weaver
  result, includes the SHA-by-item table, and closes with
  `Self-improvement: ...`.

Self-improvement: nothing this time. The engagement was a textbook
application of the fixer's existing skill set (`pr-review-thread-replies`
absent because there were no inline threads; `review-feedback-followup-commits`
applied as one-concern-per-commit with the panel's must-fix cluster
deliberately collapsed into one commit per the panel's own framing;
`pr-ci-watch` carried the design-only four-check rollup to terminal).
One small operational note (zsh's `status` variable is read-only,
breaking a directly-pasted bash poll loop) was wrapped via `bash -c
'...'` rather than refactored; surfacing this as a `Note from the
field` on `skills/pr-ci-watch/SKILL.md` is borderline and would route
through a `message` to liaison per `roles/COMMON.md` § Improving your
role and skills, but the observation is single-engagement and below
the threshold rule's bar for landing a new pitfall row. Leaving as is.
