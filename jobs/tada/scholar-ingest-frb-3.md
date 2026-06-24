Scholar cycle 4 (scholar-ingest-frb-3): ingested the kriskowal/frb grammar +
compiler SOURCE — the last frb backlog item. kriskowal/frb is now fully ingested.

Sources (5, per-file commit anchors): frb--grammar (grammar.pegjs, 2162ce7c, 4
sections), frb--compile-observer (2162ce7c, 2), frb--compile-binder (5a0203b2, 2),
frb--language (language.js, 70019397, 1), frb--parse (parse.js, 70019397, 1).
10 section files total, all topic reactive-bindings.

What the source adds over the README prose: implicit-mapBlock rewrite + inline
bare-function flag; the README-undocumented declarative MCS *sheet* sub-language
(@label { target <- source; on event -> handler }); the function-returning
tail/pipe left-fold; the open-world method/operator fallback in the observer
compiler; the enumerated invertible-roots set in the binder compiler; and the
algebra.js solve() routine behind "automatic algebraic inversion."

Two findings recorded: (1) prose-vs-source drift — unary + node is `toNumber` in
source but labeled `number` in the README (low-stakes, flagged for a possible README
fix); (2) job-framing correction — language.js is the stringifier's precedence/token
tables, NOT the parse/compile orchestrator (that is bind.js/observe.js); README
module paths frb/parse, frb/compile-observer, frb/compile-binder all verified.

Indexes: enriched concept frb-compiled-observer-tree (10 rows; "Deferred" note
cleared → "Source coverage", backlog empty); topics/reactive-bindings.md (new
source-section block, count 21→31 in topics/README.md); sources/README.md (5 rows +
frb-fully-ingested note); keywords.md (35 grep keywords). Skipped the 8665-line
auto-generated sections/README.md per "rely on directory listing" (cycle-3 frb did
the same). Worked in an isolated worktree off origin/journal2 to dodge a concurrent
collections ingest; resolved one sources/README.md rebase conflict (kept their
collections row, my frb rows). Follow-on jobs: none — frb backlog empty.
