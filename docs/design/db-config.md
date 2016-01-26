# DataBase Configuration

As indicated in the database design model, we chose [CouchBase](http://www.couchbase.com), a **NoSQL** document store, for our data persistence. Once the installation of the Couchbase server completed, the additional configuation steps involved creating the **buckets** and the **Map-Reduce** views.

## Buckets

In line with the design document we cerated **8** buckets. These are:
* student, to store the student information
* technical_user, to store information related to technical users of the application (admin and maintenance people)
* faculty, which describes the academic structure of the whole institution
* location, to keep track of all the places of interest on campus
* event, to describe all the events taking place during the orientation week
* faq, to provide an easy access to frequently asked questions
* login-record, to keep track of every successful login by a students
* quick-note, for quick notification as things unfold

## Map-Reduce Views

In Couchbase a Map-Reduce view is an index that provides a faster access to a collection of documents. In order to create an MR view, one needs to create a design document, where the view will be stored. Our views generally have the same name as the bucket. As for the design documents, we add a \_dd suffix.
