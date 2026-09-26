## Completion report: `kriscendobot-minion.town-pr85-review-ca62c58f`

**Directive:** A CHANGES_REQUESTED review by kriskowal on kriscendobot/minion.town PR #85 (`feat(clip): in-place front-content upgrade on the live @sites path`), review id `5109090330`.

### What I found
- **Preflight:** PROCEED — no correlated peer resolution on the PR.
- **Enumeration:** The review carries **0 inline comments**; the review body itself is the whole unit of work. It is a **design directive**, not a code-fix ask, and it **reverses this PR's premise**. PR #85 upgrades a clip's `front` in place on a stable clip id (matching `designs/clip-ocap-synthesis.md` §§ 3.2/3.4). The maintainer's "worthy first experiment" instead calls for: (1) immutable clip content, cached forever; (2) a nonce-locator CapTP session with the nonce carried out of band in the URL hash (`#?v=1&p=...`, collected by the static site's JS); (3) upgrade = mint a fresh clip id + redirect (app migrates local storage); (4) a static local-storage schema plus static content an app can rely on; (5) the guest primer as the wiring contract for both.

### What I did
1. **Routed to a designer.** Captured all five directives (verbatim quote + normative decomposition, treated as untrusted design data) into a designer job `minion-town-clip-immutable-nonce-locator-design` (`role: designer`), instructing a design doc `designs/clip-immutable-nonce-locator.md`, a design PR against `main`, reconciliation with `clip-ocap-synthesis.md` (mark §§ 3.2/3.4 superseded), and explicit surfacing of the #85 disposition. **Verified on the board:** now claimed, in `journal/jobs/doin/minion-town-clip-immutable-nonce-locator-design.md`.
2. **Acknowledged on PR #85:** https://github.com/kriscendobot/minion.town/pull/85#issuecomment-5535568640 — summarized the redirect, named the routed design job, and **surfaced the supersession as an explicit option with the deciding question named** ("close #85 as superseded, or salvage the `@sites` wiring / owner gate / fs-record plumbing?"). Left #85 open pending the maintainer's call rather than closing it (a lifecycle action I did not unilaterally take).
3. Inbox drained (empty). No `main2` garden-source changes (routing job); no project-repo code mutations.

### Follow-ups
- The designer produces the design PR against `main` for line-by-line review.
- Maintainer decides #85's disposition (close-as-superseded vs partial salvage) once the design lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-review-ca62c58f.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1383948 cached reads)
- Output: 17013 tokens
- Cost: $1.5714195000000002
- Wall-clock: 342s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
