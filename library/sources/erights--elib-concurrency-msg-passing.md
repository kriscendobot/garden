---
source_kind: web
source_url: http://erights.org/elib/concurrency/msg-passing.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/msg-passing.html
source_fetched_via: mirror
source_content_sha256: 953aab5fa6dedb1f6f6b2fc077e549dfc18f931aa7e5fa45527ed4931bcf1988
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Message Passing — child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). One consolidated section: the six
  message-passing primitives, the immediate `.` call (NEAR only) with its
  resolve/smash/eject outcomes, and the eventual `<-` send in sendOnly and pipelined
  forms (the pipelined send's continuation is a promise Resolver). Ancestor of
  `@endo/eventual-send`'s `E()` / `E.sendOnly` and the promise-as-continuation model.
  source_date is an era approximation matching the sibling concurrency chapters.
---

**Message Passing** chapter under ELib — call-return versus the eventually operator,
and how return values come back. E has six primitives: the synchronous immediate call,
its three outcomes (success/failure/escape via resolve/smash/eject), and the
asynchronous eventual send in its sendOnly and pipelined forms. The pipelined send's
continuation is a promise's Resolver rather than a stack-frame, which is why
"eventual-ness" is contagious and the Layers of When are needed to recover control
flow. This is the model `@endo/eventual-send` implements.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [six-primitives-call-send-outcome](../sections/erights--elib-concurrency-msg-passing--six-primitives-call-send-outcome.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/msg-passing.html`.
- Content SHA-256 `953aab5fa6dedb1f6f6b2fc077e549dfc18f931aa7e5fa45527ed4931bcf1988`, 22601 bytes.
