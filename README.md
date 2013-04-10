FundraisingSSETracker

Track 'em funds

To Set Up:
---------

1. Install [PostgreSQL](http://www.postgresql.org/)
2. Install [NodeJS](http://www.nodejs.org/)
3. Navigate to repo root
2. `psql < [repo_root]/config/dbsetup.psql` 
(you may have to put "-U postgres" after psql to set a user)
4. `bundle install`

To Run the Scanning Script:
---------------------------
1. Be connected to internet
2. `cd [repo_root]/scanscripts`
3. `ruby ProgramStart.rb`

To Run the Webapp:
------------------
1. `cd [repo_root]/web`
2. `ruby site.rb`
