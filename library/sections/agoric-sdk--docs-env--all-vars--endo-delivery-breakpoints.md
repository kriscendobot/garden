---
title: ENDO_DELIVERY_BREAKPOINTS
source: docs/env.md
source_repo: agoric/agoric-sdk
source_commit: 8051bed260133080a0d46339aefcc9baba5c1d34
source_date: 2026-03-31
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [tooling, repository-governance, errors]
status: current
parent: agoric-sdk--docs-env--all-vars
---

The value of this option should be a JSON string identifying for which
eventual-send message deliveries should a JS `debugger;` statement be executed.
The format of the JSON string is
```json
{
  <class-like>: {
    <method-like>: <countdown>,
    <method-like>: <countdown>,
    ...
  },
  <class-like>: {
    <method-like>: <countdown>
    ...
  },
  ...
}
```
Where
- `<class-like>` is either `"*"` or an alleged string tag of the receiving
   remotable (exo or far) object
- `<method-like>` is either `"*"` or a method name. There is not yet a syntax for symbols to name symbol-named methods, but there may eventually be.
- `<countdown>` is either `"*"` or a non-negative integer saying how many occurrences to ignore before breakpointing.

When the program is run under a debugger, it will breakpoint when the JS
`debugger;` statement is executed. When run normally without a debugger, the
`debugger;` statement will have no effect. The `debugger;` statement
is executed *before* the method is entered.

See https://github.com/endojs/endo/blob/master/packages/pass-style/test/_prepare-breakpoints.js for an example.

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
