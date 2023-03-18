# Where's Waldo API

---

## Description

This is a "Where's Waldo?" web application that models the gameplay of the homonymous children's puzzle, where the player is tasked with visually locating characters within a richly detailed image.

The app is composed of a React/TypeScript front-end that communicates with a Ruby on Rails back-end designed as a JSON API with RESTful routing and persists data using a PostgreSQL database.

### **Note:**

This repository contains code for only the back-end part of the app. The repository for the front-end is at [wheres-waldo](https://github.com/royojeda/wheres-waldo).

_Other tools used in the back-end include PostgreSQL and RuboCop._

---

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Reflections](#reflections)

---

## Installation

There are a couple of ways to run the application:

1. The easier way is to visit the [online live preview](https://waldo.fly.dev/). This preview includes the front-end interface.

2. The other option is to clone the repository to your computer by running the following command in the command line (you must have **Git** and **Ruby on Rails** installed):

   ```bash
   git clone git@github.com:royojeda/wheres-waldo-api.git
   ```

   and then run:

   ```bash
   cd wheres-waldo-api
   ```

   to enter the project directory, run

   ```
   bundle install
   ```

   to install the project dependencies, and finally, run:

   ```
   ./bin/dev
   ```

   to start the local development server.

---

## Usage

The API is designed to follow a REST convention. There are two resources defined in this application: Characters and Games.

The Character model holds information about character names and locations by way of relative x and y coordinates.

The Game model stores data about every playthrough. It includes the Game's start time and end time, as well as the player's submitted name. Each Game instance `has_many` Characters via an ActiveRecord association for keeping track of the Game's assigned characters.

The supported endpoints are:

```
GET /characters/
```

This request returns a randomly selected set of four-character objects with their `id` and `name` attributes. This is intended to be called upon the application's initial load to give the user an idea of which characters they'll need to find.

**Important:** The response will reset the session and set `session[:characters]` to the randomly selected characters. This session data will be referred to when creating or indexing Games to ensure that the user cannot tamper with the character assignments.

--

```
GET /characters?name={character_name}&x_coordinate={character_x_coordinate}&y_coordinate={character_y_coordinate}
```

This request is supposed to represent each of the user's guesses for a Character's location. The response contains a Character object with their `id`, `name`, `x_coordinate`, and `y_coordinate` whose details match the query parameters (or empty if none match).

**Important:** To make a succesful request of this kind, `session[:timer_started]` must be `true`. The intention is to only allow the user to make guesses if the Game's start time has been recorded. This flag is set during Game creation.

--

```
GET /games
```

This request returns an array of Game objects having the same set of Characters (regardless of order) as the one saved in `session[:characters]`. This is useful for constructing a "high score" display. The response includes an array of matching Game objects, containing their `id` and `player_name` attributes, along with a computed `score` attribute representing the time in seconds between the Game's start time and end time.

--

```
POST /games
```

This request allows the creation of Game instances. There are no required parameters. The current time at the moment of receiving the request is recorded as the start time. The response is a Game object with only its `id` attribute.

**Important:** The `session[:timer_started]` is set to true after receiving this request to indicate that the user is allowed to make guesses as the Game's start time has been recorded.

--

```
POST /games/{game_id}
```

This request is for updating Game instances. Specifically, it allows the player name and end time to be recorded after a Game is finished. The client must send either a `player_name` string or a `found_characters` array as parameters with the request. Both of these attributes cannot be changed again after initially setting a non-nil value.

If a `found_characters` array is found in the parameters, a validation is performed to check whether the correct set of characters are found in their correct locations before recording the current time as the Game's end time.

No validation is required when setting a player name.

---

## Features

- **Predictable routing**. Following REST conventions, the routes are simplified to Create, Read, and Update actions on the domain models. This makes it easily understandable for developers who are familiar with REST design.

- **Security with the Rails session cookie**. In an effort to prevent tampering with the models' values, some key-value pairs are set and read in the session. As an example, users are not allowed to make guesses unless `session[:timer_started]` is true. It will only have the desired value if the client makes the appropriate request to trigger the start of a timer that happens whenever a Game instance is created.

- **User guess evaluation algorithm**. A custom algorithm for determining the correctness of a user's guess is written on the Character model. While exact values of x and y coordinates are saved for each Character, the user's guess will be accepted if it's close enough to the exact answer by using a variable called `scale_factor`. This scale factor, along with some computations, can check whether a user's guess is correct or incorrect, regardless of the actual size of the main image on the user's device. This means that the algorithm works for any screen resolution, from narrow mobile displays to wide desktop monitors.

---

## Reflections

Initially, I had difficulty conceptualizing the models needed for this application. I had always previously put all of the business logic on the front-end when developing JavaScript and React web applications. Eventually, I arrived at the current implementation and am reasonably pleased to have met the project requirements.

It has been a few months since I worked with Rails, as I spent recent time deep-diving into JavaScript and then familiarizing myself with React. During this time, I realized just how much faster Rails is able to accelerate the development process by enforcing its conventions.
