-- Up
CREATE TABLE Messages
(
    id       INTEGER PRIMARY KEY,
    authorId INTEGER,
    content  STRING,
    kind     INTEGER,
    FOREIGN KEY (authorId) REFERENCES Users (id)
);

CREATE TABLE Users
(
    id            INTEGER PRIMARY KEY,
    email         STRING UNIQUE,
    username      STRING,
    password      STRING,
    fastFoodIndex FLOAT DEFAULT 0.5,
    priceIndex    FLOAT DEFAULT 0.5,
    americanIndex FLOAT DEFAULT 0.5,
    mexicanIndex  FLOAT DEFAULT 0.5,
    chineseIndex  FLOAT DEFAULT 0.5,
    pizzaIndex    FLOAT DEFAULT 0.5,
    alcoholIndex  FLOAT DEFAULT 0.5,
    musicIndex    FLOAT DEFAULT 0.5,

);

CREATE TABLE AuthTokens
(
    id     INTEGER PRIMARY KEY,
    token  STRING,
    userId INTEGER,
    FOREIGN KEY (userId) REFERENCES Users (id)
);

-- Down
DROP TABLE Messages;
DROP TABLE Users;
DROP TABLE AuthTokens;
