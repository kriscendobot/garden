---
title: Common confusions
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

- A body that starts with `#` is *not* invalid JSON to be tolerated;
  it is **deliberately not JSON**. Tools that assume the `body`
  field of a marshal envelope is JSON-parseable as-is are wrong on
  smallcaps wire shape. The discipline is to run the body through
  marshal's `fromCapData`, never through a generic parser.
- The `#`-prefixed body is *not* the same as the `#`-prefixed
  manifest constants (`#undefined`, `#NaN`, `#Infinity`) inside
  smallcaps strings. They share the character `#` but the body
  prefix is a one-time sentinel at position 0 of the body, while
  the manifest-constant sigil is at position 0 of a *string value
  inside* the JSON. Two different uses of the same character.
- "Default to 'capdata'" does *not* mean "capdata is the
  recommended format". The recommendation is smallcaps; the
  default exists for backward compatibility. New code should pass
  `serializeBodyFormat: 'smallcaps'` explicitly.
- The "ontogeny recapitulates phylogeny" joke does not imply a
  belief in Haeckel's actual theory (which is largely discredited
  in modern biology). It's a winking metaphor: each new marshal
  instance defaults through the older format the way (in the joke)
  embryonic development was once thought to repeat evolutionary
  ancestry.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L47-L409) at commit `da16a78e`.
