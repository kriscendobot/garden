---
title: Abstract
source: packages/marshal/src/marshal.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "47-60, 219-227, 387-409"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "Why marshal uses '#' as the JSON-illegal first-byte sentinel to discriminate smallcaps from capdata in a single decoder, and the historical reason capdata remains the default serializeBodyFormat"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, captp, ocapn]
status: current
parent: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator
---

`makeMarshal` returns a single `fromCapData` function that decodes
*either* capdata or smallcaps wire bodies. The discriminator is a
single byte: smallcaps bodies are prefixed with `#`, which is
illegal at the start of valid JSON, and the decoder checks
`body.charAt(0) === '#'` to route. The choice of `#` is not
arbitrary: the comment naming the encoder side ("Valid JSON cannot
begin with a '#'") establishes that `#` is the simplest character
that produces an unambiguous, single-byte sentinel. The decoder
side ("JSON cannot begin with a '#'") names the same property as
the signal it uses to route. The dual-format coexistence is also
why `makeFullRevive` builds both `reviveFromCapData` and
`reviveFromSmallcaps` up front and the dispatcher in `fromCapData`
picks one per call. Independently, the `MakeMarshalOptions`
defaults block carries a comment explaining why `serializeBodyFormat`
defaults to `'capdata'` rather than the now-preferred `'smallcaps'`:
"Default to 'capdata' because it was implemented first. Sometimes,
ontogeny does recapitulate phylogeny ;)" — a deliberate
backward-compatibility default that lets old callers continue to
work without code changes even after smallcaps became the
better-performing format. The three comments together document the
**dual-format coexistence discipline**: encode-side defaults to
the older format for compat, decode-side handles both transparently
via a one-byte sentinel, and migration to the newer format is
opt-in on the encode side.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L47-L409) at commit `da16a78e`.
