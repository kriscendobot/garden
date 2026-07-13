---
kind: review-miss
primary_job: kriscendobot-agoric-sdk-pr16-a45a180a
verdict: miss
category: docs-drift
pr: 16
repo: kriscendobot/agoric-sdk
surface: pr-comment
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/16#issuecomment-4960033475
identity: kriscendobot/agoric-sdk#16:comment:4960033475:retro
producing_role: gardener
producing_job: fix-kriscendobot-agoric-sdk-16
missed_by: pr-open (pr-formation); no juror seat reviews the produced PR body
severity: minor
cluster: pr-description-reviewer-attention
cluster_pattern: A garden-authored PR description carries more prose than the reviewer needs (per-package change lists, contrast paragraphs, an inline verification breakdown) so the maintainer asks it be cut for concision / reviewer attention; the pr-formation skill governs *authoring* the body but no gauntlet stage or juror seat *reviews* the produced body against it, so an over-long description reaches the maintainer unpruned.
---

# Miss: PR #16 description too verbose for reviewer attention

dckc's PR-comment on #16 (comment `4960033475`) asks, paraphrased (verbatim
untrusted text at `comment_url`): make the PR description concise; optimize for
reviewer attention. The primary loop (`kriscendobot-agoric-sdk-pr16-a45a180a`)
addressed it by rewriting the body to roughly half its length, keeping the
one-signature summary, the scope note, the per-package change list, the
grant-before-open correctness detail, and a condensed verification line.

## Grounds (miss)

This is a review miss, not new direction, because the principle dckc invokes is
already a **standing garden instruction**: `skills/pr-formation/SKILL.md` exists
precisely so "a maintainer can review the change without first having to read the
diff," and it encodes a four-part body order (what / why / attend-to / out-of-scope)
plus two concision rules the produced body strained against — "state the
verification once in prose; if a longer audit trail is useful, link to it rather
than expanding it inline," and "behavior and intent, not diff." The reviewed body
(1444 chars, 18 lines) carried a per-package "What changed" bullet list, a
contrast paragraph about `OpenPortfolioWithAutoFeatures`, and an inline
"Verification" paragraph reciting test counts — exactly the reviewer-attention
bloat the skill warns against. So a convention the producing pipeline demonstrably
holds (pr-formation is consumed at the gardening PR-open step) was under-applied,
which is the definition of a miss.

The reason it slipped is a **prevention-without-sensing** gap, not an absent rule:
pr-formation governs *authoring* the body, but the gauntlet's juror panel reviews
**code**, never the produced PR prose. No seat, gate, or panel stage reads the
opened body and flags that it over-serves the reviewer. So the description's
concision rides entirely on the PR-open step getting it right the first time, with
no review-cycle check to catch an over-long body before the maintainer does.

Note the wider signal (context, not cluster members — these predate the retro
store and were never recorded as misses): PR-description quality is a recurring
maintainer touch-point — kriskowal #128 (2026-05-13, the very directive
pr-formation was extracted from: "redraft... do not include checklists or draw
attention to specific files") and agoric-sdk PR-7 (2026-06-30, conform title +
description to the template). dckc's "optimize for reviewer attention" is the same
family. The pattern is plausibly real; this is its first *recorded* instance.

## Threshold call recorded at this record's tail

Minting `pr-description-reviewer-attention` at **count=1**, **prs={16}** — well
below the floor (**K≥3** misses across **≥2** distinct PRs). **Hold below the floor
and accumulate.** The severity bypass does not apply: this is `severity: minor` (a
verbose description costs the maintainer a review round and one redraft, not a bug,
a security regression, or data loss), and although a standing skill (pr-formation)
did fail to fully bind, the sensing side is a *gap to be created* (no seat reviews
PR prose) rather than an existing deterministic rule that was ignored — so this is
not the pure sense-and-correct failure the bypass is reserved for. Recording it as
a **miss** (not a dismissal) is deliberate: the principle is encoded, so the next
maintainer concision complaint on a distinct PR should join this cluster and trip
the floor, at which point `review-improve-pr-description-reviewer-attention` should
dispatch with both halves — prevention: sharpen the pr-formation concision rules
the PR-open step applies; sensing: a PR-body review check (a pruner-style seat line
that reads the opened body, or a deterministic length/structure gate at PR-open)
that fires on an over-long body before the maintainer sees it.
