---
source_kind: web
source_url: https://erights.org/elib/equality/after-both.html
source_snapshot: http://web.archive.org/web/2020id_/http://www.erights.org/elib/equality/after-both.html
source_content_sha256: e9e8916b7f39f7b94ab2b8a624b71841848627cf0c61811c40208038c1356184
source_authors: [Mark S. Miller]
source_date: 2000-01-01
retrieved: 2026-06-27
ingested: 2026-06-27
ingested_by: scholar
section_count: 2
status: current
notes: "Mark Miller's *Four Party Partial Orders* (filename `after-both.html`) — the \"On to:\" successor of the [`web--miller-grant-matcher-puzzle`](web--miller-grant-matcher-puzzle.md) page. Defines the concurrency problem E's equality operators must solve (as the puzzle defined the security problem): a distributed equality construct must introduce a join into the otherwise-tree message-delivery order. Carries the E `join` implementation in full and the fork-merge delivery + partition rules. erights.org unreachable (ECONNREFUSED) on 2026-06-27; ingested from the Internet Archive `id_` original-bytes capture. Undated page; source_date is the equality-taxonomy-era approximation. The sibling page *Joining References* (`join.html`) is a stub (\"To be written\") that points here, and is not separately ingested. Idempotency anchor is source_content_sha256."
---

Mark S. Miller's *Four Party Partial Orders* is the equality-taxonomy page that follows the Grant Matcher Puzzle. Where the puzzle defines the *security* problem E's equality operations must solve, this page defines the *concurrency* problem the equality *operators* must solve: pure forks in a message-delivery specification yield only a tree order, but E's distributed equality construct — needed to satisfy the puzzle — must introduce a **join** (a merge node) into the delivery topology, making it a general partial order. The page gives the E implementation of `join` (asynchronous, bottoming out in the synchronous `==` primitive once both operands resolve and are co-located), explains the immediate-promise semantics of `def c := E.join(a, b)`, and lays out the precise delivery, failure, and partition rules that follow from "`c` is a fork of both `a` and `b`."

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--miller-equality-four-party-partial-orders--overview.md) | capability-theory, eventual-send | current |
| [joining-the-orders](../sections/web--miller-equality-four-party-partial-orders--joining-the-orders.md) | capability-theory, eventual-send | current |
