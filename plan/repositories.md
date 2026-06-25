# Repositories

Maps each repository **slug** (used in design records' `repository` field) to its
**repository URL**. The plan tracks URLs, not GitHub `owner/name` pairs, so the
model stays open to repositories that are not on GitHub. A project may span
several of these.

Format: one `slug: url` line per repository. Lines that are not `slug: url` are
ignored (this prose included).

```
endo-but-for-bots: https://github.com/endojs/endo-but-for-bots
endo: https://github.com/endojs/endo
garden: https://github.com/kriskowal/garden
```

The allowed set is the repositories the garden actively develops. **`agoric-sdk`
is excluded unconditionally** ("we must not and cannot do anything for
agoric-sdk") and is intentionally absent here; the validator additionally rejects
any record whose `repository` resolves to it.
