---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: host=endolin-garden-ece02cb4
handler-timeout: 900
---
Verify the gh token situation on THIS host (endolin-garden-ece02cb4) and report
plainly whether it is fine. READ-ONLY diagnosis plus, at most, one write probe on
a repo the bot owns. Do NOT provision, rotate, or edit any credential — the
maintainer provisions; you report.

WHY: on 2026-09-04 the job `minion-town-clip-content-store-gc-build` reported from
this host that it "cannot resolve a valid kriscendobot gh token, and the
unauthenticated REST limit is also exhausted", which blocked `ensure-pr.sh` from
opening a draft PR for branch `feat/clip-content-store-gc` at `1e4e0e9` on
kriscendobot/minion.town. Separately, on 2026-09-16 a DIFFERENT host
(oros-studio-garden-ce242c49) reported its bot PAT is denied write to
endojs/endo-but-for-bots (403 on both addComment and addPullRequestReview) while
SSH push to the head branch still succeeded. The maintainer wants to know whether
THIS host's token is actually healthy now.

CHECK AND REPORT, each as a plain pass/fail with the evidence:
1. Does the fleet's `gh` wrapper resolve an identity at all here? Report the
   authenticated login and confirm it is the BOT (kriscendobot), not the
   maintainer. Do NOT use the GARDEN_GH_IDENTITY=kriskowal override; if you find
   yourself wanting it, that itself is the finding.
2. What SCOPES does the token carry? The 09-04 failure was PR creation and the
   09-16 failure elsewhere was comment/review write, so report specifically
   whether repo/write and PR-create scopes are present.
3. What is the current REST rate-limit state (limit, remaining, reset)? The 09-04
   report said the unauthenticated limit was exhausted, which is the signature of
   a token that did not resolve at all rather than one that resolved and was
   refused. Say which of those two this is.
4. Read-probe a repo in each class the fleet touches: kriscendobot/minion.town,
   kriscendobot/garden, endojs/endo-but-for-bots.
5. ONE write-capability probe, on a repo the bot owns ONLY (kriscendobot/*) — e.g.
   whether `gh` can create a draft PR or post a comment there. Prefer a probe you
   can cleanly undo, and undo it. Do NOT write to endojs/endo-but-for-bots and do
   NOT touch agoric/agoric-sdk in any way.
6. Compare against how the identity is supposed to resolve
   (`scripts/jobs/bootstrap-bot-identity.sh`, `bot_name`/`bot_email` in
   `scripts/jobs/common.sh`, the journal `identity/<host>` override and the
   tracked `bot-identity-defaults.tsv`). If the git identity is right but the API
   token is missing or mis-scoped, say so — they are separate things and the
   09-04 report conflated them.

BOTTOM LINE the report must answer in one sentence: is this host's gh token fine,
and if not, exactly what does the maintainer need to provision?

If it IS fine, say so and additionally report whether
`minion-town-clip-content-store-gc-build` can now be re-run to open its draft PR —
that job's work is committed and pushed at `1e4e0e9` and only the PR opener failed.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T01:14:59Z
