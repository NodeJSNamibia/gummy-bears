<h1>API</h1>
</h3>Native Login</h3>
<h4>Client Request </h4>
<p>
Request Type: POST
<br/>
Request Url: 
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
