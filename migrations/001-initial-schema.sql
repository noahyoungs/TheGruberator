-- Up

CREATE TABLE Users
(
    id            INTEGER PRIMARY KEY,
    email         STRING UNIQUE,
    username      STRING,
    password      STRING,
    fastFoodIndex FLOAT DEFAULT 0.5 NOT NULL,
    priceIndex    FLOAT DEFAULT 0.5 NOT NULL,
    americanIndex FLOAT DEFAULT 0.5 NOT NULL,
    mexicanIndex  FLOAT DEFAULT 0.5 NOT NULL,
    chineseIndex  FLOAT DEFAULT 0.5 NOT NULL,
    pizzaIndex    FLOAT DEFAULT 0.5 NOT NULL,
    alcoholIndex  FLOAT DEFAULT 0.5 NOT NULL,
    musicIndex    FLOAT DEFAULT 0.5 NOT NULL

);

CREATE TABLE Restaurants
(
    id            INTEGER PRIMARY KEY,
    fastFoodIndex FLOAT DEFAULT 0.5 NOT NULL,
    priceIndex    FLOAT DEFAULT 0.5 NOT NULL,
    americanIndex FLOAT DEFAULT 0.5 NOT NULL,
    mexicanIndex  FLOAT DEFAULT 0.5 NOT NULL,
    chineseIndex  FLOAT DEFAULT 0.5 NOT NULL,
    pizzaIndex    FLOAT DEFAULT 0.5 NOT NULL,
    alcoholIndex  FLOAT DEFAULT 0.5 NOT NULL,
    musicIndex    FLOAT DEFAULT 0.5 NOT NULL,
    score         FLOAT,
    name          STRING,
    desc          STRING,
    addr          STRING

);

INSERT INTO Restaurants (id, fastFoodIndex, priceIndex, americanIndex, mexicanIndex, chineseIndex, pizzaIndex,
                         alcoholIndex, musicIndex, name, desc, addr)
VALUES (0, 0.2, 0.5, 1, 0.3, 0.2, 0.3, 0.8, 0.7, "Culinary Dropout", "American food, has a bar/Alcohol",
        "149 S Farmer Ave, Tempe, AZ 85281"),
       (1, 0.7, 0.4, 1, 0, 0, 0, 0.4, 0, "The Chuckbox",
        "American food, Cheeseburgers, Fries, Cheap eat, Fast Takeout/In door seating",
        "202 E University Dr, Tempe, AZ 85281"),
       (2, 0.7, 0.3, 0.5, 0, 0, 1, 0, 0, "Slices on Mill", "Takeout is common, minimal seating Pizza",
        "1 E 6th St #102, Tempe, AZ 85281"),
       (3, 1, 0.2, 1, 0.2, 0, 0, 0, 0, "Chick fil A",
        "Take Out, Closed Sundays - American food, Specialize in chicken, Waffle fries",
        "25 W University Dr, Tempe, AZ 85281"),
       (4, 0.3, 0.5, 0.5, 0, 0, 1, 0.5, 0, "Mellow Mushroom", "Pizza, American food, Sit down Pizza restaurant",
        "740 S Mill Ave, Tempe, AZ 85281"),
       (5, 0.5, 0.2, 0.1, 1, 0, 0, 0.6, 0, "Fuzzy’s Taco Shop", "Mexican, Taco, Serves Alcohol, Has in door seating",
        "414 S Mill Ave Suite 115, Tempe, AZ 85281"),
       (6, 0.7, 0.4, 0.3, 1, 0, 0, 0.2, 0, "Chipotle", "Mexican, Burrito, has minimal seating, Fast Food",
        "1038 S Mill Ave, Tempe, AZ 85281"),
       (7, 0.3, 0.5, 0.4, 0, 1, 0, 0.6, 0, "P.F. Chang’s", "American Chinese Food, Chinese, Chinese fusion",
        "740 S Mill Ave #140, Tempe, AZ 85281"),
       (8, 0.7, 0.3, 0.3, 0, 1, 0, 0, 0, "Panda Express", "American Chinese Food, Chinese, Fast Food",
        "777 S College Ave, Tempe, AZ 85281"),
       (9, 0, 0.5, 1, 0, 0, 0, 1, 1, "Rodeo Ranch",
        "American Food, Burger, Serves Alcohol, Open Late Night, Turns into a Club at Night, Has Live music and DJ’s, Has mechanical Bull.",
        "501 S Mill Ave #101, Tempe, AZ 85281");



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
