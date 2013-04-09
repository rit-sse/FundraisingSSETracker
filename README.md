FundraisingSSETracker

Track 'em funds

To Set Up:
---------

1. Install [PostgreSQL](http://www.postgresql.org/)
2. Install [NodeJS](http://www.nodejs.org/)
3. Navigate to repo root
2. `psql < [repo_root]/config/dbsetup.psql`
3. `cd scanscripts`
4. `bundle install`
3. `cd ../web`
4. `npm install`

To Run the Scanning Script:
---------------------------
1. `cd [repo_root]/scanscripts`
2. `ruby ProgramStart.rb`

To Run the Webapp:
------------------
1. `cd [repo_root]/web`
2. `node app`
