# Reactive Dashboard (Multi database setup)

The application consists with multiple databases, composite primary keys and
reactive UI interface that would be update when a database change occur in relation
to page that user currently viewing.

## Ruby/Rails version

- Ruby 3.0.1
- Rails 7.0.3

## Configuration

Change the `database.yml` according to your local configurations. TO work with multiple
databases keep the those configuration intact.

## Database creation

Run the following commands to create and setup the database.

    bundle exec rake db:create
    bundle exec rake db:setup`

## Start the server

Start the local server by the following command.

    bin/dev

This will start the server in the port 3000 and you can visit the site with: http://localhost:3000/

## Questions

> 1. If you had more time, what would you change or focus more time on ?
>       
>> Would have more focused on the UIs more that refine the interfaces and do more testing
>> functionality of UI updates on database changes more. Also would have able to add more 
>> validations to form and other user inputs. Would have research more into websocket capabilities
>> that can be integrated to rails. I have developed this application using "Postgresql" because
>> it is already setup in my machine. With more time I could have tried with "Mysql" database.
> 
> 2. Which part of the solution consumed the most amount of time?
>
>> Most time consuming part was when setting up "Actioncable" with multiple javascript libraries and
>> Subsequently implementing the websocket functions throughout the application because it was somewhat
>> unorthodox.
> 
> 3. What would you suggest to the clinicians that they may not have thought of in regard to their request ?
> 
>> Using "name", "birthdate" as a unique composite primary key was a not a good approach and the clinicians 
>> should have thought about different version of name can exists such a middle name can be shortened or there 
>> could be multiple spellings of a name that pronounce the same. If possible and having a single database would be
>> more efficient too. 

## License

Reactive Dashboard (Multi database setup) is released under the [MIT License](https://opensource.org/licenses/MIT).

## Developer

Name: [Banura Randika Perera](https://github.com/randikabanura) <br/>
Linkedin: [randika-banura](https://www.linkedin.com/in/randika-banura/) <br/>
Email: [randika.banura@gamil.com](mailto:randika.banura@gamil.com) <br/>
Bsc (Hons) Information Technology specialized in Software Engineering (SLIIT) <br/>