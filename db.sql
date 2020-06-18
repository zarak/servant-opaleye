CREATE TABLE users (
    email VARCHAR UNIQUE NOT NULL,
    password BYTEA NOT NULL,
    PRIMARY KEY(email)
);

CREATE TABLE posts (
    id SERIAL,
    title VARCHAR NOT NULL,
    body VARCHAR NOT NULL,
    users_email VARCHAR NOT NULL,
    "timestamp" TIMESTAMPTZ DEFAULT now(),
    PRIMARY KEY(id)
);
