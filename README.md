![aistKube Stacks Logo](images/logo.png)

# aistKube Stacks

aistKube Stacks is based on the following projects:
* [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) 
  provides the base for the jupyter notebooks
  * BSD License (also known as New or Revised or 3-Clause BSD)
  * Folders:
    * main project folder
    * [base-notebook](base-notebook)
    * [minimal-notebook](minimal-notebook)
    * [scipy-notebook](scipy-notebook)
* [alpine-webdav](https://github.com/BytemarkHosting/docker-webdav)
  provides the base for the webdav image
  * MIT License
  * Folder: [alpine-webdav](alpine-webdav)
* [hostpath-provisioner](https://github.com/juju-solutions/hostpath-provisioner)
  provides the base for the custom storage provisioning
  * Apache License Version 2.0
  * Folder: [hostpath-provisioner](hostpath-provisioner)
  
## Differences

### Jupyter Docker Stacks

The following builds are kept: `base-notebook, minimal-notebook, scipy-notebook`.
All other builds are no interest to this build.
The base of the images is changed to fit the nvidia images which provide
cuda with TensorFlow and PyTorch. The base image is required to utilize 
Nvidia GTX 30xx gpus.

#### Nvidia Release Notes

* [PyTorch Release Notes](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/index.html)
* [TensorFlow Release Notes](https://docs.nvidia.com/deeplearning/frameworks/tensorflow-release-notes/index.html)

### alpine-webdav

This image is kept in original state. No changes.

### hostpath-provisioner

This image has one change to the original state. It customizes the name of the 
GO application to have a different storage provisioner but with the same 
functionality as the *microk8s.io/hostpath* provisioner.

## Getting Started

### Setup

First set the target registry as system variable or provide it as parameter 
and the image owner.

* Setting target registry:
  * Setting system variable: `export REG=xxx`
  * Setting as parameter: `make build-all REG=xxx`
* Setting image owner:
  * Setting system variable: `export IMGOWNER=xxx`
  * Setting as parameter: `make build-all IMGOWNER=xxx`

### Build this project

Available commands

* `make pull-base` to pull the base tensorflow image from the nvidia catalog
* `make pull-base BASEIMAGE=pytorch` to pull the base pytorch image from the nvidia catalog
* `make build-all` to build cuda tensorflow images
* `make build-all BASEIMAGE=pytorch` to build cuda pytorch images
* `make push-all` to push tensorflow images to the registry
* `make push-all BASEIMAGE=pytorch` to push pytorch images to the registry
* `make build/alpine-webdav` to build one image only
* `make build/base-notebook BASEIMAGE=pytorch` to build one image only with PyTorch base
* `make push/alpine-webdav` to push one image only
* `make img-rm` to remove all images that are related to this project and all dangling images
* `make help` provides the following print out:
  ```aidl
  aist/docker-stacks
  =====================
  Replace % with a stack directory name (e.g., make build/minimal-notebook)
  
  build-all                      build all stacks
  build/%                        build the latest image for a stack
  img-rm                         remove jupyter images
  pull-base                      pull a jupyter image
  push-all                       push all tagged images
  push/%                         push all tags for a jupyter image
  ```

## Usage

1. Build this project and push it to your registry (public or private)
2. Use the [aistKube](https://github.com/FHOOEAIST/aist-kube) to deploy the images as helm charts

## Jupyter Notebook Deprecation Notice

Following [Jupyter Notebook notice](https://github.com/jupyter/notebook#notice), we encourage users to transition to JupyterLab.
This can be done by passing the environment variable `JUPYTER_ENABLE_LAB=yes` at container startup, 
more information is available in the [documentation](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html#docker-options).

In April 2021 JupyterLab will become the default for all of the Jupyter Docker stack images, however a new environment variable will be introduced to switch back to Jupyter Notebook if needed.

After the change of default, and according to the Jupyter Notebook project status and its compatibility with JupyterLab, these Docker images may remove the classic Jupyter Notebook interface altogether in favor of another *classic-like* UI built atop JupyterLab.

This change is tracked in the issue [#1217](https://github.com/jupyter/docker-stacks/issues/1217), please check its content for more information.

## Resources

- [Documentation on ReadTheDocs](http://jupyter-docker-stacks.readthedocs.io/)
- [Issue Tracker on GitHub](https://github.com/jupyter/docker-stacks)
- [Jupyter Discourse Q&A](https://discourse.jupyter.org/c/questions)
- [Jupyter Website](https://jupyter.org)
- [Images on DockerHub](https://hub.docker.com/u/jupyter)

## Contributing

First make sure to read our [general contribution guidelines](https://fhooeaist.github.io/CONTRIBUTING.html).

## Licence

- BSD License [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks)
- MIT License [alpine-webdav](https://github.com/BytemarkHosting/docker-webdav)
- Apache License Version 2.0 [hostpath-provisioner](https://github.com/juju-solutions/hostpath-provisioner)
