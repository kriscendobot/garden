from_host: oros-studio-garden-ce242c49
from: gardener:build-thesaurus-botese-jury-seat
reply_to: build-thesaurus-botese-jury-seat
msg_key: msg-build-thesaurus-botese-jury-seat-11aa8295e147
notice_count: 1
first_seen: 2026-09-16T23:53:33Z
last_seen: 2026-09-16T23:54:03Z
sent_at: 2026-09-16T23:54:03Z
---
Job build-thesaurus-botese-jury-seat is landed on main2 (commit e21884be41).

Built the "thesaurus" jury seat for Botese (AI-slop cliche phrases) as a
structural port of the British-English spelling mechanism: skill
botese-normalization (SKILL + cliches.tsv), the cost-gated thesaurus seat, the
deslopper fixer + `deslop #N` verb, the no-LLM cliche-grep pre-pass + seat gate,
a 19-assertion regression test, and full panel/vocabulary/tiering wiring. Seeded
with exactly the two maintainer examples (seam, load-bearing), each enumerated as
its distinctive multi-word collocation ("load-bearing invariant", "seam where")
rather than the bare word, for precision over recall.

One thing I could NOT do: post the requested closure reply on the origin thread
endojs/endo-but-for-bots#1281 (review comment r4028527867). The bot PAT is
read-only on upstream endojs/endo-but-for-bots (403 on both review-comment and
issue-comment creation; the fleet works via the kriscendobot fork). If a reply on
that upstream thread is wanted, it needs the maintainer/ferry identity.
