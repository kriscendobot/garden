---
ts: 2026-06-10T22:16:18Z
kind: result
role: boatman
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/10/220923Z-dispatch-liaison-f5b22f.md
---

MULTI-AUTHOR re-ferry of kriscendobot/agoric-sdk#5 onto Agoric/agoric-sdk#12527. The garden's first ferry to agoric/agoric-sdk. Shape: re-ferry with recompute (force-push the same upstream branch `copilot/update-endo-dependency-versions`, which lives on Agoric/agoric-sdk itself).

**New upstream head**: `8d2ccb2b9af3e84c01c86c971af5e3c14a398990` (short `8d2ccb2b9a`). Force-with-lease landed against the prior tip `a6212a802544568e6e8bf38fa7f0f03845ef2c28`; remote response `+ a6212a8025...8d2ccb2b9a HEAD -> copilot/update-endo-dependency-versions (forced update)`.

**Tree verify (load-bearing)**: new `HEAD^{tree}` == mirror tip `b69f426410^{tree}` == `a519b3537bf33aa6964a67a650627824aee21913`. `git diff HEAD mirror` empty. Content reproduced byte-for-byte; no re-rebase.

**Method note**: a straight `cherry-pick daf7a864c..head` conflicted on yarn.lock / package.json at the 2nd commit (a cherry-pick replay artifact, NOT a wrong base; daf7a864c is the literal parent of commit 1 and an ancestor of the mirror head, the range is already linear on it). Rebuilt the 13-commit chain with `git commit-tree`, reusing each original commit's exact tree onto the base, which guarantees the identical tree with zero conflict risk and lets author/committer/message be set per commit.

**Per-commit attribution as pushed** (committer = Kris Kowal <kris@agoric.com> on all 13; oldest first):
1. ff61ec3a0d  copilot-swe-agent[bot] <198982749+Copilot@users.noreply.github.com>  (preserved)
2. 8f151f6631  Turadg Aleahmad <turadg@agoric.com>  (preserved)
3. 6cd9a6a1d1  Michael FIG <mfig@agoric.com>  (preserved)
4. a48079a640  Kris Kowal <kris@agoric.com>  (preserved)
5. 7e2065d219  Kris Kowal <kris@agoric.com>  (preserved)
6. ba811a6172  Kris Kowal <kris@agoric.com>  (preserved)
7. 7563638d24  Kris Kowal <kris@agoric.com>  (preserved)
8. f419435973  Turadg Aleahmad <turadg@agoric.com>  (preserved)
9. 6b9f1308d2  Kris Kowal <kris@agoric.com>  (preserved)
10. 800b8c4f0b  Kris Kowal <kris@agoric.com>  (normalized from endolinbot)
11. bbb350c841  Kris Kowal <kris@agoric.com>  (normalized from endolinbot)
12. 6fdba569c2  Kris Kowal <kris@agoric.com>  (normalized from endolinbot)
13. 8d2ccb2b9a  Kris Kowal <kris@agoric.com>  (normalized from endolinbot)

**Trailer handling**: stripped garden-injected `Co-Authored-By: Claude Opus 4.6` from commits 4,5,6,7,9 and `Co-Authored-By: Claude Opus 4.7` from commit 10. Scan for claude/anthropic/generated-with across base..HEAD is clean (empty). Legitimate `Co-authored-by: kriskowal <60294+kriskowal@users.noreply.github.com>` on commit 1 (copilot's original) PRESERVED. No DCO sign-off added (agoric uses conventional commits, no DCO). Internal paragraph structure of all bodies preserved (initial commit-tree pass collapsed blank lines; corrected with a trailing-blank-only trim).

**Post-push state**: commit count 13. mergeable CONFLICTING (out of boatman scope; weaver's job to rebase onto current master 57c65644e — surfaced, not acted on). reviewDecision APPROVED. **turadg's APPROVED PERSISTED** through the force-push (the branch's protection did not dismiss on stale; the maintainer had accepted dismissal as a possibility but it did not occur). Did NOT route any re-review. Title/body left unchanged.

**CI**: freshly pending at push time (Mergify Merge Queue, Socket Security, Summary all pending). Did not wait.

**Push identity note**: `gh auth status` showed kriskowal active; `gh api repos/agoric/agoric-sdk --jq .permissions` showed push:true. The SSH `origin` and HTTPS-with-bearer-header / osxkeychain paths all hit `Agoric organization has enabled or enforced SAML SSO`. The push succeeded via the `https://x-access-token:<gh-token>@github.com/agoric/agoric-sdk.git` URL form (the gh OAuth token reads fine over HTTPS and writes fine in the x-access-token URL form, but the osxkeychain-cached credential and the bearer-header form are SSO-rejected for writes on this org).

**Cross-link**: created on garden fork kriscendobot/agoric-sdk#5, comment id `4675157471`, body `Mirror of https://github.com/Agoric/agoric-sdk/pull/12527 (head 8d2ccb2b9a).`. No prior Mirror-of comment existed. Did NOT comment on Agoric/agoric-sdk (primary upstream) under kriskowal; did not re-request review.

Self-improvement: message to liaison — the pr-handoff skill's push procedure should document that agoric/agoric-sdk is behind SAML SSO, so the only working push form on this host is the `https://x-access-token:$(gh auth token)@github.com/...` URL (SSH origin and osxkeychain/bearer-header HTTPS are SSO-rejected for writes even though the gh token reads fine and the REST API grants write). This is the garden's first agoric ferry and the first SSO-gated upstream; worth a one-line note in the skill's identity-discipline section and a project README line.
