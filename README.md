# Pet API Rails

A simple Ruby on Rails API for managing pets, with Sidekiq background jobs and a simulated email inbox.

## Development with Docker

### Prerequisites

* Docker & Docker Compose installed

### Start the stack

From project root, run:

* Add master.key in `config` directory

```bash
touch config/master.key
echo "ab37c6580c52519a1efe3fecf9f9f53c" > config/master.key
```

```bash
docker-compose up --build
```

This will launch:

* **Web API**: [http://localhost:3000](http://localhost:3000) (Rails server)
* **Sidekiq UI**: [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)
* **Email inbox**: [http://localhost:3000/inbox](http://localhost:3000/inbox)
* **PostgreSQL**: on host `localhost:5432`
* **Redis**: on host `localhost:6379`

Containers:

* `web`  – Rails API and email previews
* `sidekiq` – Sidekiq worker processing jobs
* `db` – PostgreSQL database
* `redis` – Redis for Sidekiq queues

To stop:

```bash
docker-compose down
```

## API Endpoints

All endpoints use JSON request/response. Example `curl` commands assume the stack is running locally.

| HTTP Method | Path                           | Action                           | Example Request                                                                                                                           |
| ----------- | ------------------------------ | -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/pets`                        | List all pets                    | `curl http://localhost:3000/pets`                                                                                                         |
| GET         | `/pets/:id`                    | Get a single pet                 | `curl http://localhost:3000/pets/1`                                                                                                       |
| POST        | `/pets`                        | Create a new pet                 | `curl -X POST http://localhost:3000/pets -H "Content-Type: application/json" -d '{"pet": {"name": "Fido", "breed": "Beagle", "age": 3}}'` |
| PUT         | `/pets/:id`                    | Update an existing pet           | `curl -X PUT http://localhost:3000/pets/1 -H "Content-Type: application/json" -d '{"pet": {"age": 5}}'`                                   |
| PATCH       | `/pets/:id/expire_vaccination` | Mark a pet's vaccination expired | `curl -X PATCH http://localhost:3000/pets/1/expire_vaccination`                                                                           |

## Background Jobs

When a pet's vaccination is expired, the API will enqueue a background job:

```ruby
VaccinationExpiryJob.perform_later(pet.id)
```

The job sends a simulated email via `NotificationMailer#vaccination_expired`, which you can view in the inbox UI.

## Simulated Email Inbox

View all "sent" emails in development at:

```
http://localhost:3000/inbox
```

Each message includes details about the pet whose vaccination expired.

## Viewing Sidekiq Jobs

Monitor Sidekiq queues and job history at:

```
http://localhost:3000/sidekiq
```

---

Happy coding!
