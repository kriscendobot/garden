---
title: §Comment-density per line
source: endo packages/panic/{index.js,README.md,SECURITY.md,CHANGELOG.md}
source-slug: endo--packages-panic
ingest-cycle: 197
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal]
keywords:
  - ponyfill-vs-shim distinction
  - Eval Twin Problem
  - registered-symbol vs novel-subclass
  - three-layer dispatch chain
  - infinite-regress check
  - throw-rather-than-infinite-loop
  - lastResortError as identity check (forgeable + non-forgeable both honestly named)
  - prepare-commit-transactional-pattern as canonical use-case
  - Don't Remember Panicking TC39 proposal
  - PanicEndowmentSymbol following passStyleOfEndowmentSymbol precedent
  - default-erroneous-exit + no-ambient-normal-exit
  - historical-note-explaining-why-ambient-panic-no-longer-loses-security
related:
  - endo--packages-pass-style (sibling: PassStyleOfEndowmentSymbol precedent + Eval Twin Problem)
  - endo--packages-errors (panic README: makeError/X/q template tag)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: also cites Eval Twin defenses + qp-vs-q template tag pair)
  - endo--packages-init-and-lockdown (cycle 183: two-phase init also depends on SES primordials)
parent: endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop
---

@endo/panic is comment-heavy. Of 75 lines in `index.js`:
- ~25 lines are JSDoc and pure-comment lines
- ~17 are blank
- ~33 are executable

§Two-thirds-of-the-file-is-prose-rationale. The package is small not because the design is shallow but because §each-line-required-a-paragraph-of-rationale. The README adds another 58 lines of prose. Total prose vs code is roughly 5:2 — §the-knowledge-density-is-deliberately-in-the-text-not-the-tokens.

This puts @endo/panic in the §small-files-with-large-knowledge-density family alongside cycles 165 (where), 167 (where index.js), 169 (where browser-stub), 171 (where node), 173 (where xs), 175 (harden-selector), 177 (lockdown-noop), 179 (lp32), 181 (base64), 183 (init + lockdown), 185 (check-bundle), 187 (shim+prepare-endo cluster), 189 (marshal-justin), 191 (zip src cluster), 193 (compartment-wrapper), 195 (cli/src utility cluster). §Fourteenth-member of the family.
