#!/usr/bin/env node

// $ npm install pg

const { Client } = require('pg');
const connection = require('./connection.json');
const client = new Client(connection);

client.connect();

const query = `
SELECT
  json_build_object(
	'publication_id', isj_publication.id,  /* ID */
	'hola', 'hola'  /* ID */
  )
FROM
  isj_publication
ORDER BY
  isj_publication.id ASC
`;

var hola
client
  .query(query)
  .then(res => {
    console.log('Publication:');
    hola = JSON.stringify(res.rows[1])
    // for (let row of res.rows) {
      // console.log(JSON.stringify(row.json_build_object));
    // }
    client.end();
});

console.log(hola);

