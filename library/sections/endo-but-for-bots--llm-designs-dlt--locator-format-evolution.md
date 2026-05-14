---
title: Locator URL format — path-style addresses with inline connection hints
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, ocapn]
status: current
---

The locator URL format changes shape with this design. The formula
address moves from a query parameter onto the URL path; connection
hints move from repeated `at=` query parameters onto the path segment
itself with `@`-separated suffixes.

**Old format** (`locator.js:89-101`):

```
endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}
```

**Old invitation format** (`daemon.js:3166-3173`):

```
endo://{nodeNumber}?id={invitationNumber}&from={handleNumber}&at={hint1}&at={hint2}
```

**New format**:

```
endo://{peerKey}/{formulaAddress}?type={formulaType}
```

**New format with connection hints**:

```
endo://{peerKey}/{formulaAddress}@{hint1}@{hint2}?type={formulaType}
```

**New invitation format**:

```
endo://{peerKey}/{invitationAddress}@{hint1}@{hint2}?type=invitation&from={handleAddress}
```

The `from` parameter on invitations carries only the handle's formula
address; the peer key is implicit from the URL hostname (and is the
same as the inviter's peer key, since handles live on the inviter).

Three changes are doing work here:

1. **Formula address on the path, not in `?id=`.** The formula address
   is part of the resource identity, not metadata about a request for
   it; URL path placement reflects that.
2. **Hints inline with the address segment, separated by `@`.**
   Hints are a property of *how to reach a peer*, not a property of
   *which resource to ask for*. Putting them on the same segment that
   names the peer/formula keeps the structural grouping correct, and
   `@` is the natural separator (echoing `user@host` syntax).
3. **`?type=` becomes the only query parameter on standard locators.**
   The type is genuinely a request-time hint (a consistency check on
   the parsed locator), so it stays as a query parameter.

Parse is **format-aware**: `parseLocator` detects the old format by
the presence of an `?id=` query parameter and falls back to the old
parser, so existing locators in pet stores or chat history continue to
work without state migration. New code emits the new format; old
locators are transparently understood. No state migration is needed
because **pet stores hold formula keys (`{address}:{peerKey}`), not
locators** — locators are reconstructed at presentation time from the
key plus current peer hints (see
[[endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration]]).
