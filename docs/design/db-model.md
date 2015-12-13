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

A student user will be modeled as follows:
```json
{
    "studentNumber": 09873422344,
    "firstName": "Alex",
    "lastName": "Jones",
    "emailAddresses": ["alex.jones@gmail.com","ajones@nust.na"],
    "gender": "Male",
    "nationality": "Namibian",
    "yearOfStudy": "first",
    "modeOfStudy": "FM",
    "password": "@da33409DDff",
    "homeAddress": {
        "street": "Storch",
        "number": 4,
        "city": "Windhoek",
        "region": "Khomas",
        "country": "Namibia",
        "telephone": "+264612079978"
    },
    "programme": "80BHSE"
}
```

The "yearOfStudy" attribute can have one of the following values: "first", "second", "third"

### Other Users
There are two other types of users: *admin* and *maintainer*. We represent such users as follows:
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
A faculty object

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

Each *department* is represented as follows:

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

A *programme* is represented as follows:

```json
{
    "code": "80BHSE",
    "name": "Bachelor Degree Computer Science, Strand Software Engineering",
    "courses": [{},{}]
}
```

Each *course* within a programme is represented as follows:

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
        "tag": "Theory"
        }]
}
```

### Events

```json
{
    "id": "evt01",
    "description": "event description",
    "date": "12/12/2015",
    "start": "11:00",
    "ends": "13:00",
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

```json
{
    "id": "infoID",
    "content": "What is the announcement all about?",
    "type": "announcement",
    "details": {}
}
```

### Login Records

```json
{
    "id": "0092334",
    "studentNumber": 09873422344,
    "date": "11/12/2015",
    "time": "11:00"
}
```

### Frequently Asked Questions

```json
{
    "id": "faq001",
    "question": "A stupid questid",
    "answer": "a smart subtle response"
}
```
