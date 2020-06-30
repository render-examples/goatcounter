# Deploy Goat Counter on Render

This repo can be used to deploy [Goat Counter] on Render.

- It uses a custom [Alpine Linux](https://hub.docker.com/_/alpine) based Docker image to host Goat Counter.
- [Render Databases](https://render.com/docs/databases) are used to spin up a fully managed PostgreSQL instance.

## Deployment

### One Click

Use the button below to deploy Goat Counter on Render.

[![Deploy to Render](http://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

And provide values for `GC_USER_EMAIL` and `GC_PASSWORD` variables, which will form your user account.

Then, in Render Shell of the `goatcounter` web service execute following statement:

```shell
$ render-goatcounter create -email your.email@example.com -password YourPassword123
```

### Manual

See the guide at https://render.com/docs/deploy-goat-counter.

If you need help, chat with us at https://render.com/chat.

[Goat Counter]: https://www.goatcounter.com/
