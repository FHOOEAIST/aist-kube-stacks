#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

wrapper=""
if [[ "${RESTARTABLE}" == "yes" ]]; then
    wrapper="run-one-constantly"
fi

if [[ ! -z "${PASSWORD}" ]]; then
    pw_hash=$(python /usr/local/bin/generate_token.py -p ${PASSWORD})
else
  echo "No PASSWORD set - using token"
fi

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then
    # launched by JupyterHub, use single-user entrypoint
    exec /usr/local/bin/start-singleuser.sh "$@"
elif [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
    . /usr/local/bin/start.sh $wrapper jupyter lab --NotebookApp.password=${pw_hash} "$@"
else
    echo "WARN: Jupyter Notebook deprecation notice https://github.com/jupyter/docker-stacks#jupyter-notebook-deprecation-notice."
    . /usr/local/bin/start.sh $wrapper jupyter notebook --NotebookApp.password=${pw_hash} "$@"
fi
