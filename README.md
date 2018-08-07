# Build SKLearn for AWS Lambda

Steffen Kaiser describes how to build SKLearn python libraries for AWS Lambda here:
https://medium.com/@stekaiser/cba9355b44e9

This repository contains up-to-date commands to repeat these steps.

### Simple use:

If you simply want to add the sklearn libraries to your project:

```bash
docker run -v $(pwd):/outputs -it markmarijnissen/sklearn-build:latest
cp output.zip **LAMBDA_PROJECT_DIR**
unzip output.zip -d .
```

### Advanced use: Do it yourself

If you want to change the script:

- Tweak the scripts.
- Build a docker image: `docker build -t sklearn-build .`
- Run it: `docker run -v $(pwd):/outputs -it sklearn-build:latest`
- Copy `output.zip` to your directory.
- Unzip `output.zip`

### Changes from the blogpost:

- pandas is not installed (!)
