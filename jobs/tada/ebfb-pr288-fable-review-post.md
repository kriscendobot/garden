All three comments posted and verified.

## Completion report

Posted the completed Fable closer-review deliverable to endojs/endo-but-for-bots PR #288. Posting-only job — bodies treated as data, unchanged.

- **Host precondition:** `gh` resolves to the fleet wrapper (`/home/kris/scripts/jobs/bin/gh`) with working kriscendobot credentials (active account). Passed.
- **Idempotency:** pre-check found no existing `ebfb-pr288-fable-review` marker; proceeded.

Posted (each body written byte-for-byte to a temp file, `-F body=@file` to avoid quoting mangling):

1. BODY-1 → inline reply on thread 3522709721 (decode.js local `concat`): https://github.com/endojs/endo-but-for-bots/pull/288#discussion_r3525298834
2. BODY-2 → inline reply on thread 3522711204 (decode.js `materialize()` fast paths): https://github.com/endojs/endo-but-for-bots/pull/288#discussion_r3525298963
3. BODY-3 → top-level PR comment (closer-review summary): https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4886909660

**Verification:** re-queried after posting — the `ebfb-pr288-fable-review` marker is present in the issue comments and both inline replies resolve to their thread URLs. All three render.

No garden-repo changes; nothing to commit or push. No follow-ups — the review content itself proposes a fixer-ready refactor spec (items 1–3, optionally 4) that the maintainer/liaison may choose to dispatch as a separate fixer job.
