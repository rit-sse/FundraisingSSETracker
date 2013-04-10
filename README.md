FundraisingSSETracker
=====================

Track 'em funds

To Set Up:
---------

1. Install [PostgreSQL](http://www.postgresql.org/)
3. Navigate to repo root
2. `psql < [repo_root]/config/dbsetup.psql`
4. `bundle install`

To Run the Scanning Script:
---------------------------
1. `cd [repo_root]/scanscripts`
2. `ruby ProgramStart.rb`

To Run the Webapp:
------------------
1. `cd [repo_root]/web`
2. `ruby site.rb`
