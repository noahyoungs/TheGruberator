/*
     Author: Noah Youngs
     Date: 2 December 2020
     Description: Message board app lets users log in and post messages with different degrees of urgency.
*/


import express from "express";
import bcrypt from 'bcrypt';
import cookieParser from 'cookie-parser';

import sqlite3 from "sqlite3";
import {open} from "sqlite";

import {grantAuthToken, lookupUserFromAuthToken} from "./auth";

export const dbPromise = open({
    filename: "data.db",
    driver: sqlite3.Database,
});

const app = express();

// pug view engine
app.set('view engine', 'pug')


app.use(cookieParser())
app.use(express.urlencoded({extended: false}));
app.use('/static', express.static(__dirname + '/static'));

app.use(async (req, res, next) => {
    const {authToken} = req.cookies;
    if (!authToken) {
        return next();
    }
    try {
        req.user = await lookupUserFromAuthToken(authToken);
    } catch (e) {
        return next({
            message: e,
            status: 500
        });
    }
    next();
})

let searchUsers = []

app.get("/", async (req, res) => {
    const db = await dbPromise;

    if (!req.user) {
        res.redirect('/login');
    }
    const userPrefs = await db.all("SELECT * FROM Users WHERE Users.id = ?", req.user.id);
    const restaurants = await db.all("SELECT * FROM Restaurants");


    let restaurant
    let user
    for (restaurant of restaurants) {
        let tempCount = 0;
        for (user of searchUsers) {
            tempCount += ((Math.abs(restaurant.fastFoodIndex - user.fastFoodIndex) +
                Math.abs(restaurant.priceIndex - user.priceIndex) +
                Math.abs(restaurant.americanIndex - user.americanIndex) +
                Math.abs(restaurant.mexicanIndex - user.mexicanIndex) +
                Math.abs(restaurant.chineseIndex - user.chineseIndex) +
                Math.abs(restaurant.pizzaIndex - user.pizzaIndex) +
                Math.abs(restaurant.alcoholIndex - user.alcoholIndex) +
                Math.abs(restaurant.musicIndex - user.musicIndex)) / 8)
        }
        restaurant.score = 1 - (tempCount / 3);
    }
    console.log('restaraunts', restaurants);


    console.log('user prefs', userPrefs);
    res.render("home", {userPrefs, user: req.user, searchUsers, restaurants});


});

app.get('/register', (req, res) => {
    if (req.user) {
        return res.redirect('/')
    }
    res.render('register')
})

app.get('/login', (req, res) => {
    if (req.user) {
        return res.redirect('/')
    }
    res.render('login')
})

app.post('/register', async (req, res) => {
    const db = await dbPromise;
    const {
        username,
        email,
        password
    } = req.body;
    const passwordHash = await bcrypt.hash(password, 10);
    try {
        await db.run('INSERT INTO Users (username, email, password) VALUES (?, ?, ?);',
            username,
            email,
            passwordHash
        )
        const user = await db.get('SELECT id FROM Users WHERE email=?', email);
        const token = await grantAuthToken(user.id)
        res.cookie('authToken', token);
        res.redirect('/');
    } catch (e) {
        return res.render('register', {error: e})
    }
})

app.post('/login', async (req, res) => {
    const db = await dbPromise;
    const {
        email,
        password
    } = req.body;
    try {
        const existingUser = await db.get("SELECT * FROM USERS WHERE email=?", email);
        if (!existingUser) {
            throw 'Incorrect login';
        }
        const passwordsMatch = await bcrypt.compare(password, existingUser.password);
        if (!passwordsMatch) {
            throw 'Incorrect login';
        }
        const token = await grantAuthToken(existingUser.id)
        res.cookie('authToken', token);
        res.redirect('/');
    } catch (e) {
        return res.render('login', {error: e})
    }
})

app.post('/logout', async (req, res) => {
    res.clearCookie('authToken');
    res.redirect('/');
});

app.post('/clear', async (req, res) => {
    searchUsers = [];
    res.redirect('/');
});
app.post("/add", async (req, res, next) => {
    if (!req.user) {
        return next({
            status: 401,
            message: 'must be logged in to do this'
        })
    }
    const db = await dbPromise;
    console.log("looking for username " + req.body.username)

    const addedUser = await db.get('SELECT * FROM Users WHERE username=?', req.body.username);

    if (!addedUser) {
        return next({
            status: 404,
            message: 'that is not a user'
        })
    }
    searchUsers.push(addedUser)
    console.log(" pushed username " + addedUser.username)
    console.log("search users: " + searchUsers)

    res.redirect('/');
})

app.post("/updateUserPrefs", async (req, res, next) => {

    if (!req.user) {
        return next({
            status: 401,
            message: 'must be logged in to do this'
        })
    }
    const db = await dbPromise;
    await db.run('Update Users SET fastFoodIndex = ?, priceIndex = ?, americanIndex = ?, mexicanIndex = ?, chineseIndex = ?, pizzaIndex = ?, alcoholIndex = ? , musicIndex = ? WHERE id = ?;',
        req.body.formFastFoodIndex, req.body.formPriceIndex, req.body.formAmericanIndex, req.body.formMexicanIndex, req.body.formChineseIndex, req.body.formPizzaIndex, req.body.formAlcoholIndex, req.body.formMusicIndex, req.user.id)
    res.redirect("/");

    console.log("updated user prefs for " + req.user)
})


// throw 404 error - it's important this is _below_ all the normal routes
app.use((req, res, next) => {
    next({
        status: 404,
        message: `${req.path} not found`
    })
})

// handle all errors
app.use((err, req, res, next) => {
    res.status(err.status || 500)
    console.log(err);
    res.render('errorPage', {error: err})
})

const setup = async () => {
    const db = await dbPromise;
    await db.migrate();

    app.listen(8080, () => {
        console.log("listening on http://127.0.0.1:8080");
    });
}

setup();