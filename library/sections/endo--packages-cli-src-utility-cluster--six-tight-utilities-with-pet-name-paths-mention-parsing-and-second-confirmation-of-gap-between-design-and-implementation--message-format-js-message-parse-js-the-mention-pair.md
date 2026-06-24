---
source: packages/cli/src/{pet-name,message-format,message-parse,number-parse,random,prompt}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/cli/src
source_path: packages/cli/src/pet-name.js, packages/cli/src/message-format.js, packages/cli/src/message-parse.js, packages/cli/src/number-parse.js, packages/cli/src/random.js, packages/cli/src/prompt.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
genre: §endo-source-comment-fragment §canonical-CLI-utility-cluster
cycle: 195
lane: chat
status: current
title: §message-format.js + message-parse.js (the @-mention pair)
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

§message-format.js (20 lines):

```js
export const formatMessage = (strings, edgeNames) => {
  let message = '';
  let index = 0;
  for (
    index = 0;
    index < Math.min(strings.length, edgeNames.length);
    index += 1
  ) {
    message += strings[index].replace(/@/g, '\\@');
    message += `@${edgeNames[index]}`;
  }
  if (strings.length > edgeNames.length) {
    message += strings[index].replace(/@/g, '\\@');
  }
  return JSON.stringify(message);
};
```

§message-parse.js (28 lines):

```js
const pattern = /@([a-z][a-z0-9-]{0,127})(?::([a-z][a-z0-9-]{0,127}))?/g;

export const parseMessage = message => {
  const strings = [];
  const petNames = [];
  const edgeNames = [];
  let start = 0;
  message.replace(pattern, (match, edgeName, petName, stop) => {
    strings.push(message.slice(start, stop));
    start = stop + match.length;

    edgeNames.push(edgeName);
    petNames.push(petName ?? edgeName);
    return '';
  });
  strings.push(message.slice(start));
  return {
    strings,
    petNames,
    edgeNames,
  };
};

// console.log(parseMessage('before @pet-name:edge-name and @other-pet-name to the end'));
// ...
```

§A-format/parse-pair. §The-§@-mention-protocol: `@petName`
mentions a pet by name; `@petName:edgeName` mentions a pet
with a §named-edge (used for capability-passing in CLI
commands).

§Format-and-parse-are-asymmetric:

- **§format** takes `(strings, edgeNames)` — the §tagged-
  template-literal-shape with edge-names interpolated between
  template strings.
- **§parse** returns `{strings, petNames, edgeNames}` — the
  §three-array-decomposition where `petNames` defaults to
  `edgeNames` when no `:edgeName` suffix is present.

§The-§@-escape-via-backslash discipline: `strings[index]
.replace(/@/g, '\\@')` escapes any literal `@` in the user-
supplied string portion. §Symmetric-to-the-§regex-match-
pattern (which won't match `\\@` since the regex starts with
`@` not `\\@`).

§The-§regex-pattern: `/@([a-z][a-z0-9-]{0,127})(?::([a-z][a-z0-9-]{0,127}))?/g`.

§Five-properties:

1. §Lowercase-letter-prefix (`[a-z]`) — pet names start with
   a lowercase letter.
2. §128-char-max (`{0,127}` after the prefix = 128 total).
3. §Allowed-charset (`[a-z0-9-]`) — lowercase + digits +
   hyphen.
4. §Optional-edge-name-via-colon (`(?::([a-z][a-z0-9-]{0,127}))?`).
5. §Global-flag (`/g`) — multiple mentions per message.

§The-128-char-limit is consistent with cycle 49-daemon-
locator-terminology and other Endo identifier conventions.

§Compare-to-cycle-189-marshal-justin's §SGML-comment-
injection-defense (the `<!` and `->` cases in badPair-
detector). §Both-are-§escape-injection-defense at different
scales; cycle 189 protects against HTML-comment formation in
minified JS; cycle 195 protects against literal-`@` being
misread as a mention.

§The-§example-comments-in-source (lines 24-28 of message-
parse.js):

```js
// console.log(parseMessage('before @pet-name:edge-name and @other-pet-name to the end'));
// console.log(parseMessage('@pet-name'));
// console.log(parseMessage('@pet-name:edge-name'));
// console.log(parseMessage('@pet-name:edge-name trailer'));
// console.log(parseMessage('header @pet-name:edge-name trailer'));
```

§Five-commented-out-console.log-examples as §inline-tests-
that-don't-run. §A-§quick-sanity-check disguised as a
comment block. §Tier-1-borrowing: §example-comments-in-source-
not-tests for §quick-mental-verification of a parser.

§Compare-to-cycle-191-zip's §`@see` URLs to Ralph-Brown-
Interrupt-List. §Both-are-§auxiliary-information-in-comments;
cycle 191 cites external docs; cycle 195 inlines examples.
