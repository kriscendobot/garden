---
title: Command paths and the policy predicate language
source: README.md
source_repo: ucan-wg/delegation
source_commit: 1cb32dbc9d4d15a23bf9844a02515d760b81e816
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
topics: [ucan-authorization, capability-security, patterns]
status: current
---

> Abstract: The two attenuation axes a delegation carries in band. `cmd` is a slash-delimited path covering "exact Command specified and all the commands described by a paths nested under that specified command", designed for forward-compatible protocol extension. `pol` is a small predicate-logic language with jq-inspired selectors that constrains the `args` of an eventual invocation, made of equality, `like` glob matching, numeric inequality, the `and`/`or`/`not` connectives, and the `all`/`any` quantifiers, with the top-level array implicitly conjunctive.

## Command

> "The Command MUST be a `/` delimited path describing set of commands delegated. Delegation covers exact Command specified and all the commands described by a paths nested under that specified command."

> "The command path syntax is designed to support forward compatible protocol extensions. Backwards-compatible capabilities MAY be introduced as command subpaths."

> "By definition `'/'` implies all of the commands available on a resource, and SHOULD be used with great care."

## Policy

> "UCAN Delegation uses predicate logic statements extended with jq-inspired selectors as a policy language. Policies are syntactically driven, and MUST constrain the `args` field of an eventual Invocation."

> "A Policy is always given as an array of predicates. This top-level array is implicitly treated as a logical `and`, where `args` MUST pass validation of every top-level predicate."

> "Policies are structured as trees. With the exception of subtrees under `any`, `or`, and `not`, every leaf MUST evaluate to `true`."

> "A Policy is an array of statements. Every statement MUST take the form `[operator, selector, argument]` except for connectives (`and`, `or`, `not`) which MUST take the form `[operator, argument]`."

The operator set, as given in the spec's IPLD schema:

| Class | Operators | Argument type |
|---|---|---|
| Equality | `==`, `!=` | `Any` |
| Glob match | `like` | a wildcard string |
| Inequality | `>`, `>=`, `<`, `<=` | `Number` |
| Negation | `not` | a nested statement |
| Connective | `and`, `or` | an array of statements |
| Quantifier | `all`, `any` | a selector plus a nested statement |

Selectors are jq-inspired paths into the invocation arguments (`.from`, `.cc`, and so on), with documented differences from jq and a distinct form for selecting on bytes. Nested quantification is supported.

The design point worth noting: the policy language is deliberately syntactic and small. Because a validator has to run it offline with no access to the executor's world, anything that would require a lookup (is this account still active, does this file still exist) cannot be expressed here and has to be checked by the executor at execution time.

Source: [`README.md`](https://github.com/ucan-wg/delegation/blob/1cb32dbc9d4d15a23bf9844a02515d760b81e816/README.md) at commit `1cb32dbc`.
