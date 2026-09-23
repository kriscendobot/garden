---
kind: review-miss
primary_job: kriscendobot-agoric-sdk-pr16-review-416988d1
verdict: miss
category: docs-drift
pr: 16
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/16#pullrequestreview-4691341878
identity: kriscendobot/agoric-sdk#16:review:4691341878:retro
producing_role: gardener
producing_job: fix-kriscendobot-agoric-sdk-16
missed_by: pr-review-thread-replies (fixer close-out); no gauntlet stage or juror seat reviews a garden-authored PR-thread reply for concision before it is posted
severity: minor
cluster: pr-description-reviewer-attention
cluster_pattern: A garden-authored maintainer-facing artifact (a PR description OR an inline review-thread reply) carries more prose than the reviewer needs, so the maintainer asks it be cut for concision / reviewer attention; a standing skill governs *authoring* it (pr-formation for bodies, pr-review-thread-replies for thread replies) but no gauntlet stage or juror seat *reviews the produced artifact* against that skill, so over-long garden-authored prose reaches the maintainer unpruned.
---

# Miss: PR #16 review — bot's thread reply too verbose ("study Grice's maxims")

dckc's review 4691341878 on #16 carried an empty top-level body and a single
inline reply on the `asPromise` thread (verbatim untrusted text at `comment_url`),
paraphrased: the bot's earlier answer to "which test proves the fail-closed
open+grant behavior is deliberate?" was too wordy — just naming or linking the test
code would have sufficed; be concise (he cites Grice's maxims). The primary loop
(`kriscendobot-agoric-sdk-pr16-review-416988d1`) addressed it cooperatively: it
posted a bare-permalink threaded reply pointing only at the test
(`delegation.test.ts` L480) and 👍-acknowledged the coaching. No code change was
warranted; the substantive question had already been answered — the complaint was
purely that the answer was buried in exposition.

## Grounds (miss)

This is a review miss, not new direction, and it is the same structural gap as the
first PR-16 miss (`kriscendobot-agoric-sdk-pr16-a45a180a`), just on a sibling
surface. The principle dckc invokes — a garden-authored, maintainer-facing artifact
should be pruned to what the reviewer needs — is a **standing garden concern**, not
a first-stated preference. `skills/pr-review-thread-replies/SKILL.md` already leans
concise (its reply template is a SHA citation plus "one-line explanation if
needed"), and the primary loop's own completion report conceded the point: "LLM PR
replies to reviewers should lead with the name/link and cut the exposition ... the
existing pr-review-thread-replies guidance already aligns." So a convention the
producing pipeline demonstrably holds was under-applied — the definition of a miss.

Crucially, this is **not** the un-mechanizable-taste situation that dismissed the
two mhofman reviews (`65885306`, `77ecb195`). Those asked for *deeper* docs or a
*naming* preference on correct, tested code that the panel had already caught twice;
building a "make the comment maximally explanatory" or "pick the wording two people
will prefer" probe would be a taste gate. dckc's complaint is the opposite polarity:
the artifact carried *too much* prose for a factual "which test?" answer. Concision
of a garden-authored reply is a prunable, sensable signal (a length/structure
heuristic, or a pruner-style lens over the outbound reply), exactly as the
description-concision miss judged its own sensing side constructable.

Why it slipped is the same **prevention-without-sensing** gap as the description
miss: the authoring skill (pr-review-thread-replies) governs *writing* the reply,
but the gauntlet's juror panel reviews **code**, never garden-authored
maintainer-facing prose. No seat, gate, or panel stage reads a produced PR-thread
reply and flags that it over-serves the reviewer, so its concision rides entirely
on the reply step getting it right the first time, with no review-cycle check to
catch a bloated reply before the maintainer does.

## Clustering note (join, with a broadened scope)

Joining `pr-description-reviewer-attention` rather than minting a lookalike. The
cluster's slug names the *first* surface (PR bodies), but the review-failure
pattern it captures is surface-independent: **no review-cycle check senses
over-verbose garden-authored maintainer-facing prose before the maintainer sees
it.** That pattern has now recurred on #16 across two distinct artifacts (the PR
description → `a45a180a`; this thread reply). Minting a separate one-member cluster
would hide the recurrence behind two never-tripping singletons; joining recognizes
it. The pattern statement is broadened here to cover both PR bodies and review-thread
replies, and their two authoring skills (pr-formation, pr-review-thread-replies).

## Threshold call recorded at this record's tail

Cluster `pr-description-reviewer-attention` after this join: **count=2**,
**prs={16}**. Still below the floor (**K≥3** misses across **≥2 distinct PRs**) —
and, decisively, both members are the *same* PR, so the two-PR requirement that
guards against one messy PR masquerading as systemic is unmet. **Hold below the
floor and accumulate.** The severity bypass does not apply: this is
`severity: minor` (a verbose reply costs the maintainer one round of coaching, not a
bug, security regression, or data loss), and the sensing side is a *gap to be
created* (no seat reviews garden-authored maintainer-facing prose) rather than an
existing deterministic rule that was ignored — so it is not the pure
sense-and-correct failure the bypass is reserved for. Recording it as a **miss**
(not a dismissal) is deliberate: the concision principle is encoded, so the next
maintainer concision complaint on a *distinct* PR should join this cluster and trip
the floor, at which point `review-improve-pr-description-reviewer-attention` should
dispatch with both halves — prevention: sharpen the concision rules in *both*
pr-formation and pr-review-thread-replies; sensing: a concision review over
garden-authored maintainer-facing artifacts (a pruner-style seat line or a
length/structure gate at PR-open and at reply-post) that fires before the
maintainer sees the bloat.
