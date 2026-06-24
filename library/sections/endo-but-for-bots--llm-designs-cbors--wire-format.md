---
title: Wire format (plain + tag-24 byte-string frames with hex specimen)
source: designs/cbors.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0a99c7bc4a83b61b0b488146e262de08a588a998
source_date: 2026-05-05
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams, marshal]
status: current
notes: The hex specimens are load-bearing for implementers — `45 68 65 6c 6c 6f 41 41` for plain "hello" + "A"; `d8 18 45 68 65 6c 6c 6f d8 18 41 41` with tag 24. The strict reader (rejects indefinite-length, non-major-2, non-tag-24-wrapped-major-2) is the canonical "narrow surface, clear errors at the wire" pattern.
---

> Abstract: The wire is a concatenation of length-prefixed CBOR byte strings, each one of: **(1) plain byte-string head + payload** — major type 2 with argument = payload length (CBOR's short forms: 0-23 inline; 24/25/26/27 followed by 1/2/4/8 length bytes), followed by payload bytes; **(2) tag-24-wrapped byte string** — major type 6 with argument 24 (Encoded CBOR data item) followed by a plain byte string as in (1). The reader recognizes the wrapping and returns the inner payload. **Strict reader**: rejects any other initial byte — any major type other than 2, major 6 with any tag other than 24, any indefinite-length form. Hex specimen for "hello" + "A": plain `45 68 65 6c 6c 6f 41 41`; tag-24-wrapped `d8 18 45 68 65 6c 6c 6f d8 18 41 41`.

### Wire format

The wire is a concatenation of length-prefixed CBOR byte strings. Each frame is one of:

1. **Plain byte-string head plus payload.** Major type 2 (byte string) with an argument that names the payload length, followed by the payload bytes. The argument follows CBOR's standard short forms: 0 through 23 inline in the initial byte; 24/25/26/27 followed by 1, 2, 4, or 8 length bytes.
2. **Tag-24-wrapped byte string.** Major type 6 (tagged) with argument 24 (Encoded CBOR data item; [RFC 8949 § 3.4.5.1][rfc8949-tag24]), followed by a plain byte string as in (1). The reader recognizes this wrapping and returns the inner payload bytes.

[rfc8949-tag24]: https://www.rfc-editor.org/rfc/rfc8949.html#section-3.4.5.1

The reader rejects any other initial byte (any major type other than 2, or major 6 with any tag other than 24, or any indefinite-length form). This is intentional: a stricter reader catches misframed input earlier and gives a clearer error than a permissive one.

A specimen stream carrying two byte strings, the 5-byte payload `hello` and the 1-byte payload `A`, encodes plain (without tag 24) as the byte sequence (hex):

```
45 68 65 6c 6c 6f 41 41
```

Read top to bottom: `45` is "byte string of length 5" (major 2, argument 5 inline); `68 65 6c 6c 6f` is the payload `hello`; `41` is "byte string of length 1" (major 2, argument 1 inline); `41` is the payload `A`.

The same stream wrapped in tag 24 (writer set with `tagged: true`) encodes as:

```
d8 18 45 68 65 6c 6c 6f d8 18 41 41
```

where `d8 18` is "tag 24" (major 6, argument 24 in the next byte).

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
