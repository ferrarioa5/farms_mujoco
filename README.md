# farms_mujoco

FARMS package for interfacing to the MuJoCo simulator.

## Original Repository

This repository is a fork of [`farmsim/farms_mujoco`](https://github.com/farmsim/farms_mujoco).

## Comparing with the Upstream Repository

To find differences between this fork and the original repository, run:

```bash
./compare_upstream.sh
```

To also see upstream development branches that are ahead of `main`:

```bash
./compare_upstream.sh --branches
```

The script will:
1. Add `farmsim/farms_mujoco` as the `upstream` remote (if not already configured)
2. Fetch the latest changes from upstream
3. Report any commits in the fork not in the upstream, and vice versa
4. Show any file-level differences between the fork and `upstream/main`
5. (With `--branches`) List upstream branches with commits not yet merged into `main`

## Installation

```bash
pip install -e .
```

See [requirements.txt](requirements.txt) for dependencies.
