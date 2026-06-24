---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: The §three-axis match grammar
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

The file's load-bearing taxonomy is three JSDoc typedefs:

- **`MatchStringTag = string | '*'`** — matches against the
  recipient's `@@toStringTag` after `simplifyTag()` strips a
  leading `'Alleged: '` or `'DebugName: '` prefix. *For objects
  defined with `Far` this is the first argument, known as the
  `farName`. For exos, this is the tag.* The `'*'` wildcard
  matches any recipient.

- **`MatchMethodName = string | '*'`** — matches against the
  method name. *Currently, this is only an exact match.* The `'*'`
  wildcard matches any method name. The §comment names a future
  hazard: *we may introduce a string syntax for symbol method
  names* — currently symbols can't be matched by string.

- **`MatchCountdown = number | '*'`** — `'*'` always breakpoint;
  `0` always breakpoint; positive integer decrements by one each
  match. The *skip-N-then-breakpoint* mechanism.

The three axes compose: `{tag: {method: countdown}}` at the
external surface; *every recipient × every method × every match
count* gets a decision.
