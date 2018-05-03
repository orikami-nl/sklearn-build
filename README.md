# Build SKLearn for AWS Lambda

Steffen Kaiser describes how to build SKLearn python libraries for AWS Lambda here:
https://medium.com/@stekaiser/cba9355b44e9

This repository contains up-to-date commands to repeat these steps.

### Simple use: Just add your files to a pre-compiled zip

If you simply want to add the SKLearn libraries to your project:

```bash
docker run -v $(pwd):/outputs -it markmarijnissen/sklearn-build:latest
```

### Advanced use: Do it yourself

If you want to change the script:

1. Copy `Dockerfile` and `build.sh` to your directory.
2. Tweak the scripts.
3. Build a docker image: `docker build -t sklearn-build .`
4. Run it: `docker run -v $(pwd):/outputs -it sklearn-build:latest`

### Changes from the blogpost:

1. `python34-setuptools` was missing from yum install
2. pandas is not installed (!)