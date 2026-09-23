---
title: "A guarded orientation/position state machine"
source: examples/tetrominoes.kni
source_repo: kriskowal/kni
source_commit: 658b32406647c7f67a2355b87741cce2841570f0
source_date: 2018-02-10
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: The richest state machine in the examples corpus. An initializer block names the piece constants (`I=0 … Z=6`) and mutable state (`type`, `orient`, `speed`, `turns`); `@next` re-rolls a random `type` (`1~7`) and `orient` (`1~4`) and resets the height `y=20`; `@describe` renders the piece from `type` and `orient` through nested **cyclic `@orient`** switches and either lands it (`->next`) or reports its height; `@options` presents guarded moves — the *rotate* options live under a `- {type <> O}` **guard thread** (the O-piece is rotation-symmetric, so it offers no rotation), while move / drop / ask are always available.

The state is a single flat set of variables seeded by the `!` initializer, which doubles as a symbol table (`I`, `O`, … name the type indices). `@describe` is a large composed conditional: an outer `{(type)| … }` switch picks the piece phrase, and inside several arms a `{@orient| … }` *cyclic* switch (index modulo the arm's option count) picks the orientation phrase — so one `orient` variable drives differently-sized rotation sets per piece. The `# I`, `# O`, `# T`… comments inside the block annotate which arm is which. A second `{(y)| … }` switch either announces the landing (`->next`, re-rolling the next piece) or reports the height. The control heart is `@options`: `- {type <> O}` opens an *organizational thread* whose body — the two `+ rotate` options — is skipped whenever `type` equals the O constant, so an entire *group* of options appears or vanishes on a state predicate. Rotating mutates `orient` and costs a row of fall (`{-y}`); a horizontal move costs `speed` rows (`{-speed y}`); *drop* increments `turns` and jumps to `@next`; *ask* re-renders via `->describe`.

For authoring, `tetrominoes` is the reference for two things at once: (1) gating a *whole group* of options behind a condition using a `- {predicate}` guard thread (not just one option), and (2) driving rich, per-case rendering from a small state vector with nested `(expr)` and cyclic `@` switches. It generalizes the single-guard options of `door-lock` and `maze` to grouped guards, and shares its second-person bracket options with `door` and `tree`.

Source: [examples/tetrominoes.kni](https://github.com/kriskowal/kni/blob/658b32406647c7f67a2355b87741cce2841570f0/examples/tetrominoes.kni) at commit `658b3240`.
