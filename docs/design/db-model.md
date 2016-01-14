# Data Base Model

## Introduction

This document discusses the *data model* of the **Orientation Week Application (o'week)**. Essentially, we provide a list of events organized during the orientation week to freshers within their first week at varsity. The data model comprises the *student information*, the *academic structure* of the institution and the *events* scheduled throughout the orientation week.

The data model of this application will be implemented using [CouchBase](http://www.couchbase.com), a **NoSQL** document store. *CouchBase* offers a *distributed caching* system as well as the mechanichs of a *document store*.

## The Model

The following objects will be discussed in our data model:

* Student information
* Technical Users
* Faculty information
* Events
* News and Notifications
* Login Records
* Frequently Asked Questions

### Student Information

A student information object can be represented as follows:

```json
{
    "studentNumber": 09873422344,
    "firstName": "Alex",
    "lastName": "Jones",
    "emailAddresses": ["alex.jones@gmail.com","ajones@nust.na"],
    "title": "Mr",
    "nationality": "Namibian",
    "yearOfStudy": "first",
    "modeOfStudy": "FM",
    "password": "@da33409DDff",
    "homeAddress": {
        "address line 1": "4 Storch Street",
        "address line 2": "Private Bag 12890"
    },
    "courses": ["course1", "course2"],
    "programme": "80BHSE"
}
```
Most attributes in the object are self explanatory. A student can declare several email addresses and can be reached through any one of these email addresses. The **yearOfStudy** attribute can have one of the following values: *first*, *second*, *third* and *honours*. As for the **modeOfStudy** it can have two possible values *PM* and *FM*. Finally, the **programme** attribute holds the actual code of the programme within a faculty that a student is being enrolled for.

### Technical Users

Beside the students who represent the main users of the application, we consider another type of user: *technical user*. Such a user can fulfill two possible functions, populate the data needed for the application and taking corrective measures whenever some faulty component of the application is identified. A technical user object can be represented as exemplified below. Note that we use the **profile** attribute to distinguish between the *admin* profile and the *maintainer* profile.

```json
{
    "username": "samjo",
    "firstName": "Samuel",
    "lastName": "Jackson",
    "emailAddress": "samuel.jackson.gmail.com",
    "office": {
        "department": "DOS",
        "location": "location3",
        "door": "A5"
    },
    "profile": "admin",
    "password": "@da33409DDff"
}
```

### Faculty

Here we group together every information that belongs to the academic structure of the universtiy. Overall, a faculty object is represented as follows:

```json
{
    "id": "fci",
    "name": "Faculty of Computing and Informatics",
    "contact": {
        "email": "secretary.fci@nust.na",
        "telephone": "+264612071189"
    },
    "departments": [{},{}]
}
```

Each **department** is represented as follows:

```json
{
    "code": "CS",
    "name": "Computer Science",
    "contact": {
        "emailAddress": "secretary.csdpt@nust.na",
        "telephone": "+264612070011"
    },
    "programmes": [{}, {}]
}
```

A **programme** is represented as follows:

```json
{
    "code": "80BHSE",
    "name": "Bachelor Degree Computer Science, Strand Software Engineering",
    "courses": [{},{}]
}
```

Each **course** within a programme is represented as follows:

```json
{
    "code": "DSP620S",
    "title": "Distributed Systems Programming",
    "description": "provide a general description of the course",
    "semester": 4,
    "contact": {
        "emailAddress": "dsp@nust.na",
        "telephone": "+264612070011",
        "firstName": "Alek",
        "lastName": "Kourov"
    },
    "timetable": [{
            "dayOfWeek": "Monday",
            "time": "11:00-12:00",
            "mode": "FM",
            "tag": "Theory",
            "venue": "Auditorium 3"
        },
        {
            "dayOfWeek": "Friday",
            "time": "09:00-12:00",
            "mode": "FM",
            "tag": "Practicals",
            "venue": "lab2"
        }
    ]
}
```

Given that some queries might want access to components within a faculty object, we will use indexes to support and make such accesses faster.

### Events

A event organized during the orientation week can be represented as follows:

```json
{
    "id": "evt01",
    "description": "event description",
    "start": "2015-12-12 11:00",
    "end": "2015-12-12 13:00",
    "location": "location3",
    "faculty": "fci",
    "organizer": {
        "firstName": "Tellus",
        "lastName": "Normand",
        "title": "Dr",
        "emailAddress": "telNormand@gmail.com"
    }
}
```

### Quick Notifications

All announcements and general news of the university to be passed down to students can be represented as follows:

```json
{
    "id": "infoID",
    "content": "What is the announcement all about?",
    "type": "announcement",
    "details": {}
}
```
Note that the **details** attribute is an object that allows to provide further information about the news being described.

### Login Records

For statistics purposes we wish to record everytime a student logs into the application successfully.

```json
{
    "id": "0092334",
    "studentNumber": 09873422344,
    "date": "11/12/2015",
    "time": "11:00"
}
```

### Frequently Asked Questions

In order to offer a place where students can find answers to usual questions, we compile such questions into the database. Each question is represented as follows:

```json
{
    "id": "faq001",
    "question": "A stupid questid",
    "answer": "a smart subtle response"
}
```
