---
title: Basic Non-SES Example
source: packages/ses/docs/secure-coding-guide.md
source_repo: endojs/endo
source_commit: 832ebbfad1259c13c98f3a12e4500e288feb5ac9
source_date: 2023-08-26
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

> Abstract: A worked example of code as it would be written without SES considerations. Demonstrates the kinds of assumptions developers naturally make (mutable shared objects, ambient authority) and the security implications. Used as the baseline against which the SES version (next section) is contrasted.

## Basic Non-SES Example

Consider the following non-SES simple example: a logging service with two customers:
the "writer" can append strings to a list, and the "reader" can read the
list. In plain JavaScript, this would be implemented with a simple pair of
functions that both close over the same mutable Array. We can hand each
function to a separate customer:

```js
// not secure! not in SES!
function makeLogger() {
  const log = [];
  function write(msg) {
    log.push(msg);
  }
  function read() {
    return log;
  }

  // give 'write' to writer, 'read' to reader
  return { write, read };
}
```

What can go wrong? First of all, the reader has too much authority: it gets a
mutable copy of the original list, which means it could remove items from the
log (this customer is *reader*, not a *reader-and-deleter*):

```js
function reader(log) {
  log.pop();
}
```

Next, because this isn't running under SES, both customers could change the
way `Array` works. One writer could prevent the logger from providing correct
service to a (different) correctly-functioning customer:

```js
function writer1(write) {
  Array.prototype.push = function(msg) {
    console.log('haha I ate your message');
  };
}

function writer2(write) {
  write('message that gets eaten');
}
```

Clearly, safe operation in the face of mutable intrinsics is nearly
impossible. SES exists to provide a safer environment, in which all
intrinsics are **frozen**. All subsequent examples are expected to be run in
a SES environment (for documentation on how to achieve this, look elsewhere
in this directory).


Source: [packages/ses/docs/secure-coding-guide.md](https://github.com/endojs/endo/blob/832ebbfad1259c13c98f3a12e4500e288feb5ac9/packages/ses/docs/secure-coding-guide.md) at commit `832ebbfa`.
