-- Stock Diversity Database

-- Create Tables
CREATE TABLE groups (
  id    SERIAL,
  name  TEXT NOT NULL,
  CONSTRAINT groups_pk PRIMARY KEY (id)
);

CREATE TABLE roles (
  id    INTEGER,
  name  TEXT NOT NULL,
  CONSTRAINT roles_pk PRIMARY KEY (id)
);

CREATE TABLE users (
  id        SERIAL,
  username  VARCHAR(100) NOT NULL,
  password  TEXT NOT NULL,
  name      TEXT NOT NULL,
  group_id  INTEGER NOT NULL,
  role_id   INTEGER NOT NULL DEFAULT 3, -- User
  CONSTRAINT users_pk PRIMARY KEY (id),
  CONSTRAINT users_group_id_fk FOREIGN KEY (group_id) REFERENCES groups(id),
  CONSTRAINT users_role_id_fk FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE species (
  id          INTEGER,
  name        TEXT NOT NULL,
  short_name  VARCHAR(20) NOT NULL,
  CONSTRAINT species_pk PRIMARY KEY (id)
);

CREATE TABLE sources (
  id SERIAL,
  name


-- Insert default values
INSERT INTO roles (id, name) VALUES (1, 'App Administrator');
INSERT INTO roles (id, name) VALUES (2, 'Group Administrator');
INSERT INTO roles (id, name) VALUES (3, 'User');

INSERT INTO species (id, name, short_name) 
VALUES (1, 'Drosophila Melanogaster', 'Fly');

-- Insert test values
INSERT INTO groups (name) VALUES ('Marsh Lab');
