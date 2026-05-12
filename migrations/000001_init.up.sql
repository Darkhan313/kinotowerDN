CREATE TABLE IF NOT EXISTS genders (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    parent_id INT NULL REFERENCES categories(id) ON DELETE SET NULL,
    deleted_at  TIMESTAMPTZ NULL
);

CREATE TABLE IF NOT EXISTS countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    fio VARCHAR(150) NOT NULL,
    birthday DATE NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ NULL,
    gender_id INT NOT NULL REFERENCES genders(id)
);

CREATE TABLE IF NOT EXISTS films (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    duration INT NOT NULL,
    year_of_issue INT NOT NULL CHECK (year_of_issue > 1800 ),
    age INT NOT NULL CHECK (age >= 0),
    link_img VARCHAR(255) NULL,
    link_kinopoisk VARCHAR(255) NULL,
    link_video VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ NULL,
    country_id INT NOT NULL REFERENCES countries(id)
);

CREATE TABLE IF NOT EXISTS categories_films (
    id SERIAL PRIMARY KEY,
    film_id INT NOT NULL REFERENCES films(id) ON DELETE CASCADE,
    category_id INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    film_id INT NOT NULL REFERENCES films(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ NULL,
    is_approved BOOLEAN deFAULT FALSE
);

CREATE TABLE IF NOT EXISTS ratings (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    film_id INT NOT NULL REFERENCES films(id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 10),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ NULL
);

INSERT INTO genders (name) VALUES
('Male'),
('Female'),
('Other');

INSERT INTO countries (name) VALUES
('USA'),
('Russia'),
('France'),
('Germany'),
('Italy'),
('Japan');

INSERT INTO categories (name, parent_id) VALUES
('Action', NULL),
('Comedy', NULL),
('Drama', NULL),
('Sci-Fi', NULL),
('Horror', NULL),
('Romance', NULL),
('Thriller', NULL),
('Adventure', NULL),
('Animation', NULL),
('Fantasy', NULL);

INSERT INTO categories (name, parent_id) VALUES
('Superhero', (SELECT id FROM categories WHERE name = 'Action')),
('Slapstick', (SELECT id FROM categories WHERE name = 'Comedy')),
('Historical', (SELECT id FROM categories WHERE name = 'Drama')),
('Cyberpunk', (SELECT id FROM categories WHERE name = 'Sci-Fi')),
('Psychological', (SELECT id FROM categories WHERE name = 'Horror')),
('Romantic Comedy', (SELECT id FROM categories WHERE name = 'Romance')),
('Crime Thriller', (SELECT id FROM categories WHERE name = 'Thriller')),
('Fantasy Adventure', (SELECT id FROM categories WHERE name = 'Adventure')),
('3D Animation', (SELECT id FROM categories WHERE name = 'Animation')),
('Epic Fantasy', (SELECT id FROM categories WHERE name = 'Fantasy'));

INSERT INTO users (fio, birthday, email, password, gender_id) VALUES
('John Doe', '1990-01-01', 'john.doe@example.com', 'password123', (SELECT id FROM genders WHERE name = 'Male'));
INSERT INTO users (fio, birthday, email, password, gender_id) VALUES
('Jane Smith', '1985-05-15', 'jane.smith@example.com', 'password456', (SELECT id FROM genders WHERE name = 'Female'));

INSERT INTO users (fio, birthday, email, password, gender_id) VALUES
('Иванов Иван Иванович', '1990-01-01', 'ivanov@example.com', 'hashed_password', 1),
('Петров Петр Петрович', '1985-05-15', 'petrov@example.com', 'hashed_password', 1),
('Сидорова Мария Ивановна', '1992-08-20', 'sidorova@example.com', 'hashed_password', 2);

INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('Inception', (SELECT id FROM countries WHERE name = 'USA'), 148, 2010, 13, 'https://example.com/inception.jpg', 'https://www.kinopoisk.ru/film/447301/', 'https://example.com/inception.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('The Matrix', (SELECT id FROM countries WHERE name = 'USA'), 136, 1999, 16, 'https://example.com/matrix.jpg', 'https://www.kinopoisk.ru/film/301/', 'https://example.com/matrix.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('Amélie', (SELECT id FROM countries WHERE name = 'France'), 122, 2001, 12, 'https://example.com/amelie.jpg', 'https://www.kinopoisk.ru/film/12345/', 'https://example.com/amelie.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('Spirited Away', (SELECT id FROM countries WHERE name = 'Japan'), 125, 2001, 10, 'https://example.com/spirited_away.jpg', 'https://www.kinopoisk.ru/film/67890/', 'https://example.com/spirited_away.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('The Godfather', (SELECT id FROM countries WHERE name = 'USA'), 175, 1972, 18, 'https://example.com/godfather.jpg', 'https://www.kinopoisk.ru/film/123456/', 'https://example.com/godfather.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('City of God', (SELECT id FROM countries WHERE name = 'USA'), 130, 2002, 16, 'https://example.com/city_of_god.jpg', 'https://www.kinopoisk.ru/film/654321/', 'https://example.com/city_of_god.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('Pulp Fiction', (SELECT id FROM countries WHERE name = 'USA'), 154, 1994, 18, 'https://example.com/pulp_fiction.jpg', 'https://www.kinopoisk.ru/film/789012/', 'https://example.com/pulp_fiction.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('The Shawshank Redemption', (SELECT id FROM countries WHERE name = 'USA'), 142, 1994, 16, 'https://example.com/shawshank.jpg', 'https://www.kinopoisk.ru/film/654321/', 'https://example.com/shawshank.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('The Dark Knight', (SELECT id FROM countries WHERE name = 'USA'), 152, 2008, 13, 'https://example.com/dark_knight.jpg', 'https://www.kinopoisk.ru/film/1234567/', 'https://example.com/dark_knight.mp4');
INSERT INTO films (name, country_id, duration, year_of_issue, age, link_img, link_kinopoisk, link_video) VALUES
('Forrest Gump', (SELECT id FROM countries WHERE name = 'USA'), 142, 1994, 13, 'https://example.com/forrest_gump.jpg', 'https://www.kinopoisk.ru/film/7890123/', 'https://example.com/forrest_gump.mp4');

INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'Inception'), (SELECT id FROM categories WHERE name = 'Sci-Fi'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'The Matrix'), (SELECT id FROM categories WHERE name = 'Sci-Fi'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'Amélie'), (SELECT id FROM categories WHERE name = 'Romantic Comedy'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'Spirited Away'), (SELECT id FROM categories WHERE name = 'Fantasy Adventure'));

INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'The Godfather'), (SELECT id FROM categories WHERE name = 'Crime Thriller'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'City of God'), (SELECT id FROM categories WHERE name = 'Crime Thriller'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'Pulp Fiction'), (SELECT id FROM categories WHERE name = 'Crime Thriller'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'The Shawshank Redemption'), (SELECT id FROM categories WHERE name = 'Drama'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'The Dark Knight'), (SELECT id FROM categories WHERE name = 'Superhero'));

INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'Forrest Gump'), (SELECT id FROM categories WHERE name = 'Drama'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'Forrest Gump'), (SELECT id FROM categories WHERE name = 'Comedy'));
INSERT INTO categories_films (film_id, category_id) VALUES
((SELECT id FROM films WHERE name = 'Forrest Gump'), (SELECT id FROM categories WHERE name = 'Romance'));