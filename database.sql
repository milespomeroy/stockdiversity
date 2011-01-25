-- Stock Diversity Database
\set ON_ERROR_STOP

-- Create Tables and Indexes
CREATE TABLE groups (
  id    SERIAL,
  name  TEXT NOT NULL,
  CONSTRAINT groups_pk PRIMARY KEY (id)
);
COMMENT ON TABLE groups IS 'Groups of users. Like a lab or institute.';

CREATE TABLE roles (
  id    INTEGER,
  name  TEXT NOT NULL,
  CONSTRAINT roles_pk PRIMARY KEY (id)
);
COMMENT ON TABLE roles IS 'User roles for determining privileges.';

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
COMMENT ON TABLE users IS 'Users of the app.';
COMMENT ON COLUMN users.name IS 'Full name of the user.';
COMMENT ON COLUMN users.group_id IS 'FK: group user is a member of.';
COMMENT ON COLUMN users.role_id IS 'FK: defines privileges of user.';
CREATE INDEX users_group_id_idx ON users(group_id);

CREATE TABLE species (
  id          INTEGER,
  name        TEXT NOT NULL,
  short_name  VARCHAR(20) NOT NULL,
  CONSTRAINT species_pk PRIMARY KEY (id)
);
COMMENT ON TABLE species IS 'Species of stock.';
COMMENT ON COLUMN species.short_name IS 'Colloquial name.';

CREATE TABLE sources (
  id    SERIAL,
  name  TEXT NOT NULL,
  email VARCHAR(200),
  CONSTRAINT sources_pk PRIMARY KEY (id)
);
COMMENT ON TABLE sources IS 'Where stocks were obtained. Institutes, labs, professors.';
COMMENT ON COLUMN sources.email IS 'Email address of source.';

CREATE TABLE viabilities (
  id    INTEGER,
  name  TEXT NOT NULL,
  CONSTRAINT viabilities_pk PRIMARY KEY (id)
);
COMMENT ON TABLE viabilities IS 'Types of viabilities.';

CREATE TABLE stocks (
  id                SERIAL,
  stock_nbr         VARCHAR(30),
  species_id        INTEGER NOT NULL DEFAULT 1, -- Fly
  genotype          TEXT NOT NULL,
  source_id         INTEGER,
  acquired_dt       DATE,
  description       TEXT,
  viability_id      INTEGER,
  group_id          INTEGER NOT NULL,
  public_flag       BOOLEAN NOT NULL DEFAULT TRUE,
  availability_flag BOOLEAN NOT NULL DEFAULT TRUE,
  created_by        INTEGER,
  created_ts        TIMESTAMP WITH TIME ZONE,
  modified_by       INTEGER,
  modified_ts       TIMESTAMP WITH TIME ZONE,
  CONSTRAINT stocks_pk PRIMARY KEY (id),
  CONSTRAINT stocks_species_id_fk 
    FOREIGN KEY (species_id) REFERENCES species(id),
  CONSTRAINT stocks_source_id_fk
    FOREIGN KEY (source_id) REFERENCES sources(id),
  CONSTRAINT stocks_viability_id_fk
    FOREIGN KEY (viability_id) REFERENCES viabilities(id),
  CONSTRAINT stocks_group_id_fk
    FOREIGN KEY (group_id) REFERENCES groups(id),
  CONSTRAINT stocks_created_by_fk
    FOREIGN KEY (created_by) REFERENCES users(id),
  CONSTRAINT stocks_modified_by_fk
    FOREIGN KEY (modified_by) REFERENCES users(id)
);
COMMENT ON TABLE stocks IS 'Stock of genotype specific animals owned by a particular group.';
COMMENT ON COLUMN stocks.stock_nbr IS 'Optional reference identifier used by the group. Can contain numbers and letters.';
COMMENT ON COLUMN stocks.acquired_dt IS 'When stock was received from source.';
COMMENT ON COLUMN stocks.group_id IS 'Group owner of stock.';
COMMENT ON COLUMN stocks.public_flag IS 'Can all groups view this stock?';
COMMENT ON COLUMN stocks.availability_flag IS 'Is stock available? Alive?'; 
COMMENT ON COLUMN stocks.created_by IS 'User id that created record.';
COMMENT ON COLUMN stocks.modified_by IS 'User id that last modified record.';
CREATE INDEX stocks_species_id_idx ON stocks(species_id);
CREATE INDEX stocks_source_id_idx ON stocks(source_id);
CREATE INDEX stocks_viability_id_idx ON stocks(viability_id);
CREATE INDEX stocks_group_id_idx ON stocks(group_id);

