# test-review

This readme explains how to run the code.

## Setup

Firstly, ensure you have docker installed. 

After that, clone the repository

```bash
git clone https://github.com/pefcos/test-review.git
```

After cloning, `cd` into the repository and run the following commands:

```bash
docker compose up -d
docker sudo docker exec -it test-review-app-1 rails db:create
docker sudo docker exec -it test-review-app-1 rails db:migrate
docker exec -d -it test-review-app-1 bundle exec sidekiq
```

Now you can access the `localhost:3000` route in your browser and start using the application.

### Troubleshooting

If you have any problem starting the sidekiq process, the redis port may already be used in your system. You need to stop the redis process (or whichever other process is using the port 6379).
