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

## 2. Issue or OpenSpec change

- Issue: a defect, a review finding, or a task done in one commit.
- OpenSpec change (`openspec-propose`), when the repository has `openspec/`: work that changes behaviour. Its `tasks.md` is the task list, so no sub-issues. Name the issue in `proposal.md`; `Fixes #<n>` goes in the commit that completes `tasks.md`.
- Milestone: a roadmap phase, not a change. Create one only when the user names the phase.

## 3. Duplicates

Search open and closed issues before filing:

```sh
gh issue list -R <repo> --state all --search "<terms> in:title,body" --json number,title,state
```

`<terms>`: two or three plain words from the title, no quotes or search qualifiers.

Existing issue: comment on it (`gh issue comment <n> -R <repo> --body-file -`) instead of filing a new one.

## 4. One issue per finding

- Labels: one area label (component or package) and one type label: `bug`, `enhancement`, `performance`. Add `needs-source-check` when a person must verify a source or decide. The source of a finding is in the body, not a label.
- Missing label: `gh label create <name> -R <repo> --color <hex> --description "<text>"`. List: `gh label list -R <repo>`.
- Milestone: `gh api repos/<repo>/milestones -f title="<phase>"`; list: `gh api "repos/<repo>/milestones?state=all"`. https://docs.github.com/en/rest/issues/milestones

```sh
gh issue create -R <repo> --title "<title>" --label <area>,<type> [--milestone "<phase>"] --body-file -
```

## 5. Body

```markdown
**Where:** `path/to/file:line`
**Problem:** one sentence.
**Failure scenario:** inputs and the wrong result; measured or inferred.
**Proposed fix:** the smallest change.
**Source:** code review, commit range, date.
```

Enhancement: the outcome wanted instead of the failure scenario.

## 6. Review before push

The review before a push (global rule) reports unfixed findings and waits for the user. Offer to file them; after the user agrees, one issue per finding, `needs-source-check` where a person must verify or decide.

## 7. Work loop

1. Pick an open issue: `gh issue list -R <repo> --label <type>`.
2. A behaviour change in a repository with `openspec/`: `openspec-propose` with the issue number, then `openspec-apply-change` (section 2). Otherwise fix it with a test; run the project's checks.
3. Commit with `Fixes #<n>` in the message: GitHub closes the issue when the commit reaches the default branch. https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue
4. Push only after the review step.
5. After the push, only when the commit will not reach the default branch through a merge: `gh issue close <n> -R <repo> -c "Fixed in <sha>"`.
6. Report closed and still open issues.

## 8. Publication rules

- Issue text follows the repository's publication rules (for example no internal or confidential names), so the issues can move to a public repository later.
- `gh issue transfer <n> <owner/repo>` moves open issues only, only between repositories of the same owner, and never from a private to a public repository. Otherwise copy them. First `gh repo view <target> --json visibility`: `PUBLIC` or `INTERNAL`, ask the user before copying. Then `gh issue list -R <source> --state all -L 1000 --json number,title,body,labels,milestone,state,comments` (defaults: open only, 30), `gh issue create -R <target>` per issue, `gh issue comment` per comment (it posts as you: start it with the original author and date), and `gh issue close` for the closed ones. https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/transferring-an-issue-to-another-repository
- No secrets, tokens, or personal data in issues or comments.
