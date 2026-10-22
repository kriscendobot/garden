---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix kriscendobot/minion.town#201: New Clip can rewrite itself AND freeze itself

Repo: kriscendobot/minion.town · PR: https://github.com/kriscendobot/minion.town/pull/201
(head `feat/new-clip-inventory`, base `main-6c66c2f`, draft; head at review time `e5c652d4`).

Maintainer ruling (kriskowal, review
https://github.com/kriscendobot/minion.town/pull/201#pullrequestreview-5607671425, 2026-10-21):
"The New Clip template is indeed intended to be able to rewrite itself but must be able
to freeze itself."

Read as the answer to the PR's standing authority question (`designs/new-clip.md`
§ Open questions; the #85 departure): self-rewriting through the clip power is
**intended**, so keep the writable `back` (the interim option (a)), but the clip must be
able to **freeze itself**. Work:

1. Add a one-way **freeze** to the clip power (`src/endo/gateway/new-clip.ts`): after
   `freeze()`, `metamorphose` and every mutator (create/write/remove/makeDirectory, in
   nested apps too) refuse; reads (`getForm`, `list`, previews) keep working. Freeze is
   irrevocable through the power, idempotent, and **durable** — recorded in the clip's
   space so it survives a daemon restart and a fresh CapTP connection, and a frozen
   clip never regains write access from any URL holder. Expose `isFrozen()` (or equivalent)
   so the page can tell.
2. The page (`clips/new-clip/`): a Freeze control, with a confirm step since it is
   irreversible; a frozen clip renders read-only (no `+`, remove, create, or
   metamorphose controls). Keep the existing double-click / view-capture discipline.
3. Tests: power tests that every mutator refuses after freeze (root and nested app),
   reads still work, freeze is idempotent and survives a restart/reconnect; extend the
   browser demo to freeze and check the controls disappear.
4. `designs/new-clip.md`: record the ruling in § 3 (self-rewrite is intended; freeze is
   the owner-or-visitor's way to make it immutable), and resolve the Open question
   citing the review URL above. Keep #88 nonce gating as a § 6 follow-on unless the
   maintainer says otherwise. Update the PR body's **Authority** paragraph to drop
   "needs the maintainer's sign-off" in favor of the ruling.
5. Reply on the PR to the review (cite commits), per pr-review-thread-replies.

Design gaps to resolve conservatively (and note in the reply, not as blockers): whether
freeze should also be holdable separately from write authority. Do NOT add a new
endpoint, channel, or per-entity resource beyond the freeze method and its persisted
flag; if a real design fork appears, park it with `post-plan.sh --awaiting-maintainer`
citing the review URL. Leave the PR draft/undraft state to the gauntlet.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T00:12:18Z
