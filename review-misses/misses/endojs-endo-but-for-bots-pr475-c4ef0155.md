---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-c4ef0155
verdict: miss
category: process
pr: 475
cluster: silent-merge-drop-reconstruction
cluster_pattern: During a frozen-base reconstruction (restack/retcon) a semantic edit applied to one package/sibling is silently NOT propagated to its twins/consumers, leaving latent, test-passing inconsistencies; no rebase/reconstruction-fidelity check senses the dropped edit.
review_at: 2026-08-17T22:15:44Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5320890131
identity: endojs/endo-but-for-bots#475:comment:5320890131
producing_role: weaver/fixer (frozen-base restack/retcon campaign)
missed_by: rebase-hygiene-audit / gauntlet reconstruction-fidelity; per-commit incomplete-generalization signal ownable by changeset-auditor
severity: minor
grounds: |
  PR #475 is a long-running integration rebuilt linearly on a frozen base
  (llm-a54c3ad) through a multi-month restack/retcon campaign. During that
  reconstruction, byteArray-narrowing hardening edits (direct-index / set /
  instanceof-then-copy replaced by immutable-view-safe reads) were applied to
  some packages but silently omitted from sibling/twin packages that carry the
  identical byte-consuming shape. The maintainer had already diagnosed one such
  omission that broke crossed-hellos (asUint8, ocapn-noise, 2a63214e); this
  comment asks the bot to forensically hunt the REMAINING ones, and the primary
  found three latent drops that no test trips: @endo/bytes bytesEqual (commit
  53caf95d generalized 3 of 4 read-only byte ops and skipped the 4th),
  @endo/base64 encode (the feat(bytes,hex) hardening never reached base64's
  twin), and @endo/ocapn cbor diagnostic util. That a maintainer must ask for a
  bespoke audit is the review process not sensing these. The strongest single
  reviewable signal is bytesEqual: an incomplete generalization visible inside
  one commit's own diff (three siblings touched, one not) — a changeset-auditor /
  pruner observation. The base64/ocapn drops are weaker (require twin-awareness
  across packages not in the touching commit's diff). This is a frozen-base
  reconstruction-fidelity failure adjacent to but distinct from the existing
  merge-base-pinning cluster: that cluster is OVER-inclusion (an unpinned base
  entrains stray commits/artifacts); this is UNDER-propagation (a needed edit
  silently lost during reconstruction). Recorded as a distinct process cluster so
  a second instance on another PR trips the floor; held below dispatch this round
  (single PR, and the related merge-base-pinning improvement is already in flight
  and is the natural home for a reconstruction-fidelity check).
---

The maintainer sharpened an earlier distinction — a "silent merge drop" (an edit
lost during the frozen-base reconstruction) as distinct from a runtime "silent
drop" — and asked the bot to find all remaining silent merge drops in the commit
history, noting that not all of them cause the failure that was originally
diagnosed. The primary job answered with three latent, test-passing byte-consumer
sites where a narrowing/hardening edit reached some siblings but not others. See
comment_url for the verbatim (untrusted) text.
