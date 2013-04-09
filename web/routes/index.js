
/*
 * GET home page.
 */

exports.index = function(req, res){
  var pg = require('pg').native
  , connectionString = process.env.DATABASE_URL || 'postgres://localhost:5432/fundraising'
  , client
  , query;

  client = new pg.Client(connectionString);

  client.connect(function(err) {
    client.query('select * from items, inventory where items.upc = inventory.item_upc;', function(err, result) {
        res.render('index', { title: 'Express', result: result.rows});
        client.close();
    })
  });
  
  };