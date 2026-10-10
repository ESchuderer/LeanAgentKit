---
name: issues-github
description: "File, triage, and work through GitHub issues with gh (visibility check, duplicates, labels, body template, Fixes #n). Use when the user asks for GitHub issues, or when a review before push leaves findings unfixed."
---

# GitHub issue tracking

Needs `gh`, signed in (`gh auth status`). https://cli.github.com/manual/

If `AGENTS.md` names Jira as the issue tracker, use `issues-jira` instead.

## 1. Repository and visibility

```sh
gh repo view --json nameWithOwner,visibility
```

- Pass `-R <nameWithOwner>` to every `gh issue` and `gh label` command, and use `repos/<nameWithOwner>/...` with `gh api`; with forks or several remotes `gh` can pick another repository.
- `PUBLIC` or `INTERNAL`: issue text is readable beyond the team. Ask before filing.
- Never create a public repository (`gh repo create --public`) or change visibility (`gh repo edit --visibility`) unless the user says so for that repository.

## 2. Duplicates

Search open and closed issues before filing:

```sh
gh issue list -R <repo> --state all --search "<terms> in:title,body" --json number,title,state
```

Existing issue: comment on it (`gh issue comment <n> -R <repo> --body-file -`) instead of filing a new one.

## 3. One issue per finding

- Labels: one area label (component or package) and one type label: `bug`, `review-finding`, `needs-source-check`, `minor`, `performance`, `enhancement`.
- Missing label: `gh label create <name> -R <repo> --color <hex> --description "<text>"`. List: `gh label list -R <repo>`.
- Roadmap phases are milestones: `gh api repos/<repo>/milestones -f title="<phase>"`; list: `gh api "repos/<repo>/milestones?state=all"`. https://docs.github.com/en/rest/issues/milestones

```sh
gh issue create -R <repo> --title "<title>" --label <area>,<type> [--milestone "<phase>"] --body-file -
```

## 4. Body

```markdown
**Where:** `path/to/file:line`
**Problem:** one sentence.
**Failure scenario:** inputs and the wrong result; measured or inferred.
**Proposed fix:** the smallest change.
**Source:** code review, commit range, date.
```

## 5. Review before push

Findings not fixed before the push become issues. A finding that needs a person (a source check, a decision) also goes into the repository's manual to-do file, if it has one.

## 6. Work loop

1. Pick an open issue: `gh issue list -R <repo> --label <type>`.
2. Fix it with a test; run the project's checks.
3. Commit with `Fixes #<n>` in the message: GitHub closes the issue when the commit reaches the default branch. https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue
4. Push only after the review step.
5. After the push, only when the commit will not reach the default branch through a merge: `gh issue close <n> -R <repo> -c "Fixed in <sha>"`.
6. Report closed and still open issues.

## 7. Publication rules

- Issue text follows the repository's publication rules (for example no internal or confidential names), so the issues can move to a public repository later.
- `gh issue transfer <n> <owner/repo>` moves open issues only, only between repositories of the same owner, and never from a private to a public repository. Otherwise copy them. First `gh repo view <target> --json visibility`: `PUBLIC` or `INTERNAL`, ask the user before copying. Then `gh issue list -R <source> --state all -L 1000 --json number,title,body,labels,milestone,state,comments` (defaults: open only, 30), `gh issue create -R <target>` per issue, `gh issue comment` per comment (it posts as you: start it with the original author and date), and `gh issue close` for the closed ones. https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/transferring-an-issue-to-another-repository
- No secrets, tokens, or personal data in issues or comments.
