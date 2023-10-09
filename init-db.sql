-- Connect to the 'applications_data' database
\c applications_data;

-- Create the 'applications' table
CREATE TABLE applications (
                              app_code SERIAL PRIMARY KEY,
                              name VARCHAR(255) NOT NULL,
                              app_group VARCHAR(255),
                              app_type VARCHAR(255),
                              description VARCHAR(20000) CHECK (description ~ '^[A-Za-z0-9 ]+$'),
                              app_cost DECIMAL(10, 2),
                              last_modified TIMESTAMP
);

-- Insert example rows to applications table for testing
INSERT INTO applications (name, app_group, app_type, description, app_cost, last_modified)
VALUES ('Rahatähtede tuvastaja', 'Kasutajaliides', 'Java', 'Tuvastab rahatahe jargi valuuta loeb koik rahatahed kokku ja arvutab kogusumma', 12732.50, NOW());

INSERT INTO applications (name, app_group, app_type, description, app_cost, last_modified)
VALUES ('Dokumentide uuendaja', 'Kasutajaliides', 'Python', 'Kasutaja avaldab soovi dokumendi uuendamiseks kui vajalikud andmed on olemas uuendatakse automaatselt', 7948.00, NOW());

-- Create the 'app_service' table with a foreign key reference to 'applications'
CREATE TABLE app_service (
                             app_code INT REFERENCES applications(app_code),
                             service_code SERIAL PRIMARY KEY,
                             name VARCHAR(255) NOT NULL,
                             type VARCHAR(255),
                             sub_type VARCHAR(255),
                             description TEXT,
                             last_modified TIMESTAMP
);

-- Insert example rows to applications table for testing
INSERT INTO app_service (app_code, name, type, sub_type, description, last_modified)
VALUES (1, 'Dollarite tuvastaja', 'LUA', 'REST', 'Suudab eristada erinevaid dollareid (USD, AUD, CAD).', NOW());

CREATE INDEX applications_idx ON applications USING gin(to_tsvector('english', name));
CREATE INDEX app_service_idx ON app_service USING gin(to_tsvector('english', name));