CREATE TABLE comments (
  id          SERIAL,
  stock_id    INTEGER,
  comment     TEXT,
  created_by  INTEGER,
  created_ts  TIMESTAMP WITH TIME ZONE,
  CONSTRAINT comments_pk PRIMARY KEY (id),
  CONSTRAINT comments_stock_id_fk 
    FOREIGN KEY (stock_id) REFERENCES stocks(id),
  CONSTRAINT comments_created_by_fk
    FOREIGN KEY (created_by) REFERENCES users(id)
);
COMMENT ON TABLE comments IS 'Comments by group users on individual stocks.';
COMMENT ON COLUMN comments.created_by IS 'FK: User id that commented.';
CREATE INDEX comments_stock_id_idx ON comments(stock_id);

CREATE TABLE citations (
  id        SERIAL,
  stock_id  INTEGER,
  entry     TEXT,
  url       TEXT,
  CONSTRAINT citations_pk PRIMARY KEY (id),
  CONSTRAINT citations_stock_id_fk
    FOREIGN KEY (stock_id) REFERENCES citations(id)
);
COMMENT ON TABLE citations IS 'Published work that references a stock.';
COMMENT ON COLUMN citations.entry IS 'Text of the formatted citation.';
COMMENT ON COLUMN citations.url IS 'Optional web address.';
CREATE INDEX citations_stock_id_idx ON citations(stock_id);

CREATE TABLE chromosomes (
  id          SERIAL,
  species_id  INTEGER NOT NULL,
  name        VARCHAR(2) NOT NULL,
  CONSTRAINT chromosomes_pk PRIMARY KEY (id),
  CONSTRAINT chromosomes_species_id_fk
    FOREIGN KEY (species_id) REFERENCES species(id)
);
COMMENT ON TABLE chromosomes IS 'Chromosomes for each species.';
COMMENT ON COLUMN chromosomes.name IS 'Could be letter or number.';

CREATE TABLE affected_chromosomes ( -- AffectedChromosome model
  stock_id      INTEGER,
  chromosome_id INTEGER,
  CONSTRAINT affected_chromosomes_pk PRIMARY KEY (stock_id, chromosome_id),
  CONSTRAINT affected_chromosomes_stock_id_fk
    FOREIGN KEY (stock_id) REFERENCES stocks(id),
  CONSTRAINT affected_chromosomes_chromosome_id_fk
    FOREIGN KEY (chromosome_id) REFERENCES chromosomes(id)
);
COMMENT ON TABLE affected_chromosomes IS 'Chromosomes affected in mutation of stock. Many-to-many.';


-- Insert default values
INSERT INTO roles (id, name) VALUES (1, 'App Administrator');
INSERT INTO roles (id, name) VALUES (2, 'Group Administrator');
INSERT INTO roles (id, name) VALUES (3, 'User');
INSERT INTO roles (id, name) VALUES (4, 'Inactive User');

INSERT INTO species (
  id, 
  name, 
  short_name
) 
VALUES (
  1, 
  'Drosophila Melanogaster', 
  'Fly'
);

INSERT INTO viabilities (id, name) VALUES (1, 'Viable');
INSERT INTO viabilities (id, name) VALUES (2, 'Lethal');
INSERT INTO viabilities (id, name) VALUES (3, 'Homozygous Lethal');

INSERT INTO chromosomes (species_id, name) VALUES (1, 'X');
INSERT INTO chromosomes (species_id, name) VALUES (1, 'Y');
INSERT INTO chromosomes (species_id, name) VALUES (1, '2');
INSERT INTO chromosomes (species_id, name) VALUES (1, '3');
INSERT INTO chromosomes (species_id, name) VALUES (1, '4');


-- Insert test values
INSERT INTO groups (name) VALUES ('Marsh Lab');
INSERT INTO users (
  username, 
  name, 
  password,
  group_id, 
  role_id
)
VALUES (
  'miles', 
  'Miles Pomeroy', 
  'test',
  (SELECT id FROM groups WHERE name = 'Marsh Lab'),
  1 -- App Admin
);


