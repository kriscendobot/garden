---
role: designer
---

Repository: endojs/endo-but-for-bots
Source review: https://github.com/endojs/endo-but-for-bots/pull/826#pullrequestreview-4757241489

Design a lines() addition to every implementation of the readable blob interface. The method must return an exo stream of strings, one line per item, retaining the line terminator. Specify handling for CR, LF, CRLF, and a final unterminated line (an empty terminator). Include a buffer-length parameter following the exo-stream method convention. Produce the normal design-stage artifact and surface any unresolved compatibility or interface questions explicitly.
