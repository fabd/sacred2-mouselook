---
name: commit-with-git
description: Commits ONLY the staged changes with git.
disable-model-invocation: true
---

Commit **staged changes only** with git.

If there are several changes worth mentioning include a small list of changes.

Do NOT use conventional commits format (e.g. `feat:`, `fix:`, `chore:`).

First present the commit message in plain formatting.

Then use `AskUserQuestion` to ask for user confirmation before commiting.

Only add the following options:

1. Commit
2. Cancel

## Output style

- be on point, only explain something if there was an error
- if the git commit succeeded, confirm simply "Commit DONE."

## Important
Never use PowerShell here-string syntax (@'...'@). This runs in Git Bash on Windows — bash syntax only, no PowerShell.

Write the commit message with printf to stdin and pipe it to git, use double quoted strings and `\n` for newlines (to avoid using ANSI C syntax). Example:

```
printf "Add Prettier config\n\n- Add .prettierrc.js\n- Allow .prettierrc.js through .gitignore\n" | git commit -F -
```
