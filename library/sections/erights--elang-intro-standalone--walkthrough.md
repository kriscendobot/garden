---
title: "Standalone E Programs"
source_kind: web
source_url: https://erights.org/elang/intro/standalone.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/standalone.html
source_fetched_via: mirror
source_content_sha256: 1c864aec758a74878d251b1972dea9a374eef9718b8386efe1fabd8f3b4dd6ac
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory]
status: current
notes: Primary erights.org tutorial body chapter on packaging an E program as a shell-runnable script via the `rune` interpreter; reachable via the GitHub Pages mirror. Continues the finding-text example. The GUI-launchable subsection is an unwritten stub ("*** to be written") in the source. Companion to [erights--elang-intro-finding-text--walkthrough](erights--elang-intro-finding-text--walkthrough.md).
---

## Abstract

The E tutorial chapter that packages the `findall` text-search example from the previous chapter into a **standalone program** invokable from an operating-system shell, introducing the `rune` interpreter as the E program runner, the `#!/usr/bin/env rune` shebang line, and the `interp.getArgs()` mechanism for reading command-line arguments. It shows running the script under both the MS-DOS shell (`rune findall.e ...`) and bash (directly, once the shebang and an executable bit are in place), demonstrates feeding an E program on standard input via `rune - << FOO ... FOO`, and uses `throw(...)` for argument-count validation. The chapter's GUI-launchable subsection is an explicit unwritten stub ("*** to be written"). Use this to ground claims about how E programs were deployed and run outside the interactive elmer REPL, the `rune` runner, or E's command-line-argument convention.

## Walkthrough

The chapter takes the `find` / `findall` functions developed interactively in the previous chapter and saves them to a file `findall.e` so they can be run from the shell. The file begins with a shebang and adds command-line-argument handling:

```e
#!/usr/bin/env rune

/**
 * The find function from the E Tutorial, modified to show the pathname.
 * Prints all lines of a given file that contain a given substring.
 */
def find(file, substring) {
    for num => line in file {
        if (line.indexOf(substring) != -1) {
            print(file.getPath() + " : " + num + " : " + line)
        }
    }
}

/**
 * The findall function ... generalized to take an extension parameter.
 * Recursively walks a directory tree, printing matching lines in matching files.
 */
def findall(dirfile, ext, substring) {
    if (dirfile.isDirectory()) {
        for file in dirfile {
            findall(file, ext, substring)
        }
    } else if (dirfile.getName().endsWith(ext)) {
        find(dirfile, substring)
    }
}

def args := interp.getArgs()
if (args.size() != 3) {
    throw("usage: findall.e rootname extension substring")
}
def root := <file: (args[0])>
findall(root, args[1], args[2])
```

Relative to the interactive version, `find` is enhanced to print the full pathname (`file.getPath()`) and `findall` is generalized from hard-coded `.txt` to an `ext` parameter.

**Running from the MS-DOS shell.** Invoking `rune` with a file argument makes it read and interpret that file rather than prompting interactively:

```
C:\WINDOWS> rune findall.e
# problem: usage: findall.e rootname extension substring

C:\WINDOWS> rune findall.e c:/test .txt and
c:\test\jabberwocky.txt:1:'Twas brillig and the slithy toves
c:\test\jabberwocky.txt:2:Did gyre and gimble in the wabe:
...
```

The error path comes from the `interp.getArgs()` / `args.size() != 3` check, which calls `throw(...)` with a usage description to halt the program rather than continue "as if everything were fine"; the trailing stack traceback is noted as suppressible later. `rune --help` shows the full command-line syntax.

**Running from bash.** Bash is the recommended shell. If `rune` is on the path (the E installer does this by default) and an `env` is available at `/usr/bin/env`, the shebang line lets the script run directly:

```
BASH.EXE-2.02$ findall.e c:/test .txt and
```

**Feeding a program on standard input.** The `-` argument tells `rune` to interpret standard input as an E program file (not interactively), which composes with bash here-documents and shell scripts:

```
BASH.EXE-2.02$ rune - << FOO
> println(2 + 3)
> FOO
5
```

The chapter closes with a **"Making findall.e Launchable as a GUI Application"** heading whose body is the unwritten stub `*** to be written`; the GUI-packaging path the tutorial index advertises was never filled in on this page.

## See also

- [erights--elang-intro-finding-text--walkthrough](erights--elang-intro-finding-text--walkthrough.md): the previous chapter that develops the `find` / `findall` example interactively.
- [erights--elang-intro--tutorial-overview](erights--elang-intro--tutorial-overview.md): the tutorial index this chapter hangs from.
- [ocap-history--e-capdesk-polaris-market-history](ocap-history--e-capdesk-polaris-market-history.md): the library's E / CapDesk / Polaris survey this primary source grounds.

Source: [elang/intro/standalone.html](https://erights.org/elang/intro/standalone.html), fetched 2026-06-27 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elang/intro/standalone.html](https://erights.github.io/erights-org-website/elang/intro/standalone.html)), content SHA-256 `1c864aec758a`.
