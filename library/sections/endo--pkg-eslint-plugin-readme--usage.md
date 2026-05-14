---
title: Usage
source: packages/eslint-plugin/README.md
source_repo: endojs/endo
source_commit: dd24b13d
source_date: 2025-12-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, repository-governance]
status: current
---

> Abstract: How to enable the rules in your eslint config: extends, plugins, and rule-level configuration patterns.

## Usage

Extend a `plugin:@endo/CONFIG` in your `.eslintrc` configuration file. You can omit the `/eslint-plugin` suffix:

```json
{
    "extends": [
        "plugin:@endo/recommended"
    ]
}
```

`CONFIG` can be one of:

- `recommended` rules for code compatible with Hardened JS
- `imports` opinions on how packages should use imports
- `style` opinions on JS coding style
- `strict` all of the above
- `internal` rules only for packages within the Endo source repository


You can configure individual rules you want to use under the rules section.

```json
{
    "rules": {
        "@endo/rule-name": 2
    }
}
```


Source: [packages/eslint-plugin/README.md](https://github.com/endojs/endo/blob/dd24b13d/packages/eslint-plugin/README.md) at commit `dd24b13d`.
