---
title: Feasibility versus cost — the magic-sets separation the planner adopts
source: notes/planning-adornment-and-cost.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The design note that grounds the planner redesign in the magic-sets literature and separates two concerns the earlier code fused. Planning orders premises by asking, per premise against the current bound set, *can this run yet, and if so what does it cost?* — today answered by two coupled pieces, the per-slot `Requirement` schema (feasibility) and `estimate(env)` (cost). The papers (Balbin et al.; Alviano) separate them cleanly: **adornment / SIPS = feasibility** (a SIPS fixes a total order over body literals plus, per literal, the variables passed to it from earlier ones; the adornment `bf…` is a *per-predicate* bound/free pattern, not a per-argument flag — it answers *can this literal be solved given these bound arguments, and which does it then bind*), while **cost = which SIPS to pick**, a model the papers deliberately leave unspecified (Balbin §3.1) and which `estimate` supplies. Two further points validate dialog-db's architecture: adornment is generated on demand and memoized, never enumerated (Alviano's lazy `Adorn`/`ProcessQuery` worklist — dialog-db's just-in-time adornment with plan caching is its demand-driven twin), and because adornment is demand-driven there is no global adornment table to keep in sync across peers.

## Where this fits

The query engine is moving the executable form off the syntactic AST onto a compiled `Plan` (the operator IR). Planning orders premises by repeatedly asking, per premise, against the current set of bound variables: *can this run yet, and if so what does it cost?* Today that question is answered by two coupled pieces: the per-slot `Requirement` schema (feasibility) and `estimate(env)` (cost). This note redesigns those two pieces to match how magic-sets actually separates them, and to remove the expressiveness gaps in the current encoding.

## What the papers prescribe

Classic magic-sets (Balbin et al.; Alviano) separate two concerns cleanly, and dialog-db should too:

- **Adornment / SIPS = feasibility.** A SIPS for a rule fixes a total order over body literals plus, for each literal, the set of variables passed to it from the literals before it (Balbin Def. 10). The adornment `bf…` of a predicate is the derived bound/free pattern of its arguments under that order. Crucially the adornment is a **per-predicate** notion ("a SIPS for rule `R` and adornment `α`"), not a per-argument flag. It answers *can this literal be solved given these bound arguments, and which arguments does it then bind*.
- **Cost = which SIPS to pick.** Balbin §3.1 states the SIPS choice "is guided by factors such as the current and expected size of the different relations and the indexing mechanism employed... we assume throughout that this choice has been made." The papers deliberately delegate cost to a model they do not specify. dialog-db's `estimate` is exactly that model, and being richer than the papers is correct, not a defect.

Two further points the literature settles, both validating the current architecture:

- **Adornment is generated on demand and memoized, never enumerated.** Alviano's `Adorn`/`ProcessQuery` (Fig 3.2-3.4) drive compilation from a worklist `S` of adornments *seen so far* and a set `D` of *already-processed* ones; an adorned predicate is added "unless it has been produced previously." Adornments are discovered lazily as evaluation reaches predicates and cached the first time each is needed. Eager enumeration of all `2^n` adornments is the thing the algorithm avoids. dialog-db's just-in-time adornment computation with caching (`ConceptQuery::evaluate` deriving the adornment from the first match and caching the plan) is the demand-driven twin of this worklist: it is the textbook algorithm, not a shortcut.
- **There is no global adornment table to keep in sync.** Because adornment is demand-driven and memoized per evaluation, each peer adorns lazily for the adornments its own queries demand and caches locally. There is no persistent cross-peer set of adornments that could drift. For a system where rules arrive from different peers and are compiled during query evaluation, the lazy form is the correct one; eager precomputation would manufacture exactly the sync problem it must avoid.

Source: [notes/planning-adornment-and-cost.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/planning-adornment-and-cost.md) at commit `f777fe7c`.
