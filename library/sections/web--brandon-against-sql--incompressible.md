---
title: "Against SQL — Incompressible: variables, functions, expression substitution"
source_kind: web-essay
source_url: https://www.scattered-thoughts.net/writing/against-sql
source_content_sha256: 79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be
source_author: Jamie Brandon
source_date: 2021-07-09
ingested: 2026-07-06
ingested_by: scholar
topics: [query-languages]
status: current
---

## Abstract

The second critique: code is compressed by extracting shared structure into variables and functions and substituting expressions — programming 101 — and **SQL fares badly at all three**. **Variables:** you can't name a scalar without wrapping it in a `select` (and naming everything else in the row too); `AS` naming is forbidden in `GROUP BY`; the spec's workaround (refer to a grouped column by re-typing an expression that produces the *same parse tree*) is fragile (`x + 1` works, `x + + 1` doesn't) and can't cross any syntactic boundary. Table-valued CTEs didn't arrive until SQL:99. **Functions:** scalar functions (SQL:99), table-returning functions (SQL:2003), and table-taking functions (patchily supported) came late; and because **column names are part of types** and aren't themselves first-class, repeated structure that differs only in column names can't be compressed (`increments(@foo) union increments(select y as x from @bar)`). Windows, collations, encodings, the `extract` part argument — none are first-class values, so nothing involving them compresses. **Expression substitution:** SQL breaks the principle that any expression can be replaced by another of equal value — you can't freely substitute across its three disjoint expression kinds (DDL statements, table expressions, scalar expressions), and some table expressions depend on *syntax* not just value (`(select x from foo) order by y` sees a column `y` that isn't in the returned value; wrapping the inner select breaks it).

## Variables

Scalar values can be assigned to variables only as a column inside a relation — you can't name a thing without including it in the result, so a temporary scalar forces a new `select` (and naming all your other values). `AS` works anywhere a scalar appears **except** in a `group by` (`ERROR: syntax error at or near "as"`). Rather than fix this, the spec allows a novel naming form: refer to a grouped column by writing an expression that produces the *same parse tree*:

```sql
-- works, even though x isn't in scope in the select:
select (x + 1) * 2 from foo group by x + 1;
-- fails, because (x + + 1) isn't the same parse tree as (x + 1):
select (x + + 1) * 2 from foo group by x + 1;   -- ERROR
```

This can't cross any syntactic boundary (assigning the table to a variable or passing it to a function forces you to both repeat *and* explicitly name the expression). Repeated *tables* had no compression until CTEs (SQL:99).

## Functions

Repeated calculations with different inputs had no compression until scalar functions (SQL:99); table-returning functions until SQL:2003; and table-*taking* functions remain patchy (SQL Server's `create type ... as table` + readonly table-valued parameter is one of few). The deeper problem: **column names are part of types**, and aren't first-class, so if two tables differ only in a column name you must rename to compress (`increments(@foo) union increments(select y as x from @bar)`). A fantasy `with ps as (columns 'a,b,c,x,y,z') select $ps from foo order by $ps` is not expressible. The same holds for windows, collations, string encodings, and the `extract` part argument — anything touching SQL's several-hundred keywords. Functions and types are likewise not first-class, so structure differing in function or type can't be compressed.

## Expression substitution

Many languages guarantee that any expression can be replaced by another of the same value. SQL breaks this two ways. **First**, you can only substitute expressions of the same *kind* — SQL has statements (DDL), table expressions, and scalar expressions; using a scalar inside a table expression needs a wrapping `select`, and using a table expression inside a scalar is generally impossible unless it returns one column and is guaranteed ≤1 row (or fits a hard-coded pattern like `exists`) — otherwise it must become a lateral join. **Second**, some table expressions depend on *syntax*, not just value:

```sql
-- allowed: order by may see inside (select ...) a column y not in the result
(select x from foo) order by y;          -- returns x
-- same inner value, but no syntactic exception here:
(select x from (select x from foo) as foo2) order by y;   -- ERROR: column "y" does not exist
```

Compressing such structure requires first rewriting to explicitly select then drop the magic column.

Source: [Against SQL](https://www.scattered-thoughts.net/writing/against-sql) by Jamie Brandon, published 2021-07-09; content SHA-256 `79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be`.
