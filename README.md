# Deploy GoatCounter on Render

This repo can be used to deploy [GoatCounter] on Render.

- It uses a custom [Alpine Linux](https://hub.docker.com/_/alpine) based Docker image to host GoatCounter.
- [Render Databases](https://render.com/docs/databases) are used to spin up a fully managed PostgreSQL instance.

## Deployment

### One Click

Use the button below to deploy Goat Counter on Render.

[![Deploy to Render](http://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

Then, on the dashboard, enter values for the `GC_USER_EMAIL` and `GC_PASSWORD` environment variables to create your GoatCounter account.

### Manual

See the guide at https://render.com/docs/deploy-goatcounter.

If you need help, chat with us at https://render.com/chat.

[GoatCounter]: https://www.goatcounter.com/
