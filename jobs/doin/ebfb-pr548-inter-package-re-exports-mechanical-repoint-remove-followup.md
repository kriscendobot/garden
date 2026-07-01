# Write the SECOND PR for #548's inter-package plain re-exports: the mechanical repoint-and-remove follow-up
Repo: endojs/endo-but-for-bots (bot direct push; bot identity). Base as #548's design targets (`llm`).
**Maintainer directive (erights — a maintainer; heed):** on #548 he wrote "please write **both** PRs
explained in this one … If not, please do." (review 4597038349; comment 4849619293).
**What #548 explains (per its body + #543):** the inter-package (cross-package) plain-re-exports work is
split into TWO PRs:
1. **#548 (MERGED)** — articulate the rule, add the style-guide entry, and **deprecate** the inter-package
   plain re-exports. ✅ done.
2. **Follow-up PR (MISSING — write this)** — the **mechanical repoint-and-remove pass**: repoint every
   consumer off the deprecated cross-package plain re-exports #548 deprecated, then **remove** those
   deprecated re-exports.
**Task:** write PR #2 — the mechanical repoint-and-remove follow-up for the **inter-package** case, mirroring
the already-done **intra-package** follow-ups (**#571** "refactor: intra-package plain re-exports, mechanical
follow-up (#544)", #570) but for the cross-package re-exports #548 deprecated. Enumerate the deprecated
inter-package re-exports, repoint consumers to the real source packages, remove the deprecated re-exports,
run local-verify (format/lint/build/test). Open it as a PR on endo-but-for-bots referencing #548 + #543.
**Then reply to erights on #548** confirming: #548 (PR 1) is merged, and this mechanical follow-up is PR 2
(link it) — so **both** PRs are now written. erights is a maintainer; be prompt and honest (verification-
integrity: cite what you ran). Bot fork; no upstream contact.

---
claim:
  host: endolinbot2
  gardener: 87
  claimed_at: 2026-07-01T22:23:50Z
