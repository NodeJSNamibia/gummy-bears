<h1>API</h1>
<h3>Native Login</h3>
<h4>Client Request </h4>
<pre>
<p>
Request Type: POST
<br/>
Request Url: 
</pre>
</p>
<h6>Request Fields</h6>
<pre>
<ul>
  <li>student_number: String/Text Field Containing the student number of the user </li>
  <li>password: String/Password Field Containing the password of the user </li>
</ul>
</pre>
<h4> Server Resposne </h4>
<h6>Response Header </h6>
<p><strong>Failure Resposne Type</strong>: HTTP header with code <strong>500</strong> - User Could not be authenticated
<br/>
<strong>Success Response</strong>: HTTP Header with code <strong>200</strong> - Successful Authentication
</p>
<h6>JSON Response Failure</h6>
<pre>
<code>
response = {
message = 'Failure Message';
}
</code>
</pre>
<h6>JSON Response Success</h6>
<pre>
<code>
response = {name = 'Student Name', surname = 'Student Surname', student_number = 00000000,
faculty = 'Student Faculty', 'programme' = 'Student Programme'
}
</code>
</pre>
<h3>Request for Events</h3>
<pre>
  <p>
    Request url:
  <p>
</pre>
<h4>Server Response</h4>
<pre>
  <p>
    response = [{"id": "evt01",
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
    },
    {"id": "evt02",
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
    ]
  </p>
</pre>
