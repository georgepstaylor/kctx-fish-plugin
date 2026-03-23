# kctx

A [Fisher](https://github.com/jorgebucaran/fisher) plugin for switching Kubernetes contexts scoped to the current shell session only, other terminal sessions are unaffected.

## Features

- Session-local context switching via a temporary kubeconfig copy
- Refreshes from source kubeconfig on every run to get latest contexts and credentials
- Fuzzy search with [fzf](https://github.com/junegunn/fzf)
- Preview panel showing cluster ARN, AWS profile, and namespace
- Tab completions

## Requirements

- [`kubectl`](https://kubernetes.io/docs/tasks/tools/)
- [`fzf`](https://github.com/junegunn/fzf) (optional — required for interactive picker only)

## Install

```fish
fisher install georgepstaylor/kctx-fish-plugin
```

## Usage

```fish
# Interactive fuzzy picker
kctx

# Switch directly by name
kctx my-cluster-context
```

Context changes are isolated to the current shell. Open a new terminal and it starts fresh!

### Custom Source Config

By default, `kctx` syncs from `~/.kube/config`. To use a different source:

```fish
set -gx KUBECONFIG_SOURCE /path/to/your/kubeconfig
```
