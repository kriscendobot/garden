Fix stage round 3 complete for kriscendobot/minion.town PR #96.

## What I did

Read the panel round-3 verdict (disposition: **must-fix**) on the design doc `designs/claude-agent-credential-reauth.md` and applied every request-changes and must-fix finding across the seven jurors that raised them, plus the low-risk should-fix/comment-only items. One follow-up commit (`efb9977`), pushed via `safe-push-pr-head.sh`; CI came back **GREEN**.

## What changed (single file: `designs/claude-agent-credential-reauth.md`, +174/-49)

- **critic** — added a § 8 acceptance bullet exercising the `unclassified` bounded-retry-then-advisory path; dropped the unresolvable `(§ 6)` pointer on the `resource-bounded` row (it re-queues against the harness's own pre-existing per-inference bound, which § 6 doesn't define).
- **skeptic** — (1) restated the base design's "asserted, not verified" caveat on `claude auth status --json` and made version-pinning + fail-closed-to-`unclassified`-on-drift an acceptance criterion; (2) added a per-principal upstream check-rate bound on `requestReauth()`, stated in § 3 and tested in § 8 independently of mail dedupe; (3) stated `ReauthTicket` persists across a daemon restart between mint and `connect()` and made it an acceptance criterion.
- **decomplector** — (1) split the `unclassified` retry ceiling into an independently named `unclassifiedRetryCeiling` deployment parameter (now three named bounds); (2) justified the ticket indirection against the direct-reuse alternative on security (never mail a standing non-attenuated `connect`/`disconnect` authority) and uniform-code-path grounds.
- **novice** (must-fix) — clarified § 6 resumption as pull-by-default / push-as-optimization, with the reauth-complete notification explicitly never load-bearing; signposted the § 3 pivot into the escalation facet.
- **copyeditor** — "keeps apart" complement, explicit "The leaf" subject, "reincarnation" gloss, and split the dense § 8 bullets into single-claim bullets.
- **ergonomist** — added fixed outer-then-inner dispatch guidance for the `infer()` union; documented `consumed`/`already-connected` as identical operator-facing success copy.

pedant and orthographer approved with no findings; nothing to apply there.

## Notes / follow-ups

- Per stage instructions I did **not** re-run the panel — the driver re-posts panel-4.
- `package-lock.json` was touched by the warm-cache install; left unstaged, only the design file was committed.
- PR #96 head is now `efb9977`, MERGEABLE, still draft (design PR).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr96-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2478524 cached reads)
- Output: 24211 tokens
- Cost: $2.6719160000000004
- Wall-clock: 438s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
