# Data Base Model

## Introduction
Introduce couchbase and discuss the database in general


## The Model

### Students
A student user will be modeled as follows:
'''json
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
    programme: "80BHSE"
}
'''

The "yearOfStudy" attribute can have one of the following values: "first", "second", "third"

### Other Users
There are two other types of users: *admin* and *maintainer*. We represent such users as follows:
'''json
{
    "username": "samjo",
    "firstName": "Samuel",
    "lastName": "Jackson",
    "emailAddress": "samuel.jackson.gmail.com",
    office: {
        "department": "DOS",
        "location": "location3",
        door: "A5"
    },
    "profile": "admin"
}
'''

### Faculty
A faculty object

'''json
{
    "id": "fci",
    "name": "Faculty of Computing and Informatics",
    "contact": {
        "email": "secretary.fci@nust.na",
        "telephone": "+264612071189"
    },
    "departments": [{},{}]
}
'''

Each *department* is represented as follows:

'''json
'''
