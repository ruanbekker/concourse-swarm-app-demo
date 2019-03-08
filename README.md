# concourse-swarm-app-demo
Concourse with Docker Swarm Demo

## Instructions

Create 2 branches for version files: `version-staging` and `version-prod`

Login to Concourse and save the target:

```
$ fly -t ci login -n main -c http://<concourse-ip>
```

Set the pipeline, point the config, local variables definition and name the pipeline:

```
$ fly -t ci sp -n main -c ci/pipeline.yml -p <pipeline-name> -l ci/<variables>.yml
```

You will find that the pipeline will look like below and that it will be in a paused state:

![](https://user-images.githubusercontent.com/567298/54060759-96dfd800-4206-11e9-9236-e3b86783417c.png)


Unpause the pipeline:

```
$ fly -t ci up -p swarm-demo
```

The pipeline should kick-off automatically due to the trigger that is set to true:

![](https://user-images.githubusercontent.com/567298/54060811-cbec2a80-4206-11e9-8de7-a0b308f20cef.png)

Deployed automatically to staging, prod is a manual trigger:

![](https://user-images.githubusercontent.com/567298/54060991-8e3bd180-4207-11e9-9726-2c01ca10d24a.png)

